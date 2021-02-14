//
//  NUCConstantExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCConstantExpression.h"

@implementation NUCConstantExpression

+ (instancetype)expressionWithConditionalExpression:(NUCConditionalExpression *)anExpression
{
    return [[[self alloc] initWithConditionalExpression:anExpression] autorelease];
}

- (instancetype)initWithConditionalExpression:(NUCConditionalExpression *)anExpression
{
    if (self = [super initWithType:NUCLexicalElementConstantExpressionType])
    {
        conditionalExpression = [anExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [conditionalExpression release];
    
    [super dealloc];
}

- (NUCConditionalExpression *)conditionalExpression
{
    return conditionalExpression;
}

@end
