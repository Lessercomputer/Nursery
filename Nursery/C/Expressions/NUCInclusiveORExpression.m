//
//  NUCInclusiveORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCInclusiveORExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCExclusiveORExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCInclusiveORExpression

+ (BOOL)inclusiveORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCInclusiveORExpression **)aToken
{
    NUCInclusiveORExpression *anInclusiveORExpression = [NUCInclusiveORExpression expression];
    
    while (YES)
    {
        NUCExclusiveORExpression *anExclusiveORExpression = nil;
        
        if ([NUCExclusiveORExpression exclusiveORExpressionFrom:aStream into:&anExclusiveORExpression])
        {
            NSUInteger aPosition = [aStream position];
            
            [anInclusiveORExpression add:anExclusiveORExpression];
            
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anInclusiveOROperator =  [aStream next];
            
            if ([anInclusiveOROperator isInclusiveOROperator])
            {
                [aStream skipWhitespacesWithoutNewline];
            }
            else
            {
                [aStream setPosition:aPosition];
                
                if (aToken)
                    *aToken = anInclusiveORExpression;
                
                return YES;
            }
        }
        else
            return NO;
    }
}

- (instancetype)init
{
    return self = [self initWithType:NUCExpressionInclusiveORExpressionType];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    __block int aValue = 0;
    
    [[self expressions] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NUCExpressionResult *anExpressionResult = [obj evaluateWith:aPreprocessor];
        aValue |= [anExpressionResult intValue];
    }];
    
    return [NUCExpressionResult expressionResultWithIntValue:aValue];
}

@end
