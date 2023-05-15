//
//  NUCUnaryExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCUnaryExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCCastExpression.h"
#import "NUCPostfixExpression.h"

@implementation NUCUnaryExpression

+ (BOOL)unaryExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCUnaryExpression **)aToken
{
    NUCPostfixExpression *aPostfixExpression = nil;
    
    if ([NUCPostfixExpression postfixExpressionFrom:aStream into:&aPostfixExpression])
    {
        if (aToken)
            *aToken = [NUCUnaryExpression expressionWithPostfixExpression:aPostfixExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCDecomposedPreprocessingToken *anUnaryOperator = [aStream next];
        
        if ([anUnaryOperator isUnaryOperator])
        {
            NUCCastExpression *aCastExpression = nil;
            
            if ([NUCCastExpression castExpressionFrom:aStream into:&aCastExpression])
            {
                if (aToken)
                    *aToken = [NUCUnaryExpression expressionWithUnaryOperator:anUnaryOperator castExpression:aCastExpression];
                
                return YES;
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
    
    return NO;
}

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
