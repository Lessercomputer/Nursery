//
//  NUCRelationalExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/18.
//

#import "NUCProtoExpression.h"

@class NUCShiftExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCRelationalExpression : NUCProtoExpression
{
    NUCShiftExpression *shiftExpression;
    NUCRelationalExpression *relationalExpression;
    NUCDecomposedPreprocessingToken *relationalOperator;
}

+ (BOOL)relationalExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCRelationalExpression **)aToken;

+ (instancetype)expressionWithShiftExpression:(NUCShiftExpression *)aShiftExpression;

+ (instancetype)expressionWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression;

- (instancetype)initWithShiftExpression:(NUCShiftExpression *)aShiftExpression;

- (instancetype)initWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression;

@end

