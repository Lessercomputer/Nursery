//
//  NUCConstantExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCConstantExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCConditionalExpression.h"

@implementation NUCConstantExpression

+ (BOOL)constantExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCConstantExpression **)aConstantExpression
{
    NUCConditionalExpression *aConditionalExpression = nil;
    
    if ([NUCConditionalExpression conditionalExpressionFrom:aStream into:&aConditionalExpression])
    {
        if (aConstantExpression)
            *aConstantExpression = [NUCConstantExpression expressionWithConditionalExpression:aConditionalExpression];
        
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
    if (self = [super initWithType:NUCExpressionConstantExpressionType])
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

- (NUCExpressionResult *)executeWith:(NUCPreprocessor *)aPreprocessor
{
    return [[self conditionalExpression] executeWith:aPreprocessor];
}

@end
