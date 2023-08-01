//
//  NUCAdditiveExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCMultiplicativeExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCAdditiveExpression : NUCPreprocessingToken
{
    NUCAdditiveExpression *additiveExpression;
    NUCDecomposedPreprocessingToken *additiveOperator;
    NUCMultiplicativeExpression *multiplicativeExpression;
}

+ (BOOL)additiveExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCAdditiveExpression **)aToken;

+ (instancetype)expressionWithMultiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression;

+ (instancetype)expressionWithAdditiveExpression:(NUCAdditiveExpression *)anAdditiveExpression additiveOperator:(NUCDecomposedPreprocessingToken *)anAdditiveOperator multiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression;

- (instancetype)initWithMultiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression;

- (instancetype)initWithAdditiveExpression:(NUCAdditiveExpression *)anAdditiveExpression additiveOperator:(NUCDecomposedPreprocessingToken *)anAdditiveOperator multiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression;

@end

