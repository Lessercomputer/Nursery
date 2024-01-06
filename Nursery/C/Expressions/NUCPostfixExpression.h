//
//  NUCPostfixExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCProtoExpression.h"

@class NUCPrimaryExpression, NUCPreprocessingTokenStream;

@interface NUCPostfixExpression : NUCProtoExpression
{
    NUCPrimaryExpression *primaryExpression;
}

+ (BOOL)postfixExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPostfixExpression **)aToken;

+ (instancetype)expressionWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression;

- (instancetype)initWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression;

@end

