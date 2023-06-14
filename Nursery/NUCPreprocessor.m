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
#import "NUCControlLineDefine.h"
#import "NUCPpTokens.h"
#import "NUCPpTokensWithMacroInvocations.h"
#import "NUCMacroInvocation.h"
#import "NUCConcatenatedPpToken.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>

@implementation NUCPreprocessor

- (instancetype)initWithTranslator:(NUCTranslator *)aTranslator
{
    if (self = [super init])
    {
        translator = [aTranslator retain];
    }
    
    return self;
}

- (void)dealloc
{
    [translator release];
    translator = nil;

    
    [super dealloc];
}

- (NUCTranslator *)translator
{
    return translator;
}

- (NUCSourceFile *)sourceFile
{
    return sourceFile;
}

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile
{
    sourceFile = aSourceFile;
    [[self sourceFile] preprocessFromPhase1ToPhase2];
    
    NSArray *aPreprocessingTokens = [self preprocesPhase3];

    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPreprocessingTokens];
    NUCPreprocessingFile *aPreprocessingFile = nil;
    
    if ([NUCPreprocessingFile preprocessingFileFrom:aStream into:&aPreprocessingFile])
    {
        [[self sourceFile] setPreprocessingFile:aPreprocessingFile];
        [self preprocessPhase4];
    }
    
    sourceFile = nil;
}

- (NSArray *)preprocesPhase3
{
    NUCDecomposer *aDecomposer = [NUCDecomposer new];
    NSArray *aPreprocessingTokens = [aDecomposer decomposePreprocessingFile:[self sourceFile]];
    [aDecomposer release];
    
    return aPreprocessingTokens;
}

- (void)preprocessPhase4
{
    [[[self sourceFile] preprocessingFile] preprocessWith:self];
}

- (NUCControlLineDefine *)macroDefineFor:(NUCIdentifier *)aMacroDefineName
{
    return [[[self sourceFile] preprocessingFile] macroDefineFor:aMacroDefineName];
}

- (void)setMacroDefine:(NUCControlLineDefine *)aMacroDefine
{
    [[[self sourceFile] preprocessingFile] setMacroDefine:aMacroDefine];
}

- (void)include:(NUCControlLineInclude *)anInclude
{
    
}

- (void)define:(NUCControlLineDefine *)aMacroDefine
{
    NUCIdentifier *aMacroName = [aMacroDefine identifier];
    NUCControlLineDefine *anExistingMacro = [self macroDefineFor:aMacroName];
    
    if (!anExistingMacro || [anExistingMacro isEqual:aMacroDefine])
        [self setMacroDefine:aMacroDefine];
}

- (NUCPreprocessingToken *)ppTokensWithMacroInvocationsByInstantiateMacroInvocationsIn:(NUCPpTokens *)aPpTokens
{
    return [self instantiateMacroInvocationsIn:[aPpTokens ppTokens]];
}

- (NUCPreprocessingToken *)instantiateMacroInvocationsIn:(NSArray *)aPpTokens
{
    NUCPpTokensWithMacroInvocations *aPpTokensWithMacroInvocations = [NUCPpTokensWithMacroInvocations ppTokens];
    
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
            [aPpTokensWithMacroInvocations add:[self macroInvocationOrIdentifier:(NUCIdentifier *)aPpToken from:aPpTokenStream]];
        else
            [aPpTokensWithMacroInvocations add:aPpToken];
    }
    
    return aPpTokensWithMacroInvocations;
}

- (NUCPreprocessingToken *)macroInvocationOrIdentifier:(NUCIdentifier *)anIdentifier from:(NUCPreprocessingTokenStream *)aPpTokenStream
{
    NUCIdentifier *aMacroNameToInvoke = anIdentifier;
    NUCControlLineDefine *aMacroDefineToInvoke = [self macroDefineFor:aMacroNameToInvoke];
    
    if (aMacroDefineToInvoke)
    {
        NUCMacroInvocation *aMacroInvocation = [NUCMacroInvocation macroInvocationWithDefine:aMacroDefineToInvoke];
        
        if ([aMacroDefineToInvoke isFunctionLike])
        {
            NUCDecomposedPreprocessingToken *aPpTokenFollowsFunctionLikeMacroName = [aPpTokenStream next];
            
            if ([aPpTokenFollowsFunctionLikeMacroName isOpeningParenthesis])
            {
                while ([aPpTokenStream hasNext])
                {
                    aPpTokenFollowsFunctionLikeMacroName = [aPpTokenStream next];
                    
                    
                    
                    if ([aPpTokenFollowsFunctionLikeMacroName isClosingParenthesis])
                        ;
                }
            }
            else
                return nil;
        }
        
        return aMacroInvocation;
    }
    else
        return anIdentifier;
}

- (NUCPreprocessingToken *)rescanReplacementListOf:(NUCControlLineDefine *)aMacroDefine rescanningMacroDefines:(NSMutableArray *)aRescanningMacroDefines
{
    return nil;
}

- (NUCPpTokensWithMacroInvocations *)instantiateMacroInvocationsIn:(NSArray *)aPpTokens  inRescanningMacros:(BOOL)aRescanningMacros rescanningMacroDefines:(NSMutableArray *)aRescanningMacroDefines
{
    NUCPpTokensWithMacroInvocations *aMacroExpandedPpTokens = [NUCPpTokensWithMacroInvocations ppTokens];
    NSArray *aPpTokensInArray = nil;
    
    if (aRescanningMacros)
        aPpTokensInArray = [self preprocessHashHashOperetorsInReplacementList:aPpTokens];
    else
        aPpTokensInArray = aPpTokens;
    
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokensInArray];
        
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
        {
            NUCIdentifier *aMacroNameToInvoke = (NUCIdentifier *)aPpToken;
            
            NUCControlLineDefine *aMacroDefineToInvoke = [self macroDefineFor:aMacroNameToInvoke];
            
            if (aMacroDefineToInvoke && ![aRescanningMacroDefines containsObject:aMacroDefineToInvoke])
            {
                if (!aRescanningMacroDefines)
                    aRescanningMacroDefines = [NSMutableArray array];
                
                if ([aMacroDefineToInvoke isObjectLike])
                {
                    [aRescanningMacroDefines addObject:aMacroDefineToInvoke];
                    
                    NUCPreprocessingToken *aMacroExpandedPpTokensForDefine = [self instantiateMacroInvocationsIn:[[[aMacroDefineToInvoke replacementList] ppTokens] ppTokens] inRescanningMacros:YES rescanningMacroDefines:aRescanningMacroDefines];
                    
                    [aMacroExpandedPpTokens add:aMacroExpandedPpTokensForDefine];
                }
                else
                {
                    NUCDecomposedPreprocessingToken *aPpTokenFollowsFunctionLikeMacroName = [aPpTokenStream next];
                    
                    if ([aPpTokenFollowsFunctionLikeMacroName isOpeningParenthesis])
                    {
                        NUCMacroInvocation *aMacroInvocation = [NUCMacroInvocation macroInvocationWithDefine:aMacroDefineToInvoke];
                        
                        while ([aPpTokenStream hasNext])
                        {
                            aPpTokenFollowsFunctionLikeMacroName = [aPpTokenStream next];
                            
                            
                            if ([aPpTokenFollowsFunctionLikeMacroName isClosingParenthesis])
                                ;
                        }
                    }
                    else
                        ;
                }
                
                [aRescanningMacroDefines removeLastObject];
            }
            else
                [aMacroExpandedPpTokens add:aPpToken];
        }
        else
            [aMacroExpandedPpTokens add:aPpToken];
    }
    
    return aMacroExpandedPpTokens;
}

- (NSArray *)preprocessHashHashOperetorsInReplacementList:(NSArray *)aPpTokens
{
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    if ([[aPpTokenStream peekNext] isHashHash])
        return nil;
    
    NSMutableArray *aPpTokensAfterPreprocessingOfHashHashOperators = [NSMutableArray array];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
        {
            while ([aPpTokenStream nextIsWhitespacesWithoutNewline])
                [aPpTokensAfterPreprocessingOfHashHashOperators addObject:[aPpTokenStream next]];
            
            if ([aPpTokenStream hasNext])
            {
                NUCDecomposedPreprocessingToken *aHashHashOrOther = [aPpTokenStream next];
                
                if ([aHashHashOrOther isHashHash])
                {
                    while ([aPpTokenStream nextIsWhitespacesWithoutNewline])
                        [aPpTokensAfterPreprocessingOfHashHashOperators addObject:[aPpTokenStream next]];
                    
                    NUCDecomposedPreprocessingToken *aHashHashOperatorOperand = [aPpTokenStream next];
                    
                    if (aHashHashOperatorOperand)
                    {
                        NUCConcatenatedPpToken *aConcatenatedPpToken = [[NUCConcatenatedPpToken alloc] initWithLeft:aPpToken right:aHashHashOperatorOperand];
                        
                        [aPpTokensAfterPreprocessingOfHashHashOperators addObject:aConcatenatedPpToken];
                        [aConcatenatedPpToken release];
                    }
                    else
                        return nil;
                }
                else
                    [aPpTokensAfterPreprocessingOfHashHashOperators addObject:aPpToken];
            }
        }
        else
            [aPpTokensAfterPreprocessingOfHashHashOperators addObject:aPpToken];
    }
    
    return aPpTokensAfterPreprocessingOfHashHashOperators;
}

@end
