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
#import "NUCMacroExpandedPpTokens.h"
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

- (NUCPreprocessingToken *)ppTokensByExpandingMacroInvocationsIn:(NUCPpTokens *)aPpTokens
{
    return [self ppTokensByExpandingMacroInvocationsIn:[aPpTokens ppTokens] inRescanningMacros:NO rescanningMacroDefines:nil];
}

- (NUCMacroExpandedPpTokens *)ppTokensByExpandingMacroInvocationsIn:(NSArray *)aPpTokens  inRescanningMacros:(BOOL)aRescanningMacros rescanningMacroDefines:(NSMutableArray *)aRescanningMacroDefines
{
    NUCMacroExpandedPpTokens *aMacroExpandedPpTokens = [NUCMacroExpandedPpTokens ppTokens];
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
            NUCIdentifier *aMacroNameToExpand = (NUCIdentifier *)aPpToken;
            
            NUCControlLineDefine *aMacroDefineToExpand = [self macroDefineFor:aMacroNameToExpand];
            
            if (aMacroDefineToExpand && ![aRescanningMacroDefines containsObject:aMacroDefineToExpand])
            {
                if (!aRescanningMacroDefines)
                    aRescanningMacroDefines = [NSMutableArray array];
                
                if ([aMacroDefineToExpand isObjectLike])
                {
                    [aRescanningMacroDefines addObject:aMacroDefineToExpand];
                    
                    NUCPreprocessingToken *aMacroExpandedPpTokensForDefine = [self ppTokensByExpandingMacroInvocationsIn:[[[aMacroDefineToExpand replacementList] ppTokens] ppTokens] inRescanningMacros:YES rescanningMacroDefines:aRescanningMacroDefines];
                    
                    [aMacroExpandedPpTokens add:aMacroExpandedPpTokensForDefine];
                }
                else
                {
                    NUCDecomposedPreprocessingToken *aPpTokenFollowsFunctionLikeMacroName = [aPpTokenStream next];
                    
                    if ([aPpTokenFollowsFunctionLikeMacroName isOpeningParenthesis])
                    {
                        NUCMacroInvocation *aMacroInvocation = [NUCMacroInvocation macroInvocationWithDefine:aMacroDefineToExpand];
                        
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
