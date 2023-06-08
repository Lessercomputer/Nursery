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
#import "NUCExpandedMacro.h"

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

- (NUCExpandedMacro *)preprocessPpTokens:(NUCPpTokens *)aPpTokens
{
    return [self expandMacroInvocationsIn:aPpTokens expandingMacroDefines:[NSMutableArray array]];
}

- (NUCExpandedMacro *)expandMacroInvocationsIn:(NUCPpTokens *)aPpTokens expandingMacroDefines:(NSMutableArray *)anExpandingMacroDefines
{
    NUCExpandedMacro *anExpandedMacro = [[NUCExpandedMacro new] autorelease];
    
    [aPpTokens enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop) {
        
        if ([aPpToken isIdentifier])
        {
            NUCIdentifier *aMacroNameToExpand = (NUCIdentifier *)aPpToken;
            NUCControlLineDefine *aMacroDefineToExpand = [self macroDefineFor:aMacroNameToExpand];
            
            if (aMacroDefineToExpand && ![anExpandingMacroDefines containsObject:aMacroDefineToExpand])
            {
                [anExpandingMacroDefines addObject:aMacroDefineToExpand];
                
                [anExpandedMacro setDefine:aMacroDefineToExpand];
                
                if ([aMacroDefineToExpand isObjectLike])
                {
                    NUCExpandedMacro *anExpandedMacroForDefine = [self expandMacroInvocationsIn:[[aMacroDefineToExpand replacementList] ppTokens] expandingMacroDefines:anExpandingMacroDefines];

                    [aMacroNameToExpand setExpandedMacro:anExpandedMacroForDefine];
                    
                    [anExpandedMacro add:anExpandedMacroForDefine];
                }
                else
                {
                    
                }
                
                [anExpandingMacroDefines removeLastObject];
            }
            else
                [anExpandedMacro add:aPpToken];
        }
        else
            [anExpandedMacro add:aPpToken];
    }];
    
    return anExpandedMacro;
}

@end
