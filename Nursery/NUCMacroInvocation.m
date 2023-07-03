//
//  NUCMacroInvocation.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCMacroInvocation.h"
#import "NUCControlLineDefine.h"
#import "NUCPreprocessor.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCConcatenatedPpToken.h"
#import "NUCPpTokens.h"
#import "NUCGroupPart.h"
#import "NUCTextLine.h"
#import "NUCPpTokensWithMacroInvocations.h"
#import "NUCIdentifier.h"
#import "NUCControlLineDefineFunctionLike.h"
#import "NUCReplacementList.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSSet.h>

@implementation NUCMacroInvocation

+ (instancetype)macroInvocationWithDefine:(NUCControlLineDefine *)aDefine
{
    return [[[self alloc] initWithDefine:aDefine] autorelease];
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromPpTokens:(NUCPpTokens *)aPpTokens with:(NUCPreprocessor *)aPreprocessor
{
    return [self ppTokensWithMacroInvocationsFrom:[aPpTokens ppTokens] with:aPreprocessor isRescanning:NO replacingMacroNames:[NSMutableSet set]];
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromTextLines:(NSArray *)aTextLines with:(NUCPreprocessor *)aPreprocessor
{
    NUCPpTokens *aPpTokensWithMacroInvocations = nil;
    NSMutableArray *aPpTokensInTextLines = [NSMutableArray array];
    
    [aTextLines enumerateObjectsUsingBlock:^(NUCGroupPart * _Nonnull aGroupPart, NSUInteger idx, BOOL * _Nonnull stop) {
        NUCTextLine *aTextLine = (NUCTextLine *)[aGroupPart content];
        [aPpTokensInTextLines addObjectsFromArray:[[aTextLine ppTokens] ppTokens]];
    }];
    
    aPpTokensWithMacroInvocations = [self ppTokensWithMacroInvocationsFrom:aPpTokensInTextLines with:aPreprocessor isRescanning:NO replacingMacroNames:[NSMutableSet set]];
    
    return aPpTokensWithMacroInvocations;
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFrom:(NSArray *)aPpTokens with:(NUCPreprocessor *)aPreprocessor isRescanning:(BOOL)aRescanning replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NUCPpTokensWithMacroInvocations *aPpTokensWithMacroInvocations =  [NUCPpTokensWithMacroInvocations ppTokens];
    
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier] && ![aReplacingMacroNames containsObject:aPpToken])
            [aPpTokensWithMacroInvocations add:[self identifierOrMacroInvocation:(NUCIdentifier *)aPpToken from:aPpTokenStream with:aPreprocessor isRescanning:aRescanning replacingMacroNames:aReplacingMacroNames]];
        else
            [aPpTokensWithMacroInvocations add:aPpToken];
    }
    
    return aPpTokensWithMacroInvocations;
}

+ (NUCPreprocessingToken *)identifierOrMacroInvocation:(NUCIdentifier *)anIdentifier from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor isRescanning:(BOOL)aRescanning replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NUCControlLineDefine *aMacroDefineToInvoke = [aPreprocessor macroDefineFor:anIdentifier];
    
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
                [aMacroInvocation setArguments:[self macroInvocationArgumentsFrom:aPpTokenStream define:(NUCControlLineDefineFunctionLike *)aMacroDefineToInvoke with:aPreprocessor isRescanning:aRescanning replacingMacroNames:aReplacingMacroNames]];
                
                if (![[aPpTokenStream peekPrevious] isClosingParenthesis])
                    return nil;
            }
            else
                return nil;
        }
        
//        NUCIdentifier *aMacroName = [aMacroDefineToInvoke identifier];
//        [aReplacingMacroNames addObject:aMacroName];
//
//        NUCPpTokens *aPpTokens = [self ppTokensWithMacroInvocationsFrom:[[[aMacroDefineToInvoke replacementList] ppTokens] ppTokens] with:aPreprocessor isRescanning:YES replacingMacroNames:aReplacingMacroNames];
//        [aMacroInvocation setPpTokensWithMacroinvocations:aPpTokens];
//
//        [aReplacingMacroNames removeObject:aMacroName];
        
        return aMacroInvocation;
    }
}

+ (NSMutableArray *)macroInvocationArgumentsFrom:(NUCPreprocessingTokenStream *)aPpTokenStream define:(NUCControlLineDefineFunctionLike *)aMacroDefine with:(NUCPreprocessor *)aPreprocessor isRescanning:(BOOL)aRescanning replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NSMutableArray *anArguments = [NSMutableArray array];
    
    while ([aPpTokenStream hasNext] && ![[aPpTokenStream peekPrevious] isClosingParenthesis])
    {
        NSMutableArray *anArgument = [self macroInvocationArgumentAt:[anArguments count] of:aMacroDefine from:aPpTokenStream with:aPreprocessor isRescanning:aRescanning replacingMacroNames:aReplacingMacroNames];
        if (anArgument)
            [anArguments addObject:anArgument];
        else
            break;
    }
    
    return anArguments;
}

+ (NSMutableArray *)macroInvocationArgumentAt:(NSUInteger)anIndex of:(NUCControlLineDefineFunctionLike *)aMacroDefine from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor isRescanning:(BOOL)aRescanning replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NSMutableArray *anArgument = [NSMutableArray array];
    NSInteger anOpeningParenthesisCount = 0;
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
        {
            if ([aMacroDefine parameterIsHashOperatorOperandAt:anIndex])
                [anArgument addObject:aPpToken];
            else
                [anArgument addObject:[self identifierOrMacroInvocation:(NUCIdentifier *)aPpToken from:aPpTokenStream with:aPreprocessor isRescanning:aRescanning replacingMacroNames:aReplacingMacroNames]];
        }
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
            {
                [anArgument addObject:aPpToken];
                anOpeningParenthesisCount++;
            }
            else if ([aPpToken isClosingParenthesis])
            {
                if (anOpeningParenthesisCount == 0)
                    break;
                
                [anArgument addObject:aPpToken];
                anOpeningParenthesisCount--;
            }
        }
    }
    
    return anArgument;
}

- (instancetype)init
{
    return [self initWithDefine:nil];
}

- (instancetype)initWithDefine:(NUCControlLineDefine *)aDefine
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        define = aDefine;
        arguments = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [arguments release];
    [ppTokensWithMacroinvocations release];
    
    [super dealloc];
}

- (NUCControlLineDefine *)define
{
    return define;
}

- (void)setDefine:(NUCControlLineDefine *)aDefine
{
    define = aDefine;
}

- (NSMutableArray *)arguments
{
    return arguments;
}

- (void)setArguments:(NSMutableArray *)anArguments
{
    [[self arguments] addObjectsFromArray:anArguments];
}

- (void)addArgument:(NSArray *)anArgument
{
    [[self arguments] addObject:anArgument];
}

- (NUCPpTokens *)ppTokensWithMacroinvocations
{
    return ppTokensWithMacroinvocations;
}

- (void)setPpTokensWithMacroinvocations:(NUCPpTokens *)aPpTokens
{
    [ppTokensWithMacroinvocations release];
    ppTokensWithMacroinvocations = [aPpTokens retain];
}

- (BOOL)isMacroInvocation
{
    return YES;
}

- (NSArray *)executeWith:(NUCPreprocessor *)aPreprocessor
{
    return [self executeWith:aPreprocessor inReplacingMacroNames:[NSMutableSet set]];
}

- (NSArray *)executeWith:(NUCPreprocessor *)aPreprocessor inReplacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NSMutableArray *aMacroReplacedPpTokens = [NSMutableArray array];
    NUCControlLineDefine *aMacroDefine = [self define];
    NUCIdentifier *aMacroName = [aMacroDefine identifier];
    
//    if ([aMacroDefine isObjectLike])
//    {
//        NUCPreprocessingToken *aPpTokens = [[self class] ppTokensWithMacroInvocationsFromReplacementList:[aMacroDefine replacementList] with:aPreprocessor replacingMacroNames:aReplacingMacroNames];
//
//    }
//    else
//    {
//
//    }
//
//    if ([aReplacingMacroNames containsObject:aMacroName])
//        ;
    
    return aMacroReplacedPpTokens;
}

- (NSArray *)executeHashHashOperetorsInReplacementList:(NSArray *)aPpTokens
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
