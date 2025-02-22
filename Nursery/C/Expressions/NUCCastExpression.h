//
//  NUCCastExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCProtoExpression.h"

@class NUCUnaryExpression, NUCTokenStream;

@interface NUCCastExpression : NUCProtoExpression
{
    NUCUnaryExpression *unaryExpression;
}

+ (BOOL)castExpressionFrom:(NUCTokenStream *)aStream into:(NUCCastExpression **)anExpression;

+ (instancetype)expressionWithUnaryExpression:(NUCUnaryExpression *)anUnaryExpression;

- (instancetype)initWithUnaryExpression:(NUCUnaryExpression *)anUnaryExpression;

@end

