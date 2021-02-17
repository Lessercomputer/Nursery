//
//  NUCExclusiveORExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCANDExpression, NUCExclusiveORExpression, NUCDecomposedPreprocessingToken;

@interface NUCExclusiveORExpression : NUCPreprocessingToken
{
    NUCExclusiveORExpression *exclusiveORExpression;
    NUCDecomposedPreprocessingToken *exclusiveOROperator;
    NUCANDExpression *andExpression;
}

+ (instancetype)expressionWithANDExpression:(NUCANDExpression *)anANDExpression;

+ (instancetype)expressionWithExclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression exclusiveOROperator:(NUCDecomposedPreprocessingToken *)anExclusiveOROperator andExpression:(NUCANDExpression *)anANDExpression;

- (instancetype)initWithANDExpression:(NUCANDExpression *)anANDExpression;

- (instancetype)initWithExclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression exclusiveOROperator:(NUCDecomposedPreprocessingToken *)anExclusiveOROperator andExpression:(NUCANDExpression *)anANDExpression;

@end

