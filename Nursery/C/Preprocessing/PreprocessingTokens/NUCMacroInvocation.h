//
//  NUCMacroInvocation.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCControlLineDefine, NUCPpTokens, NUCIdentifier, NUCPreprocessingTokenStream, NUCDecomposedPreprocessingToken;
@class NSMutableSet;

@interface NUCMacroInvocation : NUCPreprocessingToken
{
    NUCControlLineDefine *define;
    NSMutableArray *arguments;
    NUCPpTokens *ppTokensWithMacroinvocations;
    NUCMacroInvocation *overlappedMacroInvocation;
}

+ (instancetype)macroInvocationWithDefine:(NUCControlLineDefine *)aDefine;

+ (NUCPreprocessingToken *)identifierOrMacroInvocation:(NUCIdentifier *)anIdentifier from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor parentMacroInvocation:(NUCMacroInvocation *)aParentMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames;

- (instancetype)initWithDefine:(NUCControlLineDefine *)aDefine;

- (NUCControlLineDefine *)define;
- (void)setDefine:(NUCControlLineDefine *)aDefine;

- (NSMutableArray *)arguments;
- (void)setArguments:(NSMutableArray *)anArguments;

- (NSArray *)vaArgs;

- (NSMutableArray *)argumentAt:(NSUInteger)anIndex;

- (void)addArgument:(NSArray *)anArgument;

- (NUCPpTokens *)ppTokensWithMacroinvocations;
- (void)setPpTokensWithMacroinvocations:(NUCPpTokens *)aPpTokens;

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces;
- (NUCMacroInvocation *)lastMacroInvocationWithoutWhitespaces;

- (NUCMacroInvocation *)overlappedMacroInvocation;
- (void)setOverlappedMacroInvocation:(NUCMacroInvocation *)aMacroInvocation;
- (BOOL)isOverlapped;
- (NUCMacroInvocation *)lastOverlappedMacroInvocation;

- (NUCPpTokens *)scanPpTokensFrom:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor;

- (NSMutableArray *)expandedPpTokens;

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens With:(NUCPreprocessor *)aPreprocessor;

@end

