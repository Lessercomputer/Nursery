//
//  NUCReplacementList.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/10.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPpTokens, NUCPreprocessingTokenStream, NUCIdentifier, NUCDecomposedPreprocessingToken;

@interface NUCReplacementList : NUCPreprocessingDirective
{
    NUCPpTokens *ppTokens;
}

+ (BOOL)replacementListFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPreprocessingDirective **)aToken;

+ (instancetype)replacementListWithPpTokens:(NUCPpTokens *)aPpTokens;

- (instancetype)initWithPpTokens:(NUCPpTokens *)aPpTokens;

- (NUCPpTokens *)ppTokens;

- (void)enumerateObjectsUsingBlock:(void (^)(NUCDecomposedPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop))aBlock;;

@end

