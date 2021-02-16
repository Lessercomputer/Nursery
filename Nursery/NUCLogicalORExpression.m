//
//  NUCLogicalORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCLogicalORExpression.h"

@implementation NUCLogicalORExpression

+ (instancetype)expressionWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression
{
    return [[[self alloc] initWithLogicalANDExpression:aLogicalANDExpression] autorelease];
}

+ (instancetype)expressionWithlogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression logicalOREperator:(NUCDecomposedPreprocessingToken *)aLogicalOROperator logicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression
{
    return [[[self alloc] initWithlogicalORExpression:aLogicalORExpression logicalOREperator:aLogicalOROperator logicalANDExpression:aLogicalANDExpression] autorelease];
}

- (instancetype)initWithLogicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;
{
    return [self initWithlogicalORExpression:nil logicalOREperator:nil logicalANDExpression:aLogicalANDExpression];
}

- (instancetype)initWithlogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression logicalOREperator:(NUCDecomposedPreprocessingToken *)aLogicalOROperator logicalANDExpression:(NUCLogicalANDExpression *)aLogicalANDExpression;
{
    if (self = [super initWithType:NUCLexicalElementLogicalORExpressionType])
    {
        logicalORExpression = [aLogicalORExpression retain];
        logicalOROperator = [aLogicalOROperator retain];
        logicalANDExpression = [aLogicalANDExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [logicalORExpression release];
    [logicalOROperator release];
    [logicalANDExpression release];
    
    [super dealloc];
}

@end
