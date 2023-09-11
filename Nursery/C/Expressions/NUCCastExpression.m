//
//  NUCCastExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
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

- (NSInteger)executeWithPreprocessor:(NUCPreprocessor *)aPreprocessor
{
    return [unaryExpression executeWithPreprocessor:aPreprocessor];
}

@end
