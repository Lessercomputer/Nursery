//
//  NUCInclusiveORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCInclusiveORExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCExclusiveORExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCInclusiveORExpression

+ (BOOL)inclusiveORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCInclusiveORExpression **)aToken
{
    NUCExclusiveORExpression *anExclusiveORExpression = nil;
    
    if ([NUCExclusiveORExpression exclusiveORExpressionFrom:aStream into:&anExclusiveORExpression])
    {
        if (aToken)
            *aToken = [NUCInclusiveORExpression expressionExclusiveExpression:anExclusiveORExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCInclusiveORExpression *anInclusiveExpression = nil;
        
        if ([self inclusiveORExpressionFrom:aStream into:&anInclusiveExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anInclusiveOROperator =  [aStream next];
            if ([anInclusiveOROperator isInclusiveOROperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                NUCExclusiveORExpression *anExclusiveORExpression = nil;
                if ([NUCExclusiveORExpression exclusiveORExpressionFrom:aStream into:&anExclusiveORExpression])
                {
                    if (aToken)
                        *aToken = [NUCInclusiveORExpression expressionWithInclusiveORExpression:anInclusiveExpression inclusiveOROperator:anInclusiveOROperator exclusiveORExpression:anExclusiveORExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
}

+ (instancetype)expressionExclusiveExpression:(NUCExclusiveORExpression *)anExclusiveORExpression
{
    return [[[self alloc] initWithExclusiveExpression:anExclusiveORExpression] autorelease];
}

+ (instancetype)expressionWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression inclusiveOROperator:(NUCDecomposedPreprocessingToken *)anInclusiveOROperator exclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression
{
    return [[[self alloc] initWithInclusiveORExpression:anInclusiveORExpression inclusiveOROperator:anInclusiveOROperator exclusiveORExpression:anExclusiveORExpression] autorelease];
}

- (instancetype)initWithExclusiveExpression:(NUCExclusiveORExpression *)anExclusiveORExpression
{
    return [self initWithInclusiveORExpression:nil inclusiveOROperator:nil exclusiveORExpression:anExclusiveORExpression];
}

- (instancetype)initWithInclusiveORExpression:(NUCInclusiveORExpression *)anInclusiveORExpression inclusiveOROperator:(NUCDecomposedPreprocessingToken *)anInclusiveOROperator exclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression
{
    if (self = [super initWithType:NUCExpressionInclusiveORExpressionType])
    {
        inclusiveORExpression = [anInclusiveORExpression retain];
        inclusiveOROperator = [anInclusiveOROperator retain];
        exclusiveORExpression = [anExclusiveORExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [inclusiveORExpression release];
    [inclusiveOROperator release];
    [exclusiveORExpression release];
    
    [super dealloc];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    if (inclusiveOROperator)
    {
        NUCExpressionResult *anExpressionResultOfInclusiveOr = [inclusiveORExpression evaluateWith:aPreprocessor];
        NUCExpressionResult *anExpressionResultOfExclusiveOr = [exclusiveORExpression evaluateWith:aPreprocessor];
        
        int aValue =
        [anExpressionResultOfInclusiveOr intValue] | [anExpressionResultOfExclusiveOr intValue];
        return [[[NUCExpressionResult alloc] initWithIntValue:aValue] autorelease];
    }
    else
        return [exclusiveORExpression evaluateWith:aPreprocessor];
}

@end
