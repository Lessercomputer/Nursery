//
//  NUCPrimaryExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPrimaryExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCConstant.h"
#import "NUCExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCConstant.h"

@implementation NUCPrimaryExpression

+ (BOOL)primaryExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPrimaryExpression **)anExpression
{
    NUCDecomposedPreprocessingToken *aToken = [aStream next];
    NUCConstant *aConstant = nil;
    
    if ([aToken isIdentifier])
    {
        if (anExpression)
            *anExpression = [NUCPrimaryExpression expressionWithIdentifier:aToken];
        
        return YES;
    }
    else if ([NUCConstant constantFrom:aToken into:&aConstant])
    {
        if (anExpression)
            *anExpression = [NUCPrimaryExpression expressionWithConstant:aConstant];
        
        return YES;
    }
    else if ([aToken isStringLiteral])
    {
        if (anExpression)
            *anExpression = [NUCPrimaryExpression expressionWithStringLiteral:aToken];
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)expressionWithIdentifier:(NUCDecomposedPreprocessingToken *)anIdentifier
{
    return [[[self alloc] initWithToken:anIdentifier] autorelease];
}

+ (instancetype)expressionWithConstant:(NUCConstant *)aConstant
{
    return [[[self alloc] initWithToken:aConstant] autorelease];
}

+ (instancetype)expressionWithStringLiteral:(NUCDecomposedPreprocessingToken *)aStringLiteral
{
    return [[[self alloc] initWithToken:aStringLiteral] autorelease];
}

+ (instancetype)expressionWithExpression:(NUCExpression *)anExpression
{
    return [[[self alloc] initWithToken:anExpression] autorelease];
}

- (instancetype)initWithToken:(NUCPreprocessingToken *)aContent
{
    if (self = [super initWithType:NUCLexicalElementPrimaryExpressionType])
    {
        content = [aContent retain];
    }
    
    return self;
}

- (void)dealloc
{
    [content release];
    
    [super dealloc];
}

@end
