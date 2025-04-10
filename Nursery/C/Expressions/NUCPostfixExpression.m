//
//  NUCPostfixExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCPostfixExpression.h"
#import "NUCPrimaryExpression.h"
#import "NUCTranslationOrderMap.h"

@implementation NUCPostfixExpression

+ (BOOL)postfixExpressionFrom:(NUCTokenStream *)aStream into:(NUCPostfixExpression **)aToken
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
    if (self = [super initWithType:NUCExpressionPostfixExpressionType])
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

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    return [primaryExpression evaluateWith:aPreprocessor];
}

- (void)mapTo:(NUCTranslationOrderMap *)aMap parent:(id)aParent depth:(NUUInt64)aDepth
{
    [aMap add:self parent:aParent depth:aDepth];
    [primaryExpression mapTo:aMap parent:self depth:aDepth + 1];
}

@end
