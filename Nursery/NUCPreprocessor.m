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
#import "NUCConstantExpression.h"
#import "NUCTextLine.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>

@implementation NUCPreprocessor

- (instancetype)initWithTranslator:(NUCTranslator *)aTranslator
{
    if (self = [super init])
    {
        translator = [aTranslator retain];
        macroDefines = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [translator release];
    translator = nil;
    [macroDefines release];

    
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

- (NSMutableDictionary *)macroDefines
{
    return macroDefines;
}

- (NUCControlLineDefine *)macroDefineFor:(NUCIdentifier *)aMacroName
{
    return [[self macroDefines] objectForKey:aMacroName];
}

- (void)setMacroDefine:(NUCControlLineDefine *)aMacroDefine
{
    [[self macroDefines] setObject:aMacroDefine forKey:[aMacroDefine identifier]];
}

- (BOOL)macroIsDefined:(NUCIdentifier *)aMacroName
{
    return [self macroDefineFor:aMacroName] ? YES : NO;
}

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile
{
    sourceFile = aSourceFile;
    
    [[self sourceFile] preprocessFromPhase1ToPhase2];
    [self preprocessPhase4:[self preprocesPhase3]];
    
    sourceFile = nil;
}

- (NSArray *)preprocesPhase3
{
    NUCDecomposer *aDecomposer = [NUCDecomposer new];
    NSArray *aPreprocessingTokens = [aDecomposer decomposePreprocessingFile:[self sourceFile]];
    [aDecomposer release];
    
    return aPreprocessingTokens;
}

- (void)preprocessPhase4:(NSArray *)aPreprocessingTokens
{
    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPreprocessingTokens];
    NUCPreprocessingFile *aPreprocessingFile = nil;
    
    if ([NUCPreprocessingFile preprocessingFileFrom:aStream with:self into:&aPreprocessingFile])
        [[self sourceFile] setPreprocessingFile:aPreprocessingFile];
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

- (NUCPreprocessingToken *)instantiateMacroInvocationsInPpTokens:(NUCPpTokens *)aPpTokens
{
    return [self instantiateMacroInvocationsIn:[aPpTokens ppTokens]];
}

- (NUCPreprocessingToken *)instantiateMacroInvocationsInTextLines:(NSArray *)aTextLines
{
    NUCPreprocessingToken *aPpTokensWithMacroInvocations = nil;
    NSMutableArray *aPpTokensInTextLines = [NSMutableArray array];
    
    [aTextLines enumerateObjectsUsingBlock:^(NUCTextLine * _Nonnull  aTextLine, NSUInteger idx, BOOL * _Nonnull stop) {
        [aPpTokensInTextLines addObjectsFromArray:[[aTextLine ppTokens] ppTokens]];
        [aPpTokensInTextLines addObject:[aTextLine newline]];
    }];
    
    aPpTokensWithMacroInvocations = [self instantiateMacroInvocationsIn:aPpTokensInTextLines];
    
    return aPpTokensWithMacroInvocations;
}

- (NUCPreprocessingToken *)instantiateMacroInvocationsIn:(NSArray *)aPpTokens
{
    NUCPpTokensWithMacroInvocations *aPpTokensWithMacroInvocations =  [NUCPpTokensWithMacroInvocations ppTokens];
    
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
            [aPpTokensWithMacroInvocations add:[self identifierOrMacroInvocation:(NUCIdentifier *)aPpToken from:aPpTokenStream]];
        else
            [aPpTokensWithMacroInvocations add:aPpToken];
    }
    
    return aPpTokensWithMacroInvocations;
}

- (NUCPreprocessingToken *)identifierOrMacroInvocation:(NUCIdentifier *)anIdentifier from:(NUCPreprocessingTokenStream *)aPpTokenStream
{
    NUCControlLineDefine *aMacroDefineToInvoke = [self macroDefineFor:anIdentifier];
    
    if (!aMacroDefineToInvoke)
        return anIdentifier;
    else
    {
        NUCMacroInvocation *aMacroInvocation = [NUCMacroInvocation macroInvocationWithDefine:aMacroDefineToInvoke];
        
        if ([aMacroDefineToInvoke isFunctionLike])
        {
            NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
            
            if ([aPpToken isOpeningParenthesis])
            {
                [aMacroInvocation setArguments:[self macroInvocationArgumentsFrom:aPpTokenStream]];
                
                if (![[aPpTokenStream next] isClosingParenthesis])
                    return nil;
            }
            else
                return nil;
        }
        
        return aMacroInvocation;
    }
}

- (NSMutableArray *)macroInvocationArgumentsFrom:(NUCPreprocessingTokenStream *)aPpTokenStream
{
    NSMutableArray *anArguments = [NSMutableArray array];
    
    while ([aPpTokenStream hasNext])
    {
        NSMutableArray *anArgument = [self macroInvocationArgumentFrom:aPpTokenStream];
        if (anArgument)
            [anArguments addObject:anArgument];
        else
            break;
    }
    
    return anArguments;
}

- (NSMutableArray *)macroInvocationArgumentFrom:(NUCPreprocessingTokenStream *)aPpTokenStream
{
    NSMutableArray *anArgument = [NSMutableArray array];
    NSInteger anOpeningParenthesisCount = 0;
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
            [anArgument addObject:[self identifierOrMacroInvocation:(NUCIdentifier *)aPpToken from:aPpTokenStream]];
        else if ([aPpToken isWhitespace])
        {
            [aPpTokenStream skipWhitespaces];
            [anArgument addObject:[NUCDecomposedPreprocessingToken whitespace]];
        }
        else
        {
            if ([aPpToken isComma])
            {
                if (anOpeningParenthesisCount == 0)
                    break;
            }
            else if ([aPpToken isOpeningParenthesis])
                anOpeningParenthesisCount++;
            else if ([aPpToken isClosingParenthesis])
                anOpeningParenthesisCount--;
            
            [anArgument addObject:aPpToken];
        }
    }
    
    return anArgument;
}

- (NUCPpTokens *)executeMacrosInPpTokens:(NUCPreprocessingToken *)aPpTokens
{
    if (![aPpTokens isPpTokensWithMacroInvocations])
        return (NUCPpTokens *)aPpTokens;
    else
    {
        NUCPpTokens *aMacroExecutedPpTokens = [NUCPpTokens ppTokens];
        
        NUCPpTokensWithMacroInvocations *aPpTokensWithMacroInvocations = (NUCPpTokensWithMacroInvocations *)aPpTokens;
        
        [[aPpTokensWithMacroInvocations ppTokens] enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken * _Nonnull aPpToken, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([aPpToken isMacroInvocation])
            {
                NUCMacroInvocation *aMacroInvocation = (NUCMacroInvocation *)aPpToken;
                [aMacroExecutedPpTokens addFromArray:[aMacroInvocation execute]];
            }
            else
                [aMacroExecutedPpTokens add:aPpToken];
        }];

        return aMacroExecutedPpTokens;
    }
}

- (NSInteger)executeConstantExpression:(NUCConstantExpression *)aConstantExpression
{
    return 0;
}

@end
