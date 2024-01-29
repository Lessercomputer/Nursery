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
#import "NUCExpressionResult.h"

@implementation NUCMultiplicativeExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCPreprocessingTokenStream *)aStream
{
    return [NUCCastExpression castExpressionFrom:aStream into:(NUCCastExpression **)aSubexpression];
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return [anOperator isMultiplicativeOperator];
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionMultiplicativeExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    return [self evaluateWith:aPreprocessor using:^(NUCExpressionResult *aLeftExpressionResult, NUCDecomposedPreprocessingToken *anOperator, NUCExpressionResult *aRightExpressionResult, NUCExpressionResult **aBinaryExpressionResult) {
        
        int aValue = 0;
        
        if ([anOperator isMultiplicationOperator])
            aValue = [aLeftExpressionResult intValue] * [aRightExpressionResult intValue];
        else if ([anOperator isDivisionOperator])
            aValue = [aLeftExpressionResult intValue] / [aRightExpressionResult intValue];
        else if ([anOperator isRemainderOperator])
            aValue = [aLeftExpressionResult intValue] % [aRightExpressionResult intValue];
        
        *aBinaryExpressionResult = [NUCExpressionResult expressionResultWithIntValue:aValue];
    }];
}

@end
