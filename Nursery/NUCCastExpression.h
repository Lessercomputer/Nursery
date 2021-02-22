//
//  NUCCastExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCUnaryExpression;

@interface NUCCastExpression : NUCPreprocessingToken
{
    NUCUnaryExpression *unaryExpression;
}

+ (instancetype)expressionWithUnaryExpression:(NUCUnaryExpression *)anUnaryExpression;

- (instancetype)initWithUnaryExpression:(NUCUnaryExpression *)anUnaryExpression;

@end

