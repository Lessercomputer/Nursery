//
//  NUCUnaryExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCProtoExpression.h"

@class NUCPostfixExpression, NUCToken, NUCCastExpression, NUCTokenStream;

@interface NUCUnaryExpression : NUCProtoExpression
{
    NUCPostfixExpression *postfixExpression;
    id <NUCToken> unaryOperator;
    NUCUnaryExpression *unaryExpression;
    NUCCastExpression *castExpression;
}

+ (BOOL)unaryExpressionFrom:(NUCTokenStream *)aStream into:(NUCUnaryExpression **)aToken;

+ (instancetype)expressionWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression;

+ (instancetype)expressionWithUnaryOperator:(id <NUCToken>)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression;

+ (instancetype)expressionWithUnaryOperator:(id <NUCToken>)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression;

- (instancetype)initWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression;

- (instancetype)initWithUnaryOperator:(id <NUCToken>)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression;

- (instancetype)initWithUnaryOperator:(id <NUCToken>)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression;

@end

