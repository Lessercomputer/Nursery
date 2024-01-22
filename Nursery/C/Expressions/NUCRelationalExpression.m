//
//  NUCRelationalExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/18.
//

#import "NUCRelationalExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCShiftExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCRelationalExpression

+ (BOOL)relationalExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCRelationalExpression **)aToken
{
    NUCShiftExpression *aShiftExpression = nil;
    
    if ([NUCShiftExpression shiftExpressionFrom:aStream into:&aShiftExpression])
    {
        if (aToken)
            *aToken = [NUCRelationalExpression expressionWithShiftExpression:aShiftExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCRelationalExpression *aRelationalExpression = nil;
        
        if ([self relationalExpressionFrom:aStream into:&aRelationalExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aStream next];
            
            if ([anOperator isRelationalOperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                if ([NUCShiftExpression shiftExpressionFrom:aStream into:&aShiftExpression])
                {
                    if (aToken)
                        *aToken = [NUCRelationalExpression expressionWithRelationalExpression:aRelationalExpression relationalOperator:anOperator shiftExpression:aShiftExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
}

+ (instancetype)expressionWithShiftExpression:(NUCShiftExpression *)aShiftExpression
{
    return [[[self alloc] initWithRelationalExpression:nil relationalOperator:nil shiftExpression:aShiftExpression] autorelease];
}

+ (instancetype)expressionWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression
{
    return [[[self alloc] initWithRelationalExpression:aRelationalExpression relationalOperator:aRelationalOperator shiftExpression:aShiftExpression] autorelease];
}

- (instancetype)initWithShiftExpression:(NUCShiftExpression *)aShiftExpression
{
    return [self initWithRelationalExpression:nil relationalOperator:nil shiftExpression:aShiftExpression];
}

- (instancetype)initWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression
{
    if (self = [super initWithType:NUCExpressionRelationalExpressionType])
    {
        relationalExpression = [aRelationalExpression retain];
        relationalOperator = [aRelationalOperator retain];
        shiftExpression = [aShiftExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [relationalExpression release];
    [relationalOperator release];
    [shiftExpression release];
    
    [super dealloc];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    if (relationalOperator)
    {
        NUCExpressionResult *aResultOfRelationalExpression = [relationalExpression evaluateWith:aPreprocessor];
        NUCExpressionResult *aResultOfShiftExpression = [shiftExpression evaluateWith:aPreprocessor];
        int aValue = 0;
        
        if ([relationalOperator isLessThanOperator])
            aValue = [aResultOfRelationalExpression intValue] < [aResultOfShiftExpression intValue];
        else if ([relationalOperator isGreaterThanOperator])
            aValue = [aResultOfRelationalExpression intValue] > [aResultOfShiftExpression intValue];
        else if ([relationalOperator isLessThanOrEqualToOperator])
            aValue = [aResultOfRelationalExpression intValue] <= [aResultOfShiftExpression intValue];
        else if ([relationalOperator isGreaterThanOrEqualToOperator])
            aValue = [aResultOfRelationalExpression intValue] >= [aResultOfShiftExpression intValue];
        
        return [NUCExpressionResult expressionResultWithIntValue:aValue];
    }
    else
        return [shiftExpression evaluateWith:aPreprocessor];
}

@end
