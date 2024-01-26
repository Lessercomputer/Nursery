//
//  NUCExclusiveORExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCExclusiveORExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCANDExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCExpressionResult.h"

@implementation NUCExclusiveORExpression

+ (BOOL)exclusiveORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCExclusiveORExpression **)anExpression
{
    NUCExclusiveORExpression *anExclusiviORExpression = [self expression];
    
    while (YES)
    {
        NUCANDExpression *anANDExpression = nil;
        
        if ([NUCANDExpression andExpressionFrom:aStream into:&anANDExpression])
        {
            NSInteger aPosition = [aStream position];
            
            [anExclusiviORExpression add:anANDExpression];
            
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aStream next];
            
            if ([anOperator isExclusiveOROperator])
            {
                [aStream skipWhitespacesWithoutNewline];
            }
            else
            {
                [aStream setPosition:aPosition];
                
                if (anExpression)
                    *anExpression = anExclusiviORExpression;
                
                return YES;
            }
        }
        else
            return NO;
    }
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
