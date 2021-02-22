//
//  NUCUnaryExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCUnaryExpression.h"

@implementation NUCUnaryExpression

+ (instancetype)expressionWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression
{
    return [[[self alloc] initWithPostfixExpression:aPostfixExpression] autorelease];
}

+ (instancetype)expressionWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression
{
    return [[[self alloc] initWithUnaryOperator:anUnaryOperator unaryExpression:anUnaryExpression] autorelease];
}

+ (instancetype)expressionWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression
{
    return [[[self alloc] initWithUnaryOperator:anUnaryOperator castExpression:aCastExpression] autorelease];
}

- (instancetype)initWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression
{
    if (self = [super initWithType:NUCLexicalElementUnaryExpressionType])
    {
        postfixExpression = [aPostfixExpression retain];
    }
    
    return self;
}

- (instancetype)initWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression
{
    if (self = [super initWithType:NUCLexicalElementUnaryExpressionType])
    {
        unaryOperator = [anUnaryOperator retain];
        unaryExpression = [anUnaryExpression retain];
    }
    
    return self;
}

- (instancetype)initWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression
{
    if (self = [super initWithType:NUCLexicalElementUnaryExpressionType])
    {
        unaryOperator = [anUnaryOperator retain];
        castExpression = [aCastExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [postfixExpression release];
    [unaryOperator release];
    [unaryExpression release];
    
    [super dealloc];
}

@end
