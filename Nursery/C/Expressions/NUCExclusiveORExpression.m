//
//  NUCExclusiveORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCExclusiveORExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCANDExpression.h"
#import "NUCDecomposedPreprocessingToken.h"

@implementation NUCExclusiveORExpression

+ (BOOL)exclusiveORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCExclusiveORExpression **)aToken
{
    NUCANDExpression *anANDExpression = nil;
    
    if ([NUCANDExpression andExpressionFrom:aStream into:&anANDExpression])
    {
        if (aToken)
            *aToken = [NUCExclusiveORExpression expressionWithANDExpression:anANDExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCExclusiveORExpression *anExclusiveORExpression = nil;
        
        if ([NUCExclusiveORExpression exclusiveORExpressionFrom:aStream into:&anExclusiveORExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anExclusiveOROperator = [aStream next];
            
            if ([anExclusiveOROperator isExclusiveOROperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                if ([NUCANDExpression andExpressionFrom:aStream into:&anANDExpression])
                {
                    if (aToken)
                        *aToken = [NUCExclusiveORExpression expressionWithExclusiveORExpression:anExclusiveORExpression exclusiveOROperator:anExclusiveOROperator andExpression:anANDExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
}

+ (instancetype)expressionWithANDExpression:(NUCANDExpression *)anANDExpression
{
    return [self expressionWithExclusiveORExpression:nil exclusiveOROperator:nil andExpression:anANDExpression];
}

+ (instancetype)expressionWithExclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression exclusiveOROperator:(NUCDecomposedPreprocessingToken *)anExclusiveOROperator andExpression:(NUCANDExpression *)anANDExpression
{
    return [[[self alloc] initWithExclusiveORExpression:anExclusiveORExpression exclusiveOROperator:anExclusiveOROperator andExpression:anANDExpression] autorelease];
}

- (instancetype)initWithANDExpression:(NUCANDExpression *)anANDExpression
{
    return [self initWithExclusiveORExpression:nil exclusiveOROperator:nil andExpression:anANDExpression];
}

- (instancetype)initWithExclusiveORExpression:(NUCExclusiveORExpression *)anExclusiveORExpression exclusiveOROperator:(NUCDecomposedPreprocessingToken *)anExclusiveOROperator andExpression:(NUCANDExpression *)anANDExpression
{
    if (self = [super initWithType:NUCExpressionExclusiveORExpressionType])
    {
        exclusiveORExpression = [anExclusiveORExpression retain];
        exclusiveOROperator = [anExclusiveOROperator retain];
        andExpression = [anANDExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [exclusiveORExpression release];
    [exclusiveOROperator release];
    [andExpression release];
    
    [super dealloc];
}

- (NUCExpressionResult *)executeWith:(NUCPreprocessor *)aPreprocessor
{
    return [andExpression executeWith:aPreprocessor];
}

@end
