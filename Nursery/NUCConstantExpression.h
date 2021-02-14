//
//  NUCConstantExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCConditionalExpression;

@interface NUCConstantExpression : NUCPreprocessingToken
{
    NUCConditionalExpression *conditionalExpression;
}

+ (instancetype)expressionWithConditionalExpression:(NUCConditionalExpression *)anExpression;

- (instancetype)initWithConditionalExpression:(NUCConditionalExpression *)anExpression;

- (NUCConditionalExpression *)conditionalExpression;

@end

