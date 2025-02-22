//
//  NUCPostfixExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCProtoExpression.h"

@class NUCPrimaryExpression, NUCTokenStream;

@interface NUCPostfixExpression : NUCProtoExpression
{
    NUCPrimaryExpression *primaryExpression;
}

+ (BOOL)postfixExpressionFrom:(NUCTokenStream *)aStream into:(NUCPostfixExpression **)aToken;

+ (instancetype)expressionWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression;

- (instancetype)initWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression;

@end

