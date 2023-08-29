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

#import <Foundation/NSString.h>
#import <Foundation/NSScanner.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSCharacterSet.h>

@implementation NUCSourceFile

static NSCharacterSet *newlineAndBackslashCharacterSet;

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
    [physicalSourceString release];
    physicalSourceString = nil;
    [logicalSourcePhase1String release];
    logicalSourcePhase1String = nil;
    [logicalSourceString release];
    logicalSourceString = nil;
    [rangeMappingOfPhase1StringToPhysicalString release];
    [rangeMappingOfPhase2StringToPhase1String release];
    [preprocessingFile release];
    
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
    NSMutableArray *aLines = [NSMutableArray array];
    BOOL aShouldSpliceNextLine = NO;
    
    while (![aScanner isAtEnd])
    {
        NSString *aScannedString = nil;

        if ([aScanner scanUpToCharactersFromSet:aNewlineAndBackslashCharacterSet intoString:&aScannedString])
            [aLogicalSourceStringInPhase2 appendString:aScannedString];
        
        NSString *aNewLineString = nil;
        NSValue *aLineRange = nil;
        
        if (([aScanner scanString:NUCCRLF intoString:&aNewLineString]
            || [aScanner scanString:NUCLF intoString:&aNewLineString]
            || [aScanner scanString:NUCCR intoString:&aNewLineString]))
        {
            [aLogicalSourceStringInPhase2 appendString:aNewLineString];
            aLineRange = [NSValue valueWithRange:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation)];
            [self addLineRange:aLineRange to:aLines spliceLine:aShouldSpliceNextLine];
            
            aScanLocation = [aScanner scanLocation];
            aShouldSpliceNextLine = NO;
        }
        else if ([aScanner scanString:NUCBackslash intoString:NULL])
        {
            if ([aScanner scanString:NUCCRLF intoString:&aNewLineString]
                 || [aScanner scanString:NUCLF intoString:&aNewLineString]
                 || [aScanner scanString:NUCCR intoString:&aNewLineString])
            {
                aLineRange = [NSValue valueWithRange:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation)];
                [self addLineRange:aLineRange to:aLines spliceLine:aShouldSpliceNextLine];

                aScanLocation = [aScanner scanLocation];
                aShouldSpliceNextLine = YES;
            }
            else
                [aLogicalSourceStringInPhase2 appendString:NUCBackslash];
        }
    }
        
    [self setLogicalSourceString:aLogicalSourceStringInPhase2];
}

- (void)addLineRange:(NSValue *)aLineRange to:(NSMutableArray *)aLines spliceLine:(BOOL)aShouldSpliceNextLine
{
    if (aShouldSpliceNextLine)
    {
        id aRangeOrArray = [aLines lastObject];
        if ([aRangeOrArray isKindOfClass:[NSValue class]])
        {
            NSMutableArray *aLineRangeArray = [NSMutableArray arrayWithObject:aRangeOrArray];
            [aLineRangeArray addObject:aLineRange];
            [aLines replaceObjectAtIndex:[aLines count] - 1 withObject:aLineRangeArray];
        }
        else
            [aRangeOrArray addObject:aLineRange];
    }
    else
        [aLines addObject:aLineRange];
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
    return NSNotFound;
}

- (NSMutableArray *)computeLineRangesOf:(NSString *)aString
{
    NSMutableArray *aLineRanges = [NSMutableArray array];
    NSScanner *aScanner = [NSScanner scannerWithString:aString];
    [aScanner setCharactersToBeSkipped:nil];
    
    while (![aScanner isAtEnd])
    {
        NSUInteger aLocation = [aScanner scanLocation];
        [aScanner scanUpToCharactersFromSet:[NUCLexicalElement NUCNewlineCharacterSet] intoString:NULL];
        [aScanner scanString:NUCLF intoString:NULL] || [aScanner scanString:NUCCRLF intoString:NULL] || [aScanner scanString:NUCCR intoString:NULL];
        [aLineRanges addObject:[NSValue valueWithRange:NSMakeRange(aLocation, [aScanner scanLocation] - aLocation)]];
    }
    
    return aLineRanges;
}

@end
