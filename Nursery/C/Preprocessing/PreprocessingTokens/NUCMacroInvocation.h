//
//  NUCMacroInvocation.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/07.
//

#import "NUCPreprocessingToken.h"

@class NUCControlLineDefine, NUCPpTokens, NUCIdentifier, NUCPreprocessingTokenStream, NUCDecomposedPreprocessingToken, NUCMacroArgument;
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

- (BOOL)isObjectLike;
- (BOOL)isFunctionLike;

- (NSMutableArray *)arguments;
- (void)setArguments:(NSMutableArray *)anArguments;

- (NUCMacroArgument *)vaArgs;

- (NUCMacroArgument *)argumentAt:(NSUInteger)anIndex;
- (NUCMacroArgument *)argumentFor:(NUCIdentifier *)aParameterIdentifier;

- (void)addArgument:(NUCMacroArgument *)anArgument;

- (NUCPpTokens *)ppTokensWithMacroinvocations;
- (void)setPpTokensWithMacroinvocations:(NUCPpTokens *)aPpTokens;

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces;
- (NUCMacroInvocation *)lastMacroInvocationWithoutWhitespaces;

- (NUCMacroInvocation *)overlappedMacroInvocation;
- (void)setOverlappedMacroInvocation:(NUCMacroInvocation *)aMacroInvocation;
- (BOOL)isOverlapped;
- (NUCMacroInvocation *)lastOverlappedMacroInvocation;

- (NSMutableArray *)expandedPpTokens;

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens With:(NUCPreprocessor *)aPreprocessor;

@end

