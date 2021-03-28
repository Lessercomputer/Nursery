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

@implementation NUCPrimaryExpression

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
