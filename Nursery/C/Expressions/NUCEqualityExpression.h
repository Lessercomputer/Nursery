//
//  NUCEqualityExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/17.
//

#import "NUCPreprocessingToken.h"

@class NUCRelationalExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCEqualityExpression : NUCPreprocessingToken
{
    NUCRelationalExpression *relationalExpression;
    NUCEqualityExpression *equalityExpression;
    NUCDecomposedPreprocessingToken *equalityOperator;
}

+ (BOOL)equalityExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCEqualityExpression **)aToken;

+ (instancetype)expressionWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression;

+ (instancetype)expressionWithEqualityExpression:(NUCEqualityExpression *)anEqualityExpression equalityOperator:(NUCDecomposedPreprocessingToken *)anOperator relationalExpression:(NUCRelationalExpression *)aRelationalExpression;

- (instancetype)initWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression;

- (instancetype)initWithEqualityExpression:(NUCEqualityExpression *)anEqualityExpression equalityOperator:(NUCDecomposedPreprocessingToken *)anOperator relationalExpression:(NUCRelationalExpression *)aRelationalExpression;

@end

