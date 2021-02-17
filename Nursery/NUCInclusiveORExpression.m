//
//  NUCInclusiveORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCInclusiveORExpression.h"

@implementation NUCInclusiveORExpression

+ (instancetype)expressionExclusiveExpression:(NUCExclusiveORExpression *)anExclusiveORExpression
{
    return [[[self alloc] initWithExclusiveExpression:anExclusiveORExpression] autorelease];
}

+ (instancetype)expressionWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression inclusiveOROperator:(NUCDecomposedPreprocessingToken *)anInclusiveOROperator exclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression
{
    return [[[self alloc] initWithInclusiveORExpression:anInclusiveORExpression inclusiveOROperator:anInclusiveOROperator exclusiveORExpression:anExclusiveORExpression] autorelease];
}

- (instancetype)initWithExclusiveExpression:(NUCExclusiveORExpression *)anExclusiveORExpression
{
    return [self initWithInclusiveORExpression:nil inclusiveOROperator:nil exclusiveORExpression:anExclusiveORExpression];
}

- (instancetype)initWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression inclusiveOROperator:(NUCDecomposedPreprocessingToken *)anInclusiveOROperator exclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression
{
    if (self = [super initWithType:NUCLexicalElementInclusiveORExpressionType])
    {
        inclusiveORExpression = [anInclusiveORExpression retain];
        inclusiveOROperator = [anInclusiveOROperator retain];
        exclusiveORExpression = [anExclusiveORExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [inclusiveORExpression release];
    [inclusiveOROperator release];
    [exclusiveORExpression release];
    
    [super dealloc];
}

@end
