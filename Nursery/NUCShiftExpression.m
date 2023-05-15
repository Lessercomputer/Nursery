//
//  NUCShiftExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCShiftExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCAdditiveExpression.h"

@implementation NUCShiftExpression

+ (BOOL)shiftExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCShiftExpression **)aToken
{
    NUCAdditiveExpression *anAdditiveExpression = nil;
    
    if ([NUCAdditiveExpression additiveExpressionFrom:aStream into:&anAdditiveExpression])
    {
        if (aToken)
            *aToken = [NUCShiftExpression expressionWithAdditiveExpression:anAdditiveExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCShiftExpression *aShiftExpression = nil;
        
        if ([self shiftExpressionFrom:aStream into:&aShiftExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *aShiftOperator = [aStream next];
            
            if ([aShiftOperator isShiftOperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                if ([NUCAdditiveExpression additiveExpressionFrom:aStream into:&anAdditiveExpression])
                {
                    if (aToken)
                        *aToken = [NUCShiftExpression expressionWithShiftExpression:aShiftExpression shiftOperator:aShiftOperator additiveExpression:anAdditiveExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
}

+ (instancetype)expressionWithAdditiveExpression:(NUCAdditiveExpression *)anAdditiveExpression
{
    return [self expressionWithShiftExpression:nil shiftOperator:nil additiveExpression:anAdditiveExpression];
}

+ (instancetype)expressionWithShiftExpression:(NUCShiftExpression *)aShiftExpression shiftOperator:(NUCDecomposedPreprocessingToken *)aShiftOperator additiveExpression:(NUCAdditiveExpression *)anAdditiveExpression
{
    return [[[self alloc] initWithShiftExpression:aShiftExpression shiftOperator:aShiftOperator additiveExpression:anAdditiveExpression] autorelease];
}

- (instancetype)initWithAdditiveExpression:(NUCAdditiveExpression *)anAdditiveExpression
{
    return [self initWithShiftExpression:nil shiftOperator:nil additiveExpression:anAdditiveExpression];
}

- (instancetype)initWithShiftExpression:(NUCShiftExpression *)aShiftExpression shiftOperator:(NUCDecomposedPreprocessingToken *)aShiftOperator additiveExpression:(NUCAdditiveExpression *)anAdditiveExpression
{
    if (self = [super initWithType:NUCLexicalElementShiftExpressionType])
    {
        shiftExpression = [aShiftExpression retain];
        shiftOperator = [aShiftOperator retain];
        additiveExpression = [anAdditiveExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [shiftExpression release];
    [shiftOperator release];
    [additiveExpression release];
    
    [super dealloc];
}

@end
