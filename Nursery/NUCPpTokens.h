//
//  NUCPpTokens.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream, NUCIdentifier, NUCMacroInvocation;
@class NSMutableSet;

@interface NUCPpTokens : NUCPreprocessingDirective
{
    NSMutableArray *ppTokens;
}

+ (BOOL)ppTokensFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPpTokens **)aToken;

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromPpTokens:(NUCPpTokens *)aPpTokens with:(NUCPreprocessor *)aPreprocessor;
+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromTextLines:(NSArray *)aTextLines with:(NUCPreprocessor *)aPreprocessor;

+ (instancetype)ppTokens;

- (void)add:(NUCPreprocessingToken *)aPpToken;
- (void)addFromArray:(NSArray *)aPpTokens;

- (NSMutableArray *)ppTokens;
- (NSUInteger)count;

- (NUCPreprocessingToken *)at:(NSUInteger)anIndex;

- (BOOL)containsIdentifier:(NUCIdentifier *)anIdentifier;

- (void)enumerateObjectsUsingBlock:(void (^)(NUCPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop))aBlock;

- (void)enumerateObjectsUsingBlock:(void (^)(NUCPreprocessingToken *, NSUInteger, BOOL *))aBlock skipWhitespaces:(BOOL)aSkipWhitespaces;

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFrom:(NSArray *)aPpTokens with:(NUCPreprocessor *)aPreprocessor isRescanning:(BOOL)aRescanning macroInvocation:(NUCMacroInvocation *)aMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames;

- (NSMutableArray *)replaceMacrosWith:(NUCPreprocessor *)aPreprocessor;

@end

