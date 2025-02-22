//
//  NUCLogicalORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCLogicalORExpression.h"
#import "NUCLogicalANDExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCExpressionResult.h"

#import <Foundation/NSArray.h>

@implementation NUCLogicalORExpression

+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCTokenStream *)aStream
{
    return [NUCLogicalANDExpression expressionInto:aSubexpression from:aStream];
}

+ (BOOL)operatorIsValid:(id <NUCToken>)anOperator
{
    return [anOperator isLogicalOROperator];
}

- (instancetype)init
{
    return [self initWithType:NUCExpressionLogicalORExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    __block NUCExpressionResult *anExpressionResultToReturn = nil;
    
    [[self expressions] enumerateObjectsUsingBlock:^(id  _Nonnull anExpression, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NUCExpressionResult *anExpressionResult = [[anExpression evaluateWith:aPreprocessor] retain];
        if ([anExpressionResult intValue])
        {
            *stop = YES;
            anExpressionResultToReturn = anExpressionResult;
        }
    }];
    
    [anExpressionResultToReturn autorelease];
    
    return anExpressionResultToReturn ? anExpressionResultToReturn : [NUCExpressionResult expressionResultWithIntValue:0];
}

@end
