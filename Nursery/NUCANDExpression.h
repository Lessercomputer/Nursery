//
//  NUCANDExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCEqulityExpression, NUCANDExpression, NUCDecomposedPreprocessingToken;

@interface NUCANDExpression : NUCPreprocessingToken
{
    NUCEqulityExpression *equlityExpression;
    NUCANDExpression *andExpression;
    NUCDecomposedPreprocessingToken *andOperator;
}

+ (instancetype)expressionWithEqualityExpression:(NUCEqulityExpression *)anEqulityExpression;

+ (instancetype)expressionWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqulityExpression *)anEqulityExpression;

- (instancetype)initWithEqualityExpression:(NUCEqulityExpression *)anEqulityExpression;

- (instancetype)initWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqulityExpression *)anEqulityExpression;

@end

