//
//  NUCPrimaryExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCPrimaryExpression.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCConstant.h"
#import "NUCExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCConstant.h"
#import "NUCIntegerConstant.h"
#import "NUCExpressionResult.h"
#import "NUCToken.h"

@implementation NUCPrimaryExpression


+ (BOOL)primaryExpressionFrom:(NUCTokenStream *)aStream into:(NUCPrimaryExpression **)anExpression
{
    id <NUCToken> aToken = [aStream peekNext];
    NUCConstant *aConstant = nil;
    
    if ([aToken isIdentifier])
    {
        if (anExpression)
            *anExpression = [NUCPrimaryExpression expressionWithIdentifier:aToken];
        
        return YES;
    }
    else if ([NUCConstant constantFrom:aStream into:&aConstant])
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
    else if ([aToken isOpeningParenthesis])
    {
        NSUInteger aPosition = [aStream position];
        [aStream skipWhitespacesWithoutNewline];
        NUCExpression *anExpression2 = nil;
        
        if ([NUCExpression expressionFrom:aStream into:&anExpression2])
        {
            if ([aStream skipWhitespacesWithoutNewline])
            {
                aToken = [aStream next];
                if ([aToken isClosingParenthesis])
                {
                    if (anExpression)
                        *anExpression = [NUCPrimaryExpression expressionWithExpression:anExpression2];
                    
                    return YES;
                }
            }
            else
            {
                [aStream setPosition:aPosition];
            }
        }
    }
    
    return NO;
}

+ (instancetype)expressionWithIdentifier:(id <NUCToken>)anIdentifier
{
    return [[[self alloc] initWithContent:anIdentifier] autorelease];
}

+ (instancetype)expressionWithConstant:(NUCConstant *)aConstant
{
    return [[[self alloc] initWithContent:aConstant] autorelease];
}

+ (instancetype)expressionWithStringLiteral:(id <NUCToken>)aStringLiteral
{
    return [[[self alloc] initWithContent:aStringLiteral] autorelease];
}

+ (instancetype)expressionWithExpression:(NUCExpression *)anExpression
{
    return [[[self alloc] initWithContent:anExpression] autorelease];
}

- (instancetype)initWithContent:(id)aContent
{
    if (self = [super initWithType:NUCExpressionPrimaryExpressionType])
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

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    if ([content isIdentifier])
    {
        return [[[NUCExpressionResult alloc] initWithIntValue:0] autorelease];
    }
    else if ([content isConstant])
    {
        id aContent = [(NUCConstant *)content content];
        int aValue = (int)[aContent value];
        NUCExpressionResult *anExpressionResult = [[[NUCExpressionResult alloc] initWithIntValue:aValue] autorelease];
        
        return anExpressionResult;
    }
    else
        return [(NUCExpression *)content evaluateWith:aPreprocessor];
}

@end
