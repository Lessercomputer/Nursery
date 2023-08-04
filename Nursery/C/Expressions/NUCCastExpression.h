//
//  NUCCastExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCPreprocessingToken.h"

@class NUCUnaryExpression, NUCPreprocessingTokenStream;

@interface NUCCastExpression : NUCPreprocessingToken
{
    NUCUnaryExpression *unaryExpression;
}

+ (BOOL)castExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCCastExpression **)aToken;

+ (instancetype)expressionWithUnaryExpression:(NUCUnaryExpression *)anUnaryExpression;

- (instancetype)initWithUnaryExpression:(NUCUnaryExpression *)anUnaryExpression;

@end

