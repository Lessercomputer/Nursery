//
//  NUCShiftExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCPreprocessingToken.h"

@class NUCAdditiveExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCShiftExpression : NUCPreprocessingToken
{
    NUCAdditiveExpression *additiveExpression;
    NUCShiftExpression *shiftExpression;
    NUCDecomposedPreprocessingToken *shiftOperator;
}

+ (BOOL)shiftExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCShiftExpression **)aToken;

+ (instancetype)expressionWithAdditiveExpression:(NUCAdditiveExpression *)anAdditiveExpression;

+ (instancetype)expressionWithShiftExpression:(NUCShiftExpression *)aShiftExpression shiftOperator:(NUCDecomposedPreprocessingToken *)aShiftOperator additiveExpression:(NUCAdditiveExpression *)anAdditiveExpression;

- (instancetype)initWithAdditiveExpression:(NUCAdditiveExpression *)anAdditiveExpression;

- (instancetype)initWithShiftExpression:(NUCShiftExpression *)aShiftExpression shiftOperator:(NUCDecomposedPreprocessingToken *)aShiftOperator additiveExpression:(NUCAdditiveExpression *)anAdditiveExpression;

- (NSInteger)executeWithPreprocessor:(NUCPreprocessor *)aPreprocessor;

@end

