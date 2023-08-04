//
//  NUCLogicalANDExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/14.
//

#import "NUCPreprocessingToken.h"

@class NUCInclusiveORExpression, NUCLogicalANDExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCLogicalANDExpression : NUCPreprocessingToken
{
    NUCInclusiveORExpression *inclusiveORExpression;
    NUCLogicalANDExpression *logicalANDExpression;
    NUCDecomposedPreprocessingToken *logicalANDOperator;
}

+ (BOOL)logicalANDExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalANDExpression **)aToken;

+ (instancetype)expressionWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression;

+ (instancetype)expressionWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression logicalANDOperator:(NUCDecomposedPreprocessingToken *)aLogicalANDOperator inclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression;

- (instancetype)initWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression;

- (instancetype)initWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression logicalANDOperator:(NUCDecomposedPreprocessingToken *)aLogicalANDOperator inclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression;

@end

