//
//  NUCAdditiveExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCAdditiveExpression.h"

@implementation NUCAdditiveExpression

+ (instancetype)expressionWithMultiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression
{
    return [self expressionWithAdditiveExpression:nil additiveOperator:nil multiplicativeExpression:aMultiplicativeExpression];
}

+ (instancetype)expressionWithAdditiveExpression:(NUCAdditiveExpression *)anAdditiveExpression additiveOperator:(NUCDecomposedPreprocessingToken *)anAdditiveOperator multiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression
{
    return [[[self alloc] initWithAdditiveExpression:anAdditiveExpression additiveOperator:anAdditiveOperator multiplicativeExpression:aMultiplicativeExpression] autorelease];
}

- (instancetype)initWithMultiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression
{
    return [self initWithAdditiveExpression:nil additiveOperator:nil multiplicativeExpression:aMultiplicativeExpression];
}

- (instancetype)initWithAdditiveExpression:(NUCAdditiveExpression *)anAdditiveExpression additiveOperator:(NUCDecomposedPreprocessingToken *)anAdditiveOperator multiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression
{
    if (self = [super initWithType:NUCLexicalElementAdditiveExpressionType])
    {
        additiveExpression = [anAdditiveExpression retain];
        additiveOperator = [anAdditiveOperator retain];
        multiplicativeExpression = [aMultiplicativeExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [additiveExpression release];
    [additiveOperator release];
    [multiplicativeExpression release];
    
    [super dealloc];
}

@end
