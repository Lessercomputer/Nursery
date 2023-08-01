//
//  NUCExclusiveORExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCANDExpression, NUCExclusiveORExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCExclusiveORExpression : NUCPreprocessingToken
{
    NUCExclusiveORExpression *exclusiveORExpression;
    NUCDecomposedPreprocessingToken *exclusiveOROperator;
    NUCANDExpression *andExpression;
}

+ (BOOL)exclusiveORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCExclusiveORExpression **)aToken;

+ (instancetype)expressionWithANDExpression:(NUCANDExpression *)anANDExpression;

+ (instancetype)expressionWithExclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression exclusiveOROperator:(NUCDecomposedPreprocessingToken *)anExclusiveOROperator andExpression:(NUCANDExpression *)anANDExpression;

- (instancetype)initWithANDExpression:(NUCANDExpression *)anANDExpression;

- (instancetype)initWithExclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression exclusiveOROperator:(NUCDecomposedPreprocessingToken *)anExclusiveOROperator andExpression:(NUCANDExpression *)anANDExpression;

@end

