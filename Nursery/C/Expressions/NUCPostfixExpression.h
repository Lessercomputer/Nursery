//
//  NUCPostfixExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCPreprocessingToken.h"

@class NUCPrimaryExpression, NUCPreprocessingTokenStream;

@interface NUCPostfixExpression : NUCPreprocessingToken
{
    NUCPrimaryExpression *primaryExpression;
}

+ (BOOL)postfixExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPostfixExpression **)aToken;

+ (instancetype)expressionWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression;

- (instancetype)initWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression;

- (NSInteger)executeWithPreprocessor:(NUCPreprocessor *)aPreprocessor;

@end

