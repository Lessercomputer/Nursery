//
//  NUCExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCExpression.h"

@implementation NUCExpression

+ (instancetype)expressionWithConditionalExpression:(NUCConditionalExpression *)aConditionalExpression
{
    return [[[self alloc] initWithConditionalExpression:aConditionalExpression] autorelease];
}

- (instancetype)initWithConditionalExpression:(NUCConditionalExpression *)aConditionalExpression
{
    if (self = [super initWithType:NUCLexicalElementExpressionType])
    {
        conditionalExpression = [aConditionalExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [conditionalExpression release];
    
    [super dealloc];
}

@end
