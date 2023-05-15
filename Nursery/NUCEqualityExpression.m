//
//  NUCEqualityExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/17.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCEqualityExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCRelationalExpression.h"

@implementation NUCEqualityExpression

+ (BOOL)equalityExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCEqualityExpression **)aToken
{
    NUCRelationalExpression *aRelationalExpression = nil;
    
    if ([NUCRelationalExpression relationalExpressionFrom:aStream into:&aRelationalExpression])
    {
        if (aToken)
            *aToken = [NUCEqualityExpression expressionWithRelationalExpression:aRelationalExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        NUCEqualityExpression *anEqualityExpression = nil;
        
        if ([self equalityExpressionFrom:aStream into:&anEqualityExpression])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aStream next];
            
            if ([anOperator isEqualityOperator] || [anOperator isInequalityOperator])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                if ([NUCRelationalExpression relationalExpressionFrom:aStream into:&aRelationalExpression])
                {
                    if (aToken)
                        *aToken = [NUCEqualityExpression expressionWithEqualityExpression:anEqualityExpression equalityOperator:anOperator relationalExpression:aRelationalExpression];
                    
                    return YES;
                }
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
}

+ (instancetype)expressionWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression
{
    return [[[self alloc] initWithRelationalExpression:aRelationalExpression] autorelease];
}

+ (instancetype)expressionWithEqualityExpression:(NUCEqualityExpression *)anEqualityExpression equalityOperator:(NUCDecomposedPreprocessingToken *)anOperator relationalExpression:(NUCRelationalExpression *)aRelationalExpression
{
    return [[[self alloc] initWithEqualityExpression:anEqualityExpression equalityOperator:anOperator relationalExpression:aRelationalExpression] autorelease];
}

- (instancetype)initWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression
{
    return [self initWithEqualityExpression:nil equalityOperator:nil relationalExpression:aRelationalExpression];
}

- (instancetype)initWithEqualityExpression:(NUCEqualityExpression *)anEqualityExpression equalityOperator:(NUCDecomposedPreprocessingToken *)anOperator relationalExpression:(NUCRelationalExpression *)aRelationalExpression
{
    if (self = [super initWithType:NUCLexicalElementEqualityExpressionType])
    {
        relationalExpression = [aRelationalExpression retain];
        equalityExpression = [anEqualityExpression retain];
        equalityOperator = [anOperator retain];
    }
    
    return self;
}

- (void)dealloc
{
    [relationalExpression release];
    [equalityExpression release];
    [equalityOperator release];
    
    [super dealloc];
}

@end
