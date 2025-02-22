//
//  NUCExclusiveORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCExclusiveORExpression.h"
#import "NUCANDExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCExpressionResult.h"

@implementation NUCExclusiveORExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCTokenStream *)aStream
{
    return [NUCANDExpression expressionInto:aSubexpression from:aStream];
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return [anOperator isExclusiveOROperator];
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionExclusiveORExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    __block int aValue = 0;
    
    [[self expressions] enumerateObjectsUsingBlock:^(id _Nonnull anExpression, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NUCExpressionResult *anExpressionResult = [anExpression evaluateWith:aPreprocessor];
        aValue ^= [anExpressionResult intValue];
    }];
    
    return [NUCExpressionResult expressionResultWithIntValue:aValue];
}

@end
