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

@implementation NUCPrimaryExpression


+ (BOOL)primaryExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPrimaryExpression **)anExpression
{
    NUCDecomposedPreprocessingToken *aToken = [aStream peekNext];
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
                if (anExpression)
                    *anExpression = [NUCPrimaryExpression expressionWithExpression:anExpression2];
                
                return YES;
            }
            else
            {
                [aStream setPosition:aPosition];
            }
        }
    }
    
    return NO;
}

+ (instancetype)expressionWithIdentifier:(NUCDecomposedPreprocessingToken *)anIdentifier
{
    return [[[self alloc] initWithContent:anIdentifier] autorelease];
}

+ (instancetype)expressionWithConstant:(NUCConstant *)aConstant
{
    return [[[self alloc] initWithContent:aConstant] autorelease];
}

+ (instancetype)expressionWithStringLiteral:(NUCDecomposedPreprocessingToken *)aStringLiteral
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
    id aContent = [(NUCConstant *)content content];
    int aValue = [aContent isKindOfClass:[NUCIntegerConstant class]] ? (int)[aContent value] : 0;
    NUCExpressionResult *anExpressionResult = [[[NUCExpressionResult alloc] initWithIntValue:aValue] autorelease];
    
    return anExpressionResult;
}

@end
