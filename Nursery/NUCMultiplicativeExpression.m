//
//  NUCMultiplicativeExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCMultiplicativeExpression.h"

@implementation NUCMultiplicativeExpression

+ (instancetype)expressionWithCastExpression:(NUCCastExpression *)aCastExpression
{
    return [self expressionWithMultiplicativeExpression:nil multiplicativeOperator:nil castExpression:aCastExpression];
}

+ (instancetype)expressionWithMultiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression multiplicativeOperator:(NUCDecomposedPreprocessingToken *)aMultiplicativeOperator castExpression:(NUCCastExpression *)aCastExpression
{
    return [[[self alloc] initWithMultiplicativeExpression:aMultiplicativeExpression multiplicativeOperator:aMultiplicativeOperator castExpression:aCastExpression] autorelease];
}

- (instancetype)initWithCastExpression:(NUCCastExpression *)aCastExpression
{
    return [self initWithMultiplicativeExpression:nil multiplicativeOperator:nil castExpression:aCastExpression];
}

- (instancetype)initWithMultiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression multiplicativeOperator:(NUCDecomposedPreprocessingToken *)aMultiplicativeOperator castExpression:(NUCCastExpression *)aCastExpression
{
    if (self = [super initWithType:NUCLexicalElementMultiplicativeExpressionType])
    {
        castExpression = [aCastExpression retain];
        multiplicativeExpression = [aMultiplicativeExpression retain];
        multiplicativeOperator = [aMultiplicativeOperator retain];
    }
    
    return self;
}

- (void)dealloc
{
    [castExpression release];
    [multiplicativeExpression release];
    [multiplicativeOperator release];
    
    [super dealloc];
}

@end
