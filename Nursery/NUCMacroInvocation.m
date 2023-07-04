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

+ (NUCPreprocessingToken *)identifierOrMacroInvocation:(NUCIdentifier *)anIdentifier from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor isRescanning:(BOOL)aRescanning parentMacroInvocation:(NUCMacroInvocation *)aParentMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
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
                [aMacroInvocation setArguments:[self macroInvocationArgumentsOf:aMacroInvocation from:aPpTokenStream with:aPreprocessor isRescanning:aRescanning parentMacroInvocation:aParentMacroInvocation replacingMacroNames:aReplacingMacroNames]];
                
                if (![[aPpTokenStream peekPrevious] isClosingParenthesis])
                    return nil;
            }
            else
                return nil;
        }
        
        if (!aReplacingMacroNames)
            aReplacingMacroNames = [NSMutableSet set];
        
        [aReplacingMacroNames addObject:[aMacroDefineToInvoke identifier]];
        
        NUCPpTokens *aPpTokens = [[aMacroDefineToInvoke replacementList] ppTokens];
        NUCPpTokens *aPpTokensWithMacroInvocations = [[NUCPpTokens class] ppTokensWithMacroInvocationsFrom:[aPpTokens ppTokens] with:aPreprocessor isRescanning:YES parentMacroInvocation:aParentMacroInvocation replacingMacroNames:aReplacingMacroNames];
        [aMacroInvocation setPpTokensWithMacroinvocations:aPpTokensWithMacroInvocations];
        
        [aReplacingMacroNames removeObject:[aMacroDefineToInvoke identifier]];
        
        return aMacroInvocation;
    }
}

+ (NSMutableArray *)macroInvocationArgumentsOf:(NUCMacroInvocation *)aMacroInvocation from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor isRescanning:(BOOL)aRescanning parentMacroInvocation:(NUCMacroInvocation *)aParentMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NSMutableArray *anArguments = [NSMutableArray array];
    
    while ([aPpTokenStream hasNext] && ![[aPpTokenStream peekPrevious] isClosingParenthesis])
    {
        NSMutableArray *anArgument = [self macroInvocationArgumentAt:[anArguments count] of:aMacroInvocation from:aPpTokenStream with:aPreprocessor isRescanning:aRescanning parentMacroInvocation:aParentMacroInvocation replacingMacroNames:aReplacingMacroNames];
        if (anArgument)
            [anArguments addObject:anArgument];
        else
            break;
    }
    
    return anArguments;
}

+ (NSMutableArray *)macroInvocationArgumentAt:(NSUInteger)anIndex of:(NUCMacroInvocation *)aMacroinvocation from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor isRescanning:(BOOL)aRescanning parentMacroInvocation:(NUCMacroInvocation *)aParentMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NSMutableArray *anArgument = [NSMutableArray array];
    NSInteger anOpeningParenthesisCount = 0;
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
        {
            if ([(NUCControlLineDefineFunctionLike *)[aMacroinvocation define] parameterIsHashOperatorOperandAt:anIndex])
                [anArgument addObject:aPpToken];
            else
                [anArgument addObject:[self identifierOrMacroInvocation:(NUCIdentifier *)aPpToken from:aPpTokenStream with:aPreprocessor isRescanning:aRescanning parentMacroInvocation:aParentMacroInvocation replacingMacroNames:aReplacingMacroNames]];
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

- (void)addMacroReplacedPpTokensTo:(NSMutableArray *)aPpTokens With:(NUCPreprocessor *)aPreprocessor
{
    [[self ppTokensWithMacroinvocations] enumerateObjectsUsingBlock:^(NUCPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop) {
        
        if ([aPpToken isMacroInvocation])
            [(NUCMacroInvocation *)aPpToken addMacroReplacedPpTokensTo:aPpTokens With:aPreprocessor];
        else
            [aPpTokens addObject:aPpToken];
    }];
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
