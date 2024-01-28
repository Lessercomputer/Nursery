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

+ (BOOL)relationalExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCRelationalExpression **)anExpression
{
    NUCRelationalExpression *aRelationalExpression = [self expression];
    
    while (YES)
    {
        NUCShiftExpression *aShiftExpression = nil;
        
        if ([NUCShiftExpression shiftExpressionFrom:aStream into:&aShiftExpression])
        {
            NSUInteger aPosition = [aStream position];
            
            [aRelationalExpression add:aShiftExpression];
            
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aStream next];
            
            if ([anOperator isRelationalOperator])
            {
                [aRelationalExpression addOperator:anOperator];
                [aStream skipWhitespacesWithoutNewline];
            }
            else
            {
                [aStream setPosition:aPosition];
                
                if (anExpression)
                    *anExpression = aRelationalExpression;
                
                return YES;
            }
        }
        else
            return NO;
    }
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionRelationalExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    NUCExpressionResult *anExpressionResult = [self evaluateWith:aPreprocessor using:^(NUCExpressionResult *aLeftExpressionResult, NUCDecomposedPreprocessingToken *anOperator, NUCExpressionResult *aRightExpressionResult, NUCExpressionResult **aBinaryExpressionResult) {
        
        int aValue = 0;

        if ([anOperator isLessThanOperator])
            aValue = [aLeftExpressionResult intValue] < [aRightExpressionResult intValue];
        else if ([anOperator isGreaterThanOperator])
            aValue = [aLeftExpressionResult intValue] > [aRightExpressionResult intValue];
        else if ([anOperator isLessThanOrEqualToOperator])
            aValue = [aLeftExpressionResult intValue] <= [aRightExpressionResult intValue];
        else if ([anOperator isGreaterThanOrEqualToOperator])
            aValue = [aLeftExpressionResult intValue] >= [aRightExpressionResult intValue];
        
        if (aBinaryExpressionResult)
            *aBinaryExpressionResult = [NUCExpressionResult expressionResultWithIntValue:aValue];
    }];
    
    return anExpressionResult;
}

@end
