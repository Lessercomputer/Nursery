//
//  NUCUnaryExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCProtoExpression.h"

@class NUCPostfixExpression, NUCDecomposedPreprocessingToken, NUCCastExpression, NUCPreprocessingTokenStream;

@interface NUCUnaryExpression : NUCProtoExpression
{
    NUCPostfixExpression *postfixExpression;
    NUCDecomposedPreprocessingToken *unaryOperator;
    NUCUnaryExpression *unaryExpression;
    NUCCastExpression *castExpression;
}

+ (BOOL)unaryExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCUnaryExpression **)aToken;

+ (instancetype)expressionWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression;

+ (instancetype)expressionWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression;

+ (instancetype)expressionWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression;

- (instancetype)initWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression;

- (instancetype)initWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression;

- (instancetype)initWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression;

@end

