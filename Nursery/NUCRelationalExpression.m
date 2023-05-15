//
//  NUCRelationalExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/18.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCRelationalExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCShiftExpression.h"

@implementation NUCRelationalExpression

+ (BOOL)relationalExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCRelationalExpression **)aToken
{
    NUCShiftExpression *aShiftExpression = nil;
    
    if ([NUCShiftExpression shiftExpressionFrom:aStream into:&aShiftExpression])
    {
        if (aToken)
            *aToken = [NUCRelationalExpression expressionWithShiftExpression:aShiftExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCRelationalExpression *aRelationalExpression = nil;
        
        if ([self relationalExpressionFrom:aStream into:&aRelationalExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aStream next];
            
            if ([anOperator isRelationalOperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                if ([NUCShiftExpression shiftExpressionFrom:aStream into:&aShiftExpression])
                {
                    if (aToken)
                        *aToken = [NUCRelationalExpression expressionWithRelationalExpression:aRelationalExpression relationalOperator:anOperator shiftExpression:aShiftExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
}

+ (instancetype)expressionWithShiftExpression:(NUCShiftExpression *)aShiftExpression
{
    return [[[self alloc] initWithRelationalExpression:nil relationalOperator:nil shiftExpression:aShiftExpression] autorelease];
}

+ (instancetype)expressionWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression
{
    return [[[self alloc] initWithRelationalExpression:aRelationalExpression relationalOperator:aRelationalOperator shiftExpression:aShiftExpression] autorelease];
}

- (instancetype)initWithShiftExpression:(NUCShiftExpression *)aShiftExpression
{
    return [self initWithRelationalExpression:nil relationalOperator:nil shiftExpression:aShiftExpression];
}

- (instancetype)initWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression
{
    if (self = [super initWithType:NUCLexicalElementRelationalExpressionType])
    {
        relationalExpression = [aRelationalExpression retain];
        relationalOperator = [aRelationalOperator retain];
        shiftExpression = [aShiftExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [relationalExpression release];
    [relationalOperator release];
    [shiftExpression release];
    
    [super dealloc];
}

@end
