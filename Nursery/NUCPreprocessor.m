//
//  NUCPreprocessor.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessor.h"
#import "NUCDecomposer.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCSourceFile.h"
#import "NUCPreprocessingFile.h"
#import "NUCControlLineDefine.h"
#import "NUCIdentifier.h"
#import "NUCReplacementList.h"

#import "NURegion.h"
#import "NUCRangePair.h"
#import "NULibrary.h"

#import <Foundation/NSString.h>
#import <Foundation/NSScanner.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>

@implementation NUCPreprocessor

- (instancetype)initWithTranslator:(NUCTranslator *)aTranslator
{
    if (self = [super init])
    {
        translator = [aTranslator retain];
        macros = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [translator release];
    translator = nil;
    [macros release];
    macros = nil;
    
    [super dealloc];
}

- (NUCTranslator *)translator
{
    return translator;
}

- (NSMutableDictionary *)macros
{
    return macros;
}

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile
{
    NULibrary *aSourceStringRangeMappingPhase1toPhysicalSource = [NULibrary libraryWithComparator:[NUCRangePairFromComparator comparator]];
    NULibrary *aSourceStringRangeMappingPhase2ToPhase1 = [NULibrary libraryWithComparator:[NUCRangePairFromComparator comparator]];
    
    NSString *aLogicalSourceStringInPhase1 = [self preprocessPhase1:[aSourceFile physicalSourceString] forSourceFile:aSourceFile rangeMappingFromPhase1ToPhysicalSourceString:aSourceStringRangeMappingPhase1toPhysicalSource];
    NSString *aLogicalSourceStringInPhase2 = [self preprocessPhase2:aLogicalSourceStringInPhase1 forSourceFile:aSourceFile rangeMappingFromPhase2StringToPhase1String:aSourceStringRangeMappingPhase2ToPhase1];
    
    [aSourceFile setLogicalSourceString:aLogicalSourceStringInPhase2];
    
    NUCDecomposer *aDecomposer = [NUCDecomposer new];
    NSArray *aPreprocessingTokens = [aDecomposer decomposePreprocessingFile:aSourceFile];
    [aDecomposer release];

    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPreprocessingTokens];
    NUCPreprocessingFile *aPreprocessingFile = nil;
    
    if ([NUCPreprocessingFile preprocessingFileFrom:aStream into:&aPreprocessingFile])
        [aPreprocessingFile preprocessWith:self];
}

- (NSString *)preprocessPhase1:(NSString *)aPhysicalSourceString forSourceFile:(NUCSourceFile *)aSourceFile rangeMappingFromPhase1ToPhysicalSourceString:(NULibrary *)aRangeMappingFromPhase1ToPhysicalSourceString
{
    NSMutableString *aLogicalSourceStringInPhase1 = [NSMutableString string];
    NSScanner *aScanner = [NSScanner scannerWithString:aPhysicalSourceString];
    [aScanner setCharactersToBeSkipped:nil];
    NSString *aScannedString = nil;
    
    while (![aScanner isAtEnd])
    {
        NSUInteger aScanLocation = [aScanner scanLocation];
        
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
                
                [aRangeMappingFromPhase1ToPhysicalSourceString setObject:aRangePair forKey:aRangePair];
            }
        }
        else if ([aScanner scanUpToString:NUCTrigraphSequenceBeginning intoString:&aScannedString])
        {
            [aLogicalSourceStringInPhase1 appendString:aScannedString];
        }
    }
    
    return aLogicalSourceStringInPhase1;
}

- (NSString *)preprocessPhase2:(NSString *)aLogicalSourceStringInPhase1 forSourceFile:(NUCSourceFile *)aSourceFile rangeMappingFromPhase2StringToPhase1String:(NULibrary *)aRangeMappingFromPhase2StringToPhase1String
{
    NSMutableString *aLogicalSourceStringInPhase2 = [NSMutableString string];
    NSScanner *aScanner = [NSScanner scannerWithString:aLogicalSourceStringInPhase1];
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
                
                id anExistingObject = [aRangeMappingFromPhase2StringToPhase1String objectForKey:aRangePair];
                
                if (anExistingObject)
                {
                    if ([anExistingObject isKindOfClass:[NUCRangePair class]])
                    {
                        NSMutableArray *anArray = [NSMutableArray array];
                        [aRangeMappingFromPhase2StringToPhase1String setObject:anArray forKey:anExistingObject];
                        anExistingObject = anArray;
                    }
                    
                    [(NSMutableArray *)anExistingObject addObject:aRangePair];
                }
                else
                    [aRangeMappingFromPhase2StringToPhase1String setObject:aRangePair forKey:aRangePair];
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
    
    return aLogicalSourceStringInPhase2;
}

- (void)include:(NUCControlLineInclude *)anInclude
{
    
}

- (void)define:(NUCControlLineDefine *)aMacro
{
    NUCIdentifier *aMacroName = [aMacro identifier];
    NUCControlLineDefine *anExistingMacro = [[self macros] objectForKey:aMacroName];
    
    if (!anExistingMacro || [anExistingMacro isEqual:aMacro])
    {
        [[self macros] setObject:aMacro forKey:[aMacro identifier]];
        
        [[aMacro replacementList] enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop) {
            
            if ([aPpToken isEqual:aMacroName])
                *aStop = YES;
            else
            {
                NUCControlLineDefine *aDefinedMacro = [[self macros] objectForKey:aPpToken];
                
                if (aDefinedMacro)
                    [aPpToken setReplacementList:[aDefinedMacro replacementList]];
            }
        }];
    }
}

@end
