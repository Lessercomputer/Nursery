//
//  NUCInclusiveORExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCDecomposedPreprocessingToken, NUCExclusiveORExpression;

@interface NUCInclusiveORExpression : NUCPreprocessingToken
{
    NUCInclusiveORExpression *inclusiveORExpression;
    NUCDecomposedPreprocessingToken *inclusiveOROperator;
    NUCExclusiveORExpression *exclusiveORExpression;
}

+ (instancetype)expressionExclusiveExpression:(NUCExclusiveORExpression *)anExclusiveORExpression;

+ (instancetype)expressionWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression inclusiveOROperator:(NUCDecomposedPreprocessingToken *)anInclusiveOROperator exclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression;

- (instancetype)initWithExclusiveExpression:(NUCExclusiveORExpression *)anExclusiveORExpression;

- (instancetype)initWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression inclusiveOROperator:(NUCDecomposedPreprocessingToken *)anInclusiveOROperator exclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression;

@end

