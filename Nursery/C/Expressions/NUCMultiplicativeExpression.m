//
//  NUCMultiplicativeExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCMultiplicativeExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCCastExpression.h"

@implementation NUCMultiplicativeExpression

+ (BOOL)multiplicativeExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCMultiplicativeExpression **)aToken
{
    NUCCastExpression *aCastExpression = nil;
    
    if ([NUCCastExpression castExpressionFrom:aStream into:&aCastExpression])
    {
        if (aToken)
            *aToken = [NUCMultiplicativeExpression expressionWithCastExpression:aCastExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCMultiplicativeExpression *aMultiplicativeExpression = nil;
        
        if ([NUCMultiplicativeExpression multiplicativeExpressionFrom:aStream into:&aMultiplicativeExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *aMultiplicativeOperator = [aStream next];
            
            if ([aMultiplicativeOperator isMultiplicativeOperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                if ([NUCCastExpression castExpressionFrom:aStream into:&aCastExpression])
                {
                    if (aToken)
                        *aToken = [NUCMultiplicativeExpression expressionWithMultiplicativeExpression:aMultiplicativeExpression multiplicativeOperator:aMultiplicativeOperator castExpression:aCastExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
}


+ (instancetype)expressionWithCastExpression:(NUCCastExpression *)aCastExpression
{
    return [self expressionWithMultiplicativeExpression:nil multiplicativeOperator:nil castExpression:aCastExpression];
}

+ (instancetype)expressionWithMultiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression multiplicativeOperator:(NUCDecomposedPreprocessingToken *)aMultiplicativeOperator castExpression:(NUCCastExpression *)aCastExpression
{
    return [[[self alloc] initWithMultiplicativeExpression:aMultiplicativeExpression multiplicativeOperator:aMultiplicativeOperator castExpression:aCastExpression] autorelease];
}

- (instancetype)initWithCastExpression:(NUCCastExpression *)aCastExpression
{
    return [self initWithMultiplicativeExpression:nil multiplicativeOperator:nil castExpression:aCastExpression];
}

- (instancetype)initWithMultiplicativeExpression:(NUCMultiplicativeExpression *)aMultiplicativeExpression multiplicativeOperator:(NUCDecomposedPreprocessingToken *)aMultiplicativeOperator castExpression:(NUCCastExpression *)aCastExpression
{
    if (self = [super initWithType:NUCLexicalElementMultiplicativeExpressionType])
    {
        castExpression = [aCastExpression retain];
        multiplicativeExpression = [aMultiplicativeExpression retain];
        multiplicativeOperator = [aMultiplicativeOperator retain];
    }
    
    return self;
}

- (void)dealloc
{
    [castExpression release];
    [multiplicativeExpression release];
    [multiplicativeOperator release];
    
    [super dealloc];
}

- (NSInteger)executeWithPreprocessor:(NUCPreprocessor *)aPreprocessor
{
    return [castExpression executeWithPreprocessor:aPreprocessor];
}

@end
