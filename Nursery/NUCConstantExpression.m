//
//  NUCConstantExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCConstantExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCConditionalExpression.h"

@implementation NUCConstantExpression

+ (BOOL)constantExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLexicalElement **)aToken
{
    NUCConditionalExpression *aConditionalExpression = nil;
    
    if ([NUCConditionalExpression conditionalExpressionFrom:aStream into:&aConditionalExpression])
    {
        if (aToken)
            *aToken = [NUCConstantExpression expressionWithConditionalExpression:aConditionalExpression];
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)expressionWithConditionalExpression:(NUCConditionalExpression *)anExpression
{
    return [[[self alloc] initWithConditionalExpression:anExpression] autorelease];
}

- (instancetype)initWithConditionalExpression:(NUCConditionalExpression *)anExpression
{
    if (self = [super initWithType:NUCLexicalElementConstantExpressionType])
    {
        conditionalExpression = [anExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [conditionalExpression release];
    
    [super dealloc];
}

- (NUCConditionalExpression *)conditionalExpression
{
    return conditionalExpression;
}

- (void)executeWith:(NUCPreprocessor *)aPreprocessor
{
    [[self conditionalExpression] executeWith:aPreprocessor];
}

@end
