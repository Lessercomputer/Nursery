//
//  NUCPpTokens.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//

#import "NUCPreprocessingDirective.h"

@class NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream, NUCIdentifier, NUCMacroInvocation;
@class NSMutableSet;

@interface NUCPpTokens : NUCPreprocessingDirective
{
    NSMutableArray *ppTokens;
}

+ (BOOL)ppTokensFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPpTokens **)aToken;

+ (NSString *)preprocessedStringFromPpTokens:(NUCPpTokens *)aPpTokens with:(NUCPreprocessor *)aPreprocessor;

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromPpTokens:(NUCPpTokens *)aPpTokens with:(NUCPreprocessor *)aPreprocessor;
+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromTextLines:(NSArray *)aTextLines with:(NUCPreprocessor *)aPreprocessor;

+ (instancetype)ppTokens;

- (void)add:(NUCPreprocessingToken *)aPpToken;
- (void)addFromArray:(NSArray *)aPpTokens;

- (NSMutableArray *)ppTokens;
- (NSUInteger)count;

- (NUCPreprocessingToken *)at:(NSUInteger)anIndex;

- (BOOL)containsIdentifier:(NUCIdentifier *)anIdentifier;

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces;
- (NSUInteger)lastPpTokenIndexWithoutWhitespaces;
- (NUCMacroInvocation *)lastMacroInvocation;

- (void)enumerateObjectsUsingBlock:(void (^)(NUCPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop))aBlock;

- (void)enumerateObjectsUsingBlock:(void (^)(NUCPreprocessingToken *, NSUInteger, BOOL *))aBlock skipWhitespaces:(BOOL)aSkipWhitespaces;

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFrom:(NSArray *)aPpTokens of:(NUCMacroInvocation *)aMacroInvocation with:(NUCPreprocessor *)aPreprocessor replacingMacroNames:(NSMutableSet *)aReplacingMacroNames;

- (NSMutableArray *)replaceMacrosWith:(NUCPreprocessor *)aPreprocessor;

@end

