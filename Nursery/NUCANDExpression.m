//
//  NUCANDExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCANDExpression.h"

@implementation NUCANDExpression


+ (instancetype)expressionWithEqualityExpression:(NUCEqulityExpression *)anEqulityExpression
{
    return [self expressionWithEqualityExpression:anEqulityExpression];
}

+ (instancetype)expressionWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqulityExpression *)anEqulityExpression
{
    return [[[self alloc] initWithANDExpression:anANDExpression andOperator:anANDOperator equlityExpression:anEqulityExpression] autorelease];
}

- (instancetype)initWithEqualityExpression:(NUCEqulityExpression *)anEqulityExpression
{
    return [self initWithANDExpression:nil andOperator:nil equlityExpression:anEqulityExpression];
}

- (instancetype)initWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqulityExpression *)anEqulityExpression
{
    if (self = [super initWithType:NUCLexicalElementANDExpressionType])
    {
        equlityExpression = [anEqulityExpression retain];
        andExpression = [anANDExpression retain];
        andOperator = [andOperator retain];
    }
    
    return self;
}

- (void)dealloc
{
    [equlityExpression release];
    [andExpression release];
    [andOperator release];
    
    [super dealloc];
}

@end
