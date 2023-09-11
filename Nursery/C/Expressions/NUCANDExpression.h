//
//  NUCANDExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCPreprocessingToken.h"

@class NUCEqualityExpression, NUCANDExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCANDExpression : NUCPreprocessingToken
{
    NUCEqualityExpression *equlityExpression;
    NUCANDExpression *andExpression;
    NUCDecomposedPreprocessingToken *andOperator;
}

+ (BOOL)andExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCANDExpression **)aToken;

+ (instancetype)expressionWithEqualityExpression:(NUCEqualityExpression *)anEqulityExpression;

+ (instancetype)expressionWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqualityExpression *)anEqulityExpression;

- (instancetype)initWithEqualityExpression:(NUCEqualityExpression *)anEqulityExpression;

- (instancetype)initWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqualityExpression *)anEqulityExpression;

- (NSInteger)executeWithPreprocessor:(NUCPreprocessor *)aPreprocessor;

@end

