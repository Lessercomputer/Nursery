//
//  NUCUnaryExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCPostfixExpression, NUCDecomposedPreprocessingToken, NUCCastExpression;

@interface NUCUnaryExpression : NUCPreprocessingToken
{
    NUCPostfixExpression *postfixExpression;
    NUCDecomposedPreprocessingToken *unaryOperator;
    NUCUnaryExpression *unaryExpression;
    NUCCastExpression *castExpression;
}

+ (instancetype)expressionWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression;

+ (instancetype)expressionWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression;

+ (instancetype)expressionWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression;

- (instancetype)initWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression;

- (instancetype)initWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression;

- (instancetype)initWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression;

@end

