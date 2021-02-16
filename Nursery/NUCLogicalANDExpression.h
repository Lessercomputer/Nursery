//
//  NUCLogicalANDExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/14.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCInclusiveORExpression, NUCLogicalANDExpression, NUCDecomposedPreprocessingToken;

@interface NUCLogicalANDExpression : NUCPreprocessingToken
{
    NUCInclusiveORExpression *inclusiveORExpression;
    NUCLogicalANDExpression *logicalANDExpression;
    NUCDecomposedPreprocessingToken *logicalANDOperator;
}

+ (instancetype)expressionWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression;

+ (instancetype)expressionWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression logicalANDOperator:(NUCDecomposedPreprocessingToken *)aLogicalANDOperator inclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression;

- (instancetype)initWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression;

- (instancetype)initWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression logicalANDOperator:(NUCDecomposedPreprocessingToken *)aLogicalANDOperator inclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression;

@end

