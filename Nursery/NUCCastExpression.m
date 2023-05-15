//
//  NUCCastExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCCastExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCUnaryExpression.h"

@implementation NUCCastExpression

+ (BOOL)castExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCCastExpression **)aToken
{
    NUCUnaryExpression *anUnaryExpression = nil;
    
    if ([NUCUnaryExpression unaryExpressionFrom:aStream into:&anUnaryExpression])
    {
        if (aToken)
            *aToken = [NUCCastExpression expressionWithUnaryExpression:anUnaryExpression];
        
        return YES;
    }
                       
    return NO;
}

+ (instancetype)expressionWithUnaryExpression:(NUCUnaryExpression *)anUnaryExpression
{
    return [[[self alloc] initWithUnaryExpression:anUnaryExpression] autorelease];
}

- (instancetype)initWithUnaryExpression:(NUCUnaryExpression *)anUnaryExpression
{
    if (self = [super initWithType:NUCLexicalElementUnaryExpressionType])
    {
        unaryExpression = [anUnaryExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [unaryExpression release];
    
    [super dealloc];
}

@end
