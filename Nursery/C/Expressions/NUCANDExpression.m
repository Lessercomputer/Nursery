//
//  NUCANDExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCANDExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCEqualityExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCANDExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCPreprocessingTokenStream *)aStream
{
    return [NUCEqualityExpression expressionInto:aSubexpression from:aStream];
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return [anOperator isBitwiseANDOperator];
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionANDExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    __block int aValue = ~0;
    
    [[self expressions] enumerateObjectsUsingBlock:^(id _Nonnull anExpression, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NUCExpressionResult *anExpressionResult = [anExpression evaluateWith:aPreprocessor];
        aValue &= [anExpressionResult intValue];
    }];
    
    return [NUCExpressionResult expressionResultWithIntValue:aValue];
}

@end
