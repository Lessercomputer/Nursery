//
//  NUCExclusiveORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCExclusiveORExpression.h"

@implementation NUCExclusiveORExpression

+ (instancetype)expressionWithANDExpression:(NUCANDExpression *)anANDExpression
{
    return [self expressionWithExclusiveORExpression:nil exclusiveOROperator:nil andExpression:anANDExpression];
}

+ (instancetype)expressionWithExclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression exclusiveOROperator:(NUCDecomposedPreprocessingToken *)anExclusiveOROperator andExpression:(NUCANDExpression *)anANDExpression
{
    return [[[self alloc] initWithExclusiveORExpression:anExclusiveORExpression exclusiveOROperator:anExclusiveOROperator andExpression:anANDExpression] autorelease];
}

- (instancetype)initWithANDExpression:(NUCANDExpression *)anANDExpression
{
    return [self initWithExclusiveORExpression:nil exclusiveOROperator:nil andExpression:anANDExpression];
}

- (instancetype)initWithExclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression exclusiveOROperator:(NUCDecomposedPreprocessingToken *)anExclusiveOROperator andExpression:(NUCANDExpression *)anANDExpression
{
    if (self = [super initWithType:NUCLexicalElementExclusiveORExpressionType])
    {
        exclusiveORExpression = [anExclusiveORExpression retain];
        exclusiveOROperator = [anExclusiveOROperator retain];
        andExpression = [anANDExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [exclusiveORExpression release];
    [exclusiveOROperator release];
    [andExpression release];
    
    [super dealloc];
}

@end
