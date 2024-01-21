//
//  NUCUnaryExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCUnaryExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCCastExpression.h"
#import "NUCPostfixExpression.h"
#import "NUCExpressionResult.h"

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
    if (self = [super initWithType:NUCExpressionUnaryExpressionType])
    {
        postfixExpression = [aPostfixExpression retain];
    }
    
    return self;
}

- (instancetype)initWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression
{
    if (self = [super initWithType:NUCExpressionUnaryExpressionType])
    {
        unaryOperator = [anUnaryOperator retain];
        unaryExpression = [anUnaryExpression retain];
    }
    
    return self;
}

- (instancetype)initWithUnaryOperator:(NUCDecomposedPreprocessingToken *)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression
{
    if (self = [super initWithType:NUCExpressionUnaryExpressionType])
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
    [castExpression release];
    
    [super dealloc];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    if (unaryOperator)
    {
        NUCExpressionResult *aCastExpressionResult = [castExpression evaluateWith:aPreprocessor];
        
        if ([unaryOperator isBitwiseComplementOperator])
        {
            int aValue = ~[aCastExpressionResult intValue];
            return [NUCExpressionResult expressionResultWithIntValue:aValue];
        }
        else if ([unaryOperator isLogicalNegationOperator])
        {
            int aValue = ![aCastExpressionResult intValue];
            return [NUCExpressionResult expressionResultWithIntValue:aValue];
        }
        else
            return nil;
    }
    else
        return [postfixExpression evaluateWith:aPreprocessor];
}

@end
