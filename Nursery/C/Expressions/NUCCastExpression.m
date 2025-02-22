//
//  NUCCastExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCCastExpression.h"
#import "NUCUnaryExpression.h"
#import "NUCDecomposedPreprocessingToken.h"

@implementation NUCCastExpression

+ (BOOL)castExpressionFrom:(NUCTokenStream *)aStream into:(NUCCastExpression **)anExpression
{
    NUCUnaryExpression *anUnaryExpression = nil;
    
    if ([NUCUnaryExpression unaryExpressionFrom:aStream into:&anUnaryExpression])
    {
        if (anExpression)
            *anExpression = [NUCCastExpression expressionWithUnaryExpression:anUnaryExpression];
        
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
    if (self = [super initWithType:NUCExpressionUnaryExpressionType])
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

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    return [unaryExpression evaluateWith:aPreprocessor];
}

@end
