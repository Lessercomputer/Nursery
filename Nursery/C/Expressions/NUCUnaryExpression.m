//
//  NUCUnaryExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCUnaryExpression.h"
#import "NUCCastExpression.h"
#import "NUCPostfixExpression.h"
#import "NUCExpressionResult.h"
#import "NUCToken.h"
#import "NUCTokenStream.h"
#import "NUCTranslationOrderMap.h"

@implementation NUCUnaryExpression

+ (BOOL)unaryExpressionFrom:(NUCTokenStream *)aStream into:(NUCUnaryExpression **)aToken
{
    NUCPostfixExpression *aPostfixExpression = nil;
    
    if ([NUCPostfixExpression postfixExpressionFrom:aStream into:&aPostfixExpression])
    {
        if (aToken)
            *aToken = [NUCUnaryExpression expressionWithPostfixExpression:aPostfixExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aStream position];
        id <NUCToken> anUnaryOperator = [aStream next];
        
        if ([anUnaryOperator isUnaryOperator])
        {
            NUCCastExpression *aCastExpression = nil;
            
            if ([NUCCastExpression castExpressionFrom:aStream into:&aCastExpression])
            {
                if (aToken)
                    *aToken = [NUCUnaryExpression expressionWithUnaryOperator:anUnaryOperator castExpression:aCastExpression];
                
                return YES;
            }
        }
        
        [aStream setPosition:aPosition];
        
        return NO;
    }
    
    return NO;
}

+ (instancetype)expressionWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression
{
    return [[[self alloc] initWithPostfixExpression:aPostfixExpression] autorelease];
}

+ (instancetype)expressionWithUnaryOperator:(id <NUCToken>)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression
{
    return [[[self alloc] initWithUnaryOperator:anUnaryOperator unaryExpression:anUnaryExpression] autorelease];
}

+ (instancetype)expressionWithUnaryOperator:(id <NUCToken>)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression
{
    return [[[self alloc] initWithUnaryOperator:anUnaryOperator castExpression:aCastExpression] autorelease];
}

- (instancetype)initWithPostfixExpression:(NUCPostfixExpression *)aPostfixExpression
{
    if (self = [super initWithType:NUCExpressionUnaryExpressionType])
    {
        postfixExpression = [aPostfixExpression retain];
    }
    
    return self;
}

- (instancetype)initWithUnaryOperator:(id <NUCToken>)anUnaryOperator unaryExpression:(NUCUnaryExpression *)anUnaryExpression
{
    if (self = [super initWithType:NUCExpressionUnaryExpressionType])
    {
        unaryOperator = [anUnaryOperator retain];
        unaryExpression = [anUnaryExpression retain];
    }
    
    return self;
}

- (instancetype)initWithUnaryOperator:(id <NUCToken>)anUnaryOperator castExpression:(NUCCastExpression *)aCastExpression
{
    if (self = [super initWithType:NUCExpressionUnaryExpressionType])
    {
        unaryOperator = [anUnaryOperator retain];
        castExpression = [aCastExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [postfixExpression release];
    [unaryOperator release];
    [unaryExpression release];
    [castExpression release];
    
    [super dealloc];
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    if (unaryOperator)
    {
        NUCExpressionResult *aCastExpressionResult = [castExpression evaluateWith:aPreprocessor];
        int aValue = 0;
        
        if ([unaryOperator isUnaryPlusOperator])
            aValue = +[aCastExpressionResult intValue];
        else if ([unaryOperator isUnaryMinusOperator])
            aValue = -[aCastExpressionResult intValue];
        else if ([unaryOperator isBitwiseComplementOperator])
             aValue = ~[aCastExpressionResult intValue];
        else if ([unaryOperator isLogicalNegationOperator])
             aValue = ![aCastExpressionResult intValue];
        
        return [NUCExpressionResult expressionResultWithIntValue:aValue];
    }
    else
        return [postfixExpression evaluateWith:aPreprocessor];
}

- (void)mapTo:(NUCTranslationOrderMap *)aMap parent:(id)aParent depth:(NUUInt64)aDepth
{
    [aMap add:self parent:aParent depth:aDepth];
    
    if (postfixExpression)
        [postfixExpression mapTo:aMap parent:self depth:aDepth + 1];
}

@end
