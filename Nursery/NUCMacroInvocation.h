//
//  NUCMacroInvocation.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCControlLineDefine, NUCPpTokens;
@class NSMutableSet;

@interface NUCMacroInvocation : NUCPreprocessingToken
{
    NUCControlLineDefine *define;
    NSMutableArray *arguments;
    NUCPpTokens *ppTokensWithMacroinvocations;
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromPpTokens:(NUCPpTokens *)aPpTokens with:(NUCPreprocessor *)aPreprocessor;
+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromTextLines:(NSArray *)aTextLines with:(NUCPreprocessor *)aPreprocessor;

+ (instancetype)macroInvocationWithDefine:(NUCControlLineDefine *)aDefine;

- (instancetype)initWithDefine:(NUCControlLineDefine *)aDefine;

- (NUCControlLineDefine *)define;
- (void)setDefine:(NUCControlLineDefine *)aDefine;

- (NSMutableArray *)arguments;
- (void)setArguments:(NSMutableArray *)anArguments;

- (void)addArgument:(NSArray *)anArgument;

- (NUCPpTokens *)ppTokensWithMacroinvocations;
- (void)setPpTokensWithMacroinvocations:(NUCPpTokens *)aPpTokens;

- (NSArray *)executeWith:(NUCPreprocessor *)aPreprocessor;
- (NSArray *)executeWith:(NUCPreprocessor *)aPreprocessor inReplacingMacroNames:(NSMutableSet *)anExecutingMacros;

@end

