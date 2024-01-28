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
    NUCExpressionResult *anExpressionResult = [self evaluateWith:aPreprocessor using:^(NUCExpressionResult *aPreviousExpressionResult, NUCDecomposedPreprocessingToken *anOperator, NUCExpressionResult *anExpressionResult, NUCExpressionResult **aBinaryExpressionResult) {
        
        int aValue = 0;

        if (aPreviousExpressionResult)
        {
            if ([anOperator isLessThanOperator])
                aValue = [aPreviousExpressionResult intValue] < [anExpressionResult intValue];
            else if ([anOperator isGreaterThanOperator])
                aValue = [aPreviousExpressionResult intValue] > [anExpressionResult intValue];
            else if ([anOperator isLessThanOrEqualToOperator])
                aValue = [aPreviousExpressionResult intValue] <= [anExpressionResult intValue];
            else if ([anOperator isGreaterThanOrEqualToOperator])
                aValue = [aPreviousExpressionResult intValue] >= [anExpressionResult intValue];
        }
        else
        {
            aValue = [anExpressionResult intValue];
        }
        
        if (aBinaryExpressionResult)
            *aBinaryExpressionResult = [NUCExpressionResult expressionResultWithIntValue:aValue];
    }];
    
    return anExpressionResult;
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor using:(void (^)(NUCExpressionResult *aPreviousExpressionResult, NUCDecomposedPreprocessingToken *anOperator, NUCExpressionResult *anExpressionResult, NUCExpressionResult **aBinaryExpressionResult))aBlock
{
    NSMutableArray *anExpressionResults = [NSMutableArray array];
    
    [[self expressions] enumerateObjectsUsingBlock:^(id  _Nonnull anExpression, NSUInteger idx, BOOL * _Nonnull stop) {
        [anExpressionResults addObject:[anExpression evaluateWith:aPreprocessor]];
    }];
    
    __block NUCExpressionResult *aPreviousExpressionResult = nil;
    __block NUCExpressionResult *aBinaryExpressionResult = nil;
    __block NSMutableArray *aBinaryExpressionResults = [NSMutableArray array];
    
    [anExpressionResults enumerateObjectsUsingBlock:^(NUCExpressionResult * _Nonnull anExpressionResult, NSUInteger anIndex, BOOL * _Nonnull stop) {
        
        if (!aPreviousExpressionResult)
        {
            aBlock(nil, nil, anExpressionResult, &aBinaryExpressionResult);
            aPreviousExpressionResult = aBinaryExpressionResult;
        }
        else
        {
            aBlock(aPreviousExpressionResult, [self operatorAt:anIndex - 1], anExpressionResult, &aBinaryExpressionResult);
            aPreviousExpressionResult = aBinaryExpressionResult;
        }
        
        [aBinaryExpressionResults addObject:aPreviousExpressionResult];
    }];
    
    return [aBinaryExpressionResults lastObject];
}

@end
