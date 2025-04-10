//
//  NUCExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCConditionalExpression.h"
#import "NUCTranslationOrderMap.h"

@implementation NUCExpression

+ (BOOL)expressionFrom:(NUCTokenStream *)aStream into:(NUCExpression **)anExpression
{
    NUCConditionalExpression *aConditionalExpression = nil;
    
    if ([NUCConditionalExpression conditionalExpressionFrom:aStream into:&aConditionalExpression])
    {
        if (anExpression)
            *anExpression = [NUCExpression expressionWithConditionalExpression:aConditionalExpression];
        
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
    if (self = [super init])
    {
        conditionalExpression = [aConditionalExpression retain];
    }
    
    return self;
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    return [conditionalExpression evaluateWith:aPreprocessor];
}

- (void)dealloc
{
    [conditionalExpression release];
    
    [super dealloc];
}

- (void)mapTo:(NUCTranslationOrderMap *)aMap parent:(id)aParent depth:(NUUInt64)aDepth
{
    [aMap add:self parent:aParent depth:aDepth];
    [conditionalExpression mapTo:aMap parent:self depth:aDepth + 1];
}

@end
