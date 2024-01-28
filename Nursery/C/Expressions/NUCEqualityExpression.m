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
    return [self evaluateWith:aPreprocessor using:^(NUCExpressionResult *aLeftExpressionResult, NUCDecomposedPreprocessingToken *anOperator, NUCExpressionResult *aRightExpressionResult, NUCExpressionResult **aBinaryExpressionResult) {
        
        int aValue = 0;
        
        if ([anOperator isEqualToOperator])
            aValue = [aLeftExpressionResult intValue] == [aRightExpressionResult  intValue];
        else if ([anOperator isNotEqualToOperator])
            aValue = [aLeftExpressionResult intValue] != [aRightExpressionResult  intValue];
        
        if (aBinaryExpressionResult)
            *aBinaryExpressionResult = [NUCExpressionResult expressionResultWithIntValue:aValue];
    }];
}

@end
