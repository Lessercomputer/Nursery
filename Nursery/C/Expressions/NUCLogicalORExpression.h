//
//  NUCLogicalORExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCPreprocessingToken.h"

@class NUCLogicalANDExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCLogicalORExpression : NUCPreprocessingToken
{
    NUCLogicalORExpression *logicalORExpression;
    NUCDecomposedPreprocessingToken *logicalOROperator;
    NUCLogicalANDExpression *logicalANDExpression;
}

+ (BOOL)logicalORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalORExpression **)aToken;

+ (instancetype)expressionWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;

+ (instancetype)expressionWithlogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression logicalOREperator:(NUCDecomposedPreprocessingToken *)aLogicalOROperator logicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;

- (instancetype)initWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;

- (instancetype)initWithlogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression logicalOREperator:(NUCDecomposedPreprocessingToken *)aLogicalOROperator logicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;

@end

