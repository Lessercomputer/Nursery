//
//  NUCANDExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
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

@end

