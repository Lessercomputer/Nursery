//
//  NUCPostfixExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCPrimaryExpression;

@interface NUCPostfixExpression : NUCPreprocessingToken
{
    NUCPrimaryExpression *primaryExpression;
}

+ (instancetype)expressionWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression;

- (instancetype)initWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression;

@end

