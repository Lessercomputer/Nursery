//
//  NUSourceFile.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/16.
//

#import "NUCSourceFile.h"
#import "NULibrary.h"
#import "NURegion.h"
#import "NUCRangePair.h"
#import "NUCLexicalElement.h"
#import "NUCLineMapping.h"
#import "NUCLine.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPreprocessingFile.h"

#import <Foundation/NSString.h>
#import <Foundation/NSScanner.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSCharacterSet.h>

@implementation NUCSourceFile

static NSCharacterSet *newlineAndBackslashCharacterSet;

@synthesize url;
@synthesize lineRanges;
@synthesize file;

+ (void)initialize
{
    NSMutableCharacterSet *aNewlineAndBackslashCharacterSet = [[NUCLexicalElement NUCNewlineCharacterSet] mutableCopy];
    [aNewlineAndBackslashCharacterSet addCharactersInString:NUCBackslash];
    newlineAndBackslashCharacterSet = [aNewlineAndBackslashCharacterSet copy];
    [aNewlineAndBackslashCharacterSet release];
}

+ (NSCharacterSet *)newlineAndBackslashCharacterSet
{
    return newlineAndBackslashCharacterSet;
}

- (instancetype)initWithSourceURL:(NSURL *)aURL
{
    return [self initWithSourceString:[NSString stringWithContentsOfURL:aURL usedEncoding:NULL error:NULL] url:aURL];
}

- (instancetype)initWithSourceString:(NSString *)aString url:(NSURL *)aURL
{
    if (self = [super init])
    {
        url = [aURL copy];
        physicalSourceString = [aString copy];
    }
    
    return self;
}

- (void)dealloc
{
    [url release];
    url = nil;
    [file release];
    [physicalSourceString release];
    physicalSourceString = nil;
    [logicalSourcePhase1String release];
    logicalSourcePhase1String = nil;
    [logicalSourceString release];
    logicalSourceString = nil;
    [rangeMappingOfPhase1StringToPhysicalString release];
    [lineRangeMappingOfPhase2StringToPhase1String release];
    [preprocessingFile release];
    [lineRanges release];
    
    [super dealloc];
}

- (NUCPreprocessingFile *)preprocessingFile
{
    return preprocessingFile;
}

- (void)setPreprocessingFile:(NUCPreprocessingFile *)aPreprocessingFile
{
    [preprocessingFile release];
    preprocessingFile = [aPreprocessingFile retain];
}

- (void)preprocessFromPhase1ToPhase2
{
    [self preprocessPhase1];
    [self preprocessPhase2];
}

- (void)preprocessPhase1
{
    NSScanner *aScanner = [NSScanner scannerWithString:[self physicalSourceString]];
    
    NSMutableString *aLogicalSourceStringInPhase1 = [NSMutableString string];
    
    rangeMappingOfPhase1StringToPhysicalString = [[NULibrary libraryWithComparator:[NUCRangePairFromComparator comparator]] retain];
    
    [aScanner setCharactersToBeSkipped:nil];
    
    while (![aScanner isAtEnd])
    {
        NSUInteger aScanLocation = [aScanner scanLocation];
        NSString *aScannedString = nil;
        
        if ([aScanner scanString:NUCTrigraphSequenceBeginning intoString:NULL])
        {
            if ([aScanner scanString:NUCTrigraphSequenceEqual intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceHash];
            else if ([aScanner scanString:NUCTrigraphSequenceLeftBlacket intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceLeftSquareBracket];
            else if ([aScanner scanString:NUCTrigraphSequenceSlash intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceBackslash];
            else if ([aScanner scanString:NUCTrigraphSequenceRightBracket intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceRightSquareBracket];
            else if ([aScanner scanString:NUCTrigraphSequenceApostrophe intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceCircumflex];
            else if ([aScanner scanString:NUCTrigraphSequenceLeftLessThanSign intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceLeftCurlyBracket];
            else if ([aScanner scanString:NUCTrigraphSequenceQuestionMark intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceVerticalbar];
            else if ([aScanner scanString:NUCTrigraphSequenceGreaterThanSign intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceRightCurlyBracket];
            else if ([aScanner scanString:NUCTrigraphSequenceHyphen intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceTilde];
            else
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceBeginning];
            
            if (aScanLocation != [aScanner scanLocation])
            {
                NUCRangePair *aRangePair = [NUCRangePair rangePairWithRangeFrom:NUMakeRegion([aLogicalSourceStringInPhase1 length], 1) rangeTo:NUMakeRegion(aScanLocation, 3)];
                
                [rangeMappingOfPhase1StringToPhysicalString setObject:aRangePair forKey:aRangePair];
            }
        }
        else if ([aScanner scanUpToString:NUCTrigraphSequenceBeginning intoString:&aScannedString])
        {
            [aLogicalSourceStringInPhase1 appendString:aScannedString];
        }
    }
    
    [self setLogicalSourcePhase1String:aLogicalSourceStringInPhase1];
}

- (void)preprocessPhase2
{
    NSMutableString *aLogicalSourceStringInPhase2 = [NSMutableString string];
   
    NSScanner *aScanner = [NSScanner scannerWithString:[self logicalSourcePhase1String]];
    [aScanner setCharactersToBeSkipped:nil];
    NSCharacterSet *aNewlineAndBackslashCharacterSet = [[self class] newlineAndBackslashCharacterSet];
    NSUInteger aScanLocation = [aScanner scanLocation];
    NSMutableArray *aLineRanges = [NSMutableArray array];
    NSUInteger aLineStartLocationInPhase2 = 0;
    BOOL aShouldSpliceNextLine = NO;
    NSUInteger aLineNumber = 1;
    
    while (![aScanner isAtEnd])
    {
        NSString *aScannedString = nil;

        if ([aScanner scanUpToCharactersFromSet:aNewlineAndBackslashCharacterSet intoString:&aScannedString])
            [aLogicalSourceStringInPhase2 appendString:aScannedString];
        
        NSString *aNewLineString = nil;
        NSValue *aLineRangeInPhase1 = nil;
        
        if (([aScanner scanString:NUCCRLF intoString:&aNewLineString]
            || [aScanner scanString:NUCLF intoString:&aNewLineString]
            || [aScanner scanString:NUCCR intoString:&aNewLineString]))
        {
            [aLogicalSourceStringInPhase2 appendString:aNewLineString];
            aLineRangeInPhase1 = [NSValue valueWithRange:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation)];
            NSRange aLineRangeInPhase2 = NSMakeRange(aLineStartLocationInPhase2, [aLogicalSourceStringInPhase2 length] - aLineStartLocationInPhase2);
            
            if (aShouldSpliceNextLine)
            {
                NUCLineMapping *aLineMapping = [aLineRanges lastObject];
                [aLineMapping setLineRange:aLineRangeInPhase2];
                [aLineMapping addOtherLineRange:aLineRangeInPhase1];
            }
            else
            {
                NUCLineMapping *aLineMapping = [NUCLineMapping lineMappingWithLineRange:aLineRangeInPhase2];
                [aLineMapping addOtherLineRange:aLineRangeInPhase1];
                [aLineMapping setLineNumber:aLineNumber++];
                [aLineRanges addObject:aLineMapping];
            }
            
            aLineStartLocationInPhase2 = NSMaxRange(aLineRangeInPhase2);
            aScanLocation = [aScanner scanLocation];
            aShouldSpliceNextLine = NO;
        }
        else if ([aScanner scanString:NUCBackslash intoString:NULL])
        {
            if ([aScanner scanString:NUCCRLF intoString:&aNewLineString]
                 || [aScanner scanString:NUCLF intoString:&aNewLineString]
                 || [aScanner scanString:NUCCR intoString:&aNewLineString])
            {
                aLineRangeInPhase1 = [NSValue valueWithRange:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation)];
                
                if (aShouldSpliceNextLine)
                    [[aLineRanges lastObject] addOtherLineRange:aLineRangeInPhase1];
                else
                {
                    NUCLineMapping *aLineMapping = [NUCLineMapping lineMapping];
                    [aLineMapping addOtherLineRange:aLineRangeInPhase1];
                    [aLineMapping setLineNumber:aLineNumber++];
                    [aLineRanges addObject:aLineMapping];
                }

                aScanLocation = [aScanner scanLocation];
                aShouldSpliceNextLine = YES;
            }
            else
                [aLogicalSourceStringInPhase2 appendString:NUCBackslash];
        }
    }
        
    [self setLogicalSourceString:aLogicalSourceStringInPhase2];
    [self setLineRanges:aLineRanges];
    [self updateLineRangeLibrary];
}

- (void)setLineRanges:(NSArray *)aLines
{
    [lineRanges autorelease];
    lineRanges = [aLines copy];
}

- (void)updateLineRangeLibrary
{
    [lineRangeMappingOfPhase2StringToPhase1String autorelease];
    lineRangeMappingOfPhase2StringToPhase1String = [NULibrary new];
    
    [[self lineRanges] enumerateObjectsUsingBlock:^(NUCLineMapping * _Nonnull aLineMapping, NSUInteger idx, BOOL * _Nonnull stop) {
        [lineRangeMappingOfPhase2StringToPhase1String setObject:aLineMapping forKey:aLineMapping];
    }];
}

- (NSString *)physicalSourceString
{
    return physicalSourceString;
}

 - (NSString *)logicalSourceString
{
    return logicalSourceString;
}

- (void)setLogicalSourceString:(NSString *)aString
{
    [logicalSourceString autorelease];
    logicalSourceString = [aString copy];
}

- (NSString *)logicalSourcePhase1String
{
    return logicalSourcePhase1String;
}

- (void)setLogicalSourcePhase1String:(NSString *)aString
{
    [logicalSourcePhase1String autorelease];
    logicalSourcePhase1String = [aString copy];
}

- (NSUInteger)lineNumberForLocation:(NSUInteger)aLocation
{
    return [self lineNumberForLocation:aLocation adjustmentOffset:[self lineNumberAdjustmentOffset]];
}

- (NSUInteger)lineNumberForLocation:(NSUInteger)aLocation adjustmentOffset:(NSInteger)anOffset
{
    id aKey = [NUCLineMapping lineMappingWithLineRange:NSMakeRange(aLocation, 0)];
    NUCLineMapping *aLineMapping = [lineRangeMappingOfPhase2StringToPhase1String keyLessThanOrEqualTo:aKey];
    
    if (aLineMapping && [aLineMapping containsLocation:aLocation])
        return [aLineMapping lineNumber] - anOffset;

    return NSNotFound;
}

- (NSUInteger)lineCount
{
    return [[self lineRanges] count];
}

- (void)line:(NUCLine *)aLine
{
    NSUInteger aLineNumber = [self lineNumberForLocation:[[aLine hash] range].location adjustmentOffset:0];
    
    if (aLineNumber != NSNotFound)
    {
        NSInteger aNextLineNumber = aLineNumber + 1;
        [self setLineNumberBeforeAdjustment:aNextLineNumber];
        [self setLineNumberAdjustmentOffset:aNextLineNumber - [[aLine digitSequence] integerValue]];
        
        if ([[aLine sCharSequence] length])
            [self setFile:[aLine sCharSequence]];
    }
}

- (NSString *)file
{
    if (file)
        return file;
    else
        return [[self url] path];
}

- (void)setFile:(NSString *)aFile
{
    [aFile autorelease];
    file = [aFile copy];
}

- (NSString *)preprocessedString
{
    return [[self preprocessingFile] preprocessedString];
}

@end
