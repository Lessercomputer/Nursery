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

#import <Foundation/NSArray.h>

@implementation NUCMacroInvocation

+ (instancetype)macroInvocationWithDefine:(NUCControlLineDefine *)aDefine
{
    return [[[self alloc] initWithDefine:aDefine] autorelease];
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

- (BOOL)isMacroInvocation
{
    return YES;
}

- (NSArray *)execute
{
    NSMutableArray *aPpTokens = [NSMutableArray array];
    
    
    
    return aPpTokens;
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
