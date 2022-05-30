//
//  NUCANDExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCANDExpression.h"

@implementation NUCANDExpression


+ (instancetype)expressionWithEqualityExpression:(NUCEqualityExpression *)anEqulityExpression
{
    return [[[self alloc] initWithEqualityExpression:anEqulityExpression] autorelease];
}

+ (instancetype)expressionWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqualityExpression *)anEqulityExpression
{
    return [[[self alloc] initWithANDExpression:anANDExpression andOperator:anANDOperator equlityExpression:anEqulityExpression] autorelease];
}

- (instancetype)initWithEqualityExpression:(NUCEqualityExpression *)anEqulityExpression
{
    return [self initWithANDExpression:nil andOperator:nil equlityExpression:anEqulityExpression];
}

- (instancetype)initWithANDExpression:(NUCANDExpression *)anANDExpression andOperator:(NUCDecomposedPreprocessingToken *)anANDOperator equlityExpression:(NUCEqualityExpression *)anEqulityExpression
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
