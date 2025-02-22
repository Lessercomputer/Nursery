//
//  NUCEqualityExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/17.
//

#import "NUCEqualityExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCRelationalExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCEqualityExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCTokenStream *)aStream
{
    return [NUCRelationalExpression expressionInto:aSubexpression from:aStream];
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return [anOperator isEqualityOperator] || [anOperator isInequalityOperator];
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
