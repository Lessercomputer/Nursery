//
//  NUCEqualityExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/17.
//

#import "NUCEqualityExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCRelationalExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCEqualityExpression

+ (BOOL)equalityExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCEqualityExpression **)anExpression
{
    NUCEqualityExpression *anEqualityExpression = [self expression];
    
    while (YES)
    {
        NUCRelationalExpression *aRelationalExpression = nil;
        
        if ([NUCRelationalExpression relationalExpressionFrom:aStream into:&aRelationalExpression])
        {
            NSUInteger aPosition = [aStream position];
            
            [anEqualityExpression add:aRelationalExpression];
            
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aStream next];
            
            if ([anOperator isEqualityOperator] || [anOperator isInequalityOperator])
            {
                [anEqualityExpression addOperator:anOperator];
                [aStream skipWhitespacesWithoutNewline];
            }
            else
            {
                [aStream setPosition:aPosition];
                
                if (anExpression)
                    *anExpression = anEqualityExpression;
                
                return YES;
            }
        }
        else
            return NO;
    }
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionEqualityExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    NSMutableArray *anExpressionResults = [NSMutableArray array];
    
    [[self expressions] enumerateObjectsUsingBlock:^(id  _Nonnull anExpression, NSUInteger idx, BOOL * _Nonnull stop) {
        [anExpressionResults addObject:[anExpression evaluateWith:aPreprocessor]];
    }];
    
    __block bool aPreviousValueExists = NO;
    __block int aValue = 0;
    
    [anExpressionResults enumerateObjectsUsingBlock:^(NUCExpressionResult * _Nonnull aResultOfEqualityExpression, NSUInteger anIndex, BOOL * _Nonnull stop) {
        
        if (!aPreviousValueExists)
        {
            aResultOfEqualityExpression = [anExpressionResults objectAtIndex:anIndex];
            aValue = [aResultOfEqualityExpression intValue];
            aPreviousValueExists = YES;
        }
        else
        {
            aResultOfEqualityExpression  = [anExpressionResults objectAtIndex:anIndex];
            NUCDecomposedPreprocessingToken *anOperator = [self operatorAt:anIndex - 1];
            
            if ([anOperator isEqualToOperator])
                aValue = aValue == [aResultOfEqualityExpression  intValue];
            else if ([anOperator isNotEqualToOperator])
                aValue = aValue != [aResultOfEqualityExpression  intValue];
        }
    }];

    
    return [NUCExpressionResult expressionResultWithIntValue:aValue];
}

@end
