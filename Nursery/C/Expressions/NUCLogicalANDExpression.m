//
//  NUCLogicalANDExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/14.
//

#import "NUCLogicalANDExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCInclusiveORExpression.h"
#import "NUCExpressionResult.h"
#import <Foundation/NSArray.h>

@implementation NUCLogicalANDExpression

+ (BOOL)logicalANDExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalANDExpression **)anExpression
{
    NUCLogicalANDExpression *aLogicalANDExpression = [self expression];
    
    while (YES)
    {
        NUCInclusiveORExpression *anInclusiveORExpression = nil;
        
        if ([NUCInclusiveORExpression inclusiveORExpressionFrom:aStream into:&anInclusiveORExpression])
        {
            NSUInteger aPosition = [aStream position];
            
            [aLogicalANDExpression add:anInclusiveORExpression];

            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aStream next];
            
            if ([anOperator isLogicalANDOperator])
            {
                [aStream skipWhitespacesWithoutNewline];
            }
            else
            {
                [aStream setPosition:aPosition];
                
                if (anExpression)
                    *anExpression = aLogicalANDExpression;
                
                return YES;
            }
        }
        else
            return NO;
    }
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
