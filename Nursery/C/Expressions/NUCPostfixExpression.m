//
//  NUCPostfixExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCPostfixExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCPrimaryExpression.h"

@implementation NUCPostfixExpression

+ (BOOL)postfixExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPostfixExpression **)aToken
{
    NUCPrimaryExpression *aPrimaryExpression = nil;
    
    if ([NUCPrimaryExpression primaryExpressionFrom:aStream into:&aPrimaryExpression])
    {
        if (aToken)
            *aToken = [NUCPostfixExpression expressionWithPrimaryExpression:aPrimaryExpression];
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)expressionWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression
{
    return [[[self alloc] initWithPrimaryExpression:aPrimaryExpression] autorelease];
}

- (instancetype)initWithPrimaryExpression:(NUCPrimaryExpression *)aPrimaryExpression
{
    if (self = [super initWithType:NUCLexicalElementPostfixExpressionType])
    {
        primaryExpression = [aPrimaryExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [primaryExpression release];
    
    [super dealloc];
}

@end
