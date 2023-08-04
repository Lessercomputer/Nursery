//
//  NUCExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCConditionalExpression.h"

@implementation NUCExpression

+ (BOOL)expressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCExpression **)aToken
{
    NUCConditionalExpression *aConditionalExpression = nil;
    
    if ([NUCConditionalExpression conditionalExpressionFrom:aStream into:&aConditionalExpression])
    {
        if (aToken)
            *aToken = [NUCExpression expressionWithConditionalExpression:aConditionalExpression];
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)expressionWithConditionalExpression:(NUCConditionalExpression *)aConditionalExpression
{
    return [[[self alloc] initWithConditionalExpression:aConditionalExpression] autorelease];
}

- (instancetype)initWithConditionalExpression:(NUCConditionalExpression *)aConditionalExpression
{
    if (self = [super initWithType:NUCLexicalElementExpressionType])
    {
        conditionalExpression = [aConditionalExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [conditionalExpression release];
    
    [super dealloc];
}

@end
