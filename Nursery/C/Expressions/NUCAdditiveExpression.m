//
//  NUCAdditiveExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCAdditiveExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCMultiplicativeExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCAdditiveExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCTokenStream *)aStream
{
    return [NUCMultiplicativeExpression expressionInto:aSubexpression from:aStream];
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return [anOperator isAdditiveOperator];
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionAdditiveExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    return [self evaluateWith:aPreprocessor using:^(NUCExpressionResult *aLeftExpressionResult, NUCDecomposedPreprocessingToken *anOperator, NUCExpressionResult *aRightExpressionResult, NUCExpressionResult **aBinaryExpressionResult) {
        
        int aValue = 0;
        
        if ([anOperator isAdditionOperator])
            aValue = [aLeftExpressionResult intValue] + [aRightExpressionResult intValue];
        else if ([anOperator isSubtractionOperator])
            aValue = [aLeftExpressionResult intValue] - [aRightExpressionResult intValue];
        
        *aBinaryExpressionResult = [NUCExpressionResult expressionResultWithIntValue:aValue];
    }];
}

@end
