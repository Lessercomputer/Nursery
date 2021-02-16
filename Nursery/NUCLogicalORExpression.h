//
//  NUCLogicalORExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCLogicalANDExpression, NUCDecomposedPreprocessingToken;

@interface NUCLogicalORExpression : NUCPreprocessingToken
{
    NUCLogicalORExpression *logicalORExpression;
    NUCDecomposedPreprocessingToken *logicalOROperator;
    NUCLogicalANDExpression *logicalANDExpression;
}

+ (instancetype)expressionWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;

+ (instancetype)expressionWithlogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression logicalOREperator:(NUCDecomposedPreprocessingToken *)aLogicalOROperator logicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;

- (instancetype)initWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;

- (instancetype)initWithlogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression logicalOREperator:(NUCDecomposedPreprocessingToken *)aLogicalOROperator logicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;

@end

