//
//  NUCEqualityExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/17.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCEqualityExpression.h"

@implementation NUCEqualityExpression

+ (instancetype)expressionWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression
{
    return [[[self alloc] initWithRelationalExpression:aRelationalExpression] autorelease];
}

+ (instancetype)expressionWithEqualityExpression:(NUCEqualityExpression *)anEqualityExpression equalityOperator:(NUCDecomposedPreprocessingToken *)anOperator relationalExpression:(NUCRelationalExpression *)aRelationalExpression
{
    return [[[self alloc] initWithEqualityExpression:anEqualityExpression equalityOperator:anOperator relationalExpression:aRelationalExpression] autorelease];
}

- (instancetype)initWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression
{
    return [self initWithEqualityExpression:nil equalityOperator:nil relationalExpression:aRelationalExpression];
}

- (instancetype)initWithEqualityExpression:(NUCEqualityExpression *)anEqualityExpression equalityOperator:(NUCDecomposedPreprocessingToken *)anOperator relationalExpression:(NUCRelationalExpression *)aRelationalExpression
{
    if (self = [super initWithType:NUCLexicalElementEqualityExpressionType])
    {
        relationalExpression = [aRelationalExpression retain];
        equalityExpression = [anEqualityExpression retain];
        equalityOperator = [anOperator retain];
    }
    
    return self;
}

- (void)dealloc
{
    [relationalExpression release];
    [equalityExpression release];
    [equalityOperator release];
    
    [super dealloc];
}

@end
