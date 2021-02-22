//
//  NUCRelationalExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/18.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCRelationalExpression.h"

@implementation NUCRelationalExpression

+ (instancetype)expressionWithShiftExpression:(NUCShiftExpression *)aShiftExpression
{
    return [[[self alloc] initWithRelationalExpression:nil relationalOperator:nil shiftExpression:aShiftExpression] autorelease];
}

+ (instancetype)expressionWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression
{
    return [[[self alloc] initWithRelationalExpression:aRelationalExpression relationalOperator:aRelationalOperator shiftExpression:aShiftExpression] autorelease];
}

- (instancetype)initWithShiftExpression:(NUCShiftExpression *)aShiftExpression
{
    return [self initWithRelationalExpression:nil relationalOperator:nil shiftExpression:aShiftExpression];
}

- (instancetype)initWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression
{
    if (self = [super initWithType:NUCLexicalElementRelationalExpressionType])
    {
        relationalExpression = [aRelationalExpression retain];
        relationalOperator = [aRelationalOperator retain];
        shiftExpression = [aShiftExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [relationalExpression release];
    [relationalOperator release];
    [shiftExpression release];
    
    [super dealloc];
}

@end
