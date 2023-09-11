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

- (NSInteger)executeWithPreprocessor:(NUCPreprocessor *)aPreprocessor
{
    id aContent = [(NUCConstant *)content content];
    return [aContent isKindOfClass:[NUCIntegerConstant class]] ? [aContent value] : 0;
}

@end
