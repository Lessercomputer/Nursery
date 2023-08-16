//
//  NUCMacroInvocation.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/07.
//

#import "NUCPreprocessingToken.h"

@class NUCControlLineDefine, NUCPpTokensWithMacroInvocations, NUCIdentifier, NUCPreprocessingTokenStream, NUCDecomposedPreprocessingToken, NUCMacroArgument;
@class NSMutableSet;

@interface NUCMacroInvocation : NUCPreprocessingToken
{
    NUCControlLineDefine *define;
    NSArray *whitespacesFollowingMacroName;
    NUCDecomposedPreprocessingToken *openingParenthesis;
    NUCDecomposedPreprocessingToken *closingParenthesis;
    NSMutableArray *arguments;
    NUCPpTokensWithMacroInvocations *ppTokensWithMacroinvocations;
}

+ (instancetype)macroInvocationWithDefine:(NUCControlLineDefine *)aDefine;

+ (NUCPreprocessingToken *)identifierOrMacroInvocation:(NUCIdentifier *)anIdentifier from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor parentMacroInvocation:(NUCMacroInvocation *)aParentMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames;

- (instancetype)initWithDefine:(NUCControlLineDefine *)aDefine;

- (NUCControlLineDefine *)define;
- (void)setDefine:(NUCControlLineDefine *)aDefine;

- (BOOL)isObjectLike;
- (BOOL)isFunctionLike;

- (NSArray *)whitespacesFollowingMacroName;
- (void)setWhitespacesFollowingMacroName:(NSArray *)aWhitespaces;

- (NUCDecomposedPreprocessingToken *)openingParenthesis;
- (void)setOpeningParenthesis:(NUCDecomposedPreprocessingToken *)anOpeningParenthesis;

- (NUCDecomposedPreprocessingToken *)closingParenthesis;
- (void)setClosingParenthesis:(NUCDecomposedPreprocessingToken *)aClosingParenthesis;

- (NSMutableArray *)arguments;
- (void)setArguments:(NSMutableArray *)anArguments;

- (NUCMacroArgument *)vaArgs;

- (NUCMacroArgument *)argumentAt:(NSUInteger)anIndex;
- (NUCMacroArgument *)argumentFor:(NUCIdentifier *)aParameterIdentifier;

- (void)addArgument:(NUCMacroArgument *)anArgument;

- (NUCPpTokensWithMacroInvocations *)ppTokensWithMacroinvocations;
- (void)setPpTokensWithMacroinvocations:(NUCPpTokensWithMacroInvocations *)aPpTokens;

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces;
- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespacesIndexInto:(NSUInteger *)anIndex;
- (NUCMacroInvocation *)lastMacroInvocation;

- (NSMutableArray *)expandedPpTokens;

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens With:(NUCPreprocessor *)aPreprocessor;

@end

