//
//  NUCAdditiveExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCAdditiveExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCMultiplicativeExpression.h"

@implementation NUCAdditiveExpression

+ (BOOL)additiveExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCAdditiveExpression **)anExpression
{
    NUCMultiplicativeExpression *aMultiplicativeExpression = nil;
    
    if ([NUCMultiplicativeExpression multiplicativeExpressionFrom:aStream into:&aMultiplicativeExpression])
    {
        if (anExpression)
            *anExpression = [NUCAdditiveExpression expressionWithMultiplicativeExpression:aMultiplicativeExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCAdditiveExpression *anAdditiveExpression = nil;
        
        if ([NUCAdditiveExpression additiveExpressionFrom:aStream into:&anAdditiveExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anAdditiveOperator = [aStream next];
            
            if ([anAdditiveOperator isAdditiveOperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                if ([NUCMultiplicativeExpression multiplicativeExpressionFrom:aStream into:&aMultiplicativeExpression])
                {
                    if (anExpression)
                        *anExpression = [NUCAdditiveExpression expressionWithAdditiveExpression:anAdditiveExpression additiveOperator:anAdditiveOperator multiplicativeExpression:aMultiplicativeExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        return NO;
    }
}

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
    if (self = [super initWithType:NUCExpressionAdditiveExpressionType])
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

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    return [multiplicativeExpression evaluateWith:aPreprocessor];
}

@end
