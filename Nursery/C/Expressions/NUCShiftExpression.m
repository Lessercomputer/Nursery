//
//  NUCShiftExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCShiftExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCAdditiveExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCShiftExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCPreprocessingTokenStream *)aStream
{
    return [NUCAdditiveExpression expressionInto:aSubexpression from:aStream];
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return [anOperator isShiftOperator];
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionShiftExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    return [self evaluateWith:aPreprocessor using:^(NUCExpressionResult *aLeftExpressionResult, NUCDecomposedPreprocessingToken *anOperator, NUCExpressionResult *aRightExpressionResult, NUCExpressionResult **aBinaryExpressionResult) {
        
        int aValue = 0;
        
        if ([anOperator isLeftShiftOperator])
            aValue = [aLeftExpressionResult intValue] << [aRightExpressionResult intValue];
        else if ([anOperator isRightShiftOperator])
            aValue = [aLeftExpressionResult intValue] >> [aRightExpressionResult intValue];
        
        if (aBinaryExpressionResult)
            *aBinaryExpressionResult = [NUCExpressionResult expressionResultWithIntValue:aValue];
    }];
}

@end
