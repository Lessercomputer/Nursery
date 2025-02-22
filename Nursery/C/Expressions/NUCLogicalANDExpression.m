//
//  NUCLogicalANDExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/14.
//

#import "NUCLogicalANDExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCInclusiveORExpression.h"
#import "NUCExpressionResult.h"
#import <Foundation/NSArray.h>

@implementation NUCLogicalANDExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCTokenStream *)aStream
{
    return [NUCInclusiveORExpression expressionInto:aSubexpression from:aStream];
}

+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator
{
    return [anOperator isLogicalANDOperator];
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionLogicalANDExpressionType];
}

- (void)add:(NUCProtoExpression *)anExpression
{
    [[self expressions] addObject:anExpression];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    __block NUCExpressionResult *anExpressionResultToReturn = nil;
    
    [[self expressions] enumerateObjectsUsingBlock:^(id _Nonnull anExpression, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NUCExpressionResult *anExpressionResult = [[anExpression evaluateWith:aPreprocessor] retain];
        if (![anExpressionResult intValue])
        {
            *stop = YES;
            anExpressionResultToReturn = anExpressionResult;
        }
    }];
    
    [anExpressionResultToReturn autorelease];
    
    return anExpressionResultToReturn ? anExpressionResultToReturn : [NUCExpressionResult expressionResultWithIntValue:1];
}

@end
