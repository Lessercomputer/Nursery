//
//  NUCRelationalExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/18.
//

#import "NUCRelationalExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCShiftExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCRelationalExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCTokenStream *)aStream
{
    return [NUCShiftExpression expressionInto:aSubexpression from:aStream];
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return [anOperator isRelationalOperator];
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
