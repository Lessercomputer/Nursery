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

@implementation NUCSourceFile

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
    
    logicalSourcePhase1String = [aLogicalSourceStringInPhase1 copy];
}

- (void)preprocessPhase2
{
    NULibrary *aSourceStringRangeMappingOfPhase2ToPhase1 = [NULibrary libraryWithComparator:[NUCRangePairFromComparator comparator]];
    
    NSMutableString *aLogicalSourceStringInPhase2 = [NSMutableString string];
   
    NSScanner *aScanner = [NSScanner scannerWithString:logicalSourcePhase1String];
    [aScanner setCharactersToBeSkipped:nil];
    NSString *aScannedString = nil;
    
    while (![aScanner isAtEnd])
    {
        NSUInteger aScanLocation = [aScanner scanLocation];
        
        if ([aScanner scanString:NUCBackslash intoString:NULL])
        {
            NSString *aNewLineString = nil;
            
            if ([aScanner scanString:NUCCRLF intoString:&aNewLineString]
                  || [aScanner scanString:NUCLF intoString:&aNewLineString]
                  || [aScanner scanString:NUCCR intoString:&aNewLineString])
            {
                NUCRangePair *aRangePair = [NUCRangePair rangePairWithRangeFrom:NUMakeRegion([aLogicalSourceStringInPhase2 length], 0) rangeTo:NUMakeRegion(aScanLocation, 1 + [aNewLineString length])];
                
                id anExistingObject = [aSourceStringRangeMappingOfPhase2ToPhase1 objectForKey:aRangePair];
                
                if (anExistingObject)
                {
                    if ([anExistingObject isKindOfClass:[NUCRangePair class]])
                    {
                        NSMutableArray *anArray = [NSMutableArray array];
                        [aSourceStringRangeMappingOfPhase2ToPhase1 setObject:anArray forKey:anExistingObject];
                        anExistingObject = anArray;
                    }
                    
                    [(NSMutableArray *)anExistingObject addObject:aRangePair];
                }
                else
                    [aSourceStringRangeMappingOfPhase2ToPhase1 setObject:aRangePair forKey:aRangePair];
            }
            else
            {
                [aLogicalSourceStringInPhase2 appendString:NUCBackslash];
            }
        }
        else if ([aScanner scanUpToString:NUCBackslash intoString:&aScannedString])
        {
            [aLogicalSourceStringInPhase2 appendString:aScannedString];
        }
    }
    
    rangeMappingOfPhase2StringToPhase1String = [aSourceStringRangeMappingOfPhase2ToPhase1 retain];
    
    [self setLogicalSourceString:aLogicalSourceStringInPhase2];
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

@end
