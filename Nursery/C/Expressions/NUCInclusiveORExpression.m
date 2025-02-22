//
//  NUCInclusiveORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCInclusiveORExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCExclusiveORExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCInclusiveORExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCTokenStream *)aStream
{
    return [NUCExclusiveORExpression expressionInto:aSubexpression from:aStream];
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return [anOperator isInclusiveOROperator];
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionInclusiveORExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    __block int aValue = 0;
    
    [[self expressions] enumerateObjectsUsingBlock:^(id _Nonnull anExpression, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NUCExpressionResult *anExpressionResult = [anExpression evaluateWith:aPreprocessor];
        aValue |= [anExpressionResult intValue];
    }];
    
    return [NUCExpressionResult expressionResultWithIntValue:aValue];
}

@end
