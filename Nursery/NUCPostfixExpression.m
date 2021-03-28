//
//  NUCPostfixExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPostfixExpression.h"

@implementation NUCPostfixExpression

+ (instancetype)expressionWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression
{
    return [[[self alloc] initWithPrimaryExpression:aPrimaryExpression] autorelease];
}

- (instancetype)initWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression
{
    if (self = [super initWithType:NUCLexicalElementPostfixExpressionType])
    {
        primaryExpression = [aPrimaryExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [primaryExpression release];
    
    [super dealloc];
}

@end
