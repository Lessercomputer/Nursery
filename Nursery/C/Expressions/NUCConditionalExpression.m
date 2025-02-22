//
//  NUCConditionalExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCConditionalExpression.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCLogicalORExpression.h"
#import "NUCExpression.h"
#import "NUCExpressionResult.h"

@implementation NUCConditionalExpression

+ (BOOL)conditionalExpressionFrom:(NUCTokenStream *)aStream into:(NUCConditionalExpression **)aConditionalExpression
{
    NUCLogicalORExpression *aLogicalOrExpression = nil;
    if ([NUCLogicalORExpression expressionInto:&aLogicalOrExpression from:aStream])
    {
        NSUInteger aPosition = [aStream position];
        [aStream skipWhitespacesWithoutNewline];
        
        id <NUCToken> aQuestionMark = [aStream next];
        if ([aQuestionMark isQuestionMark])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCExpression *anExpression = nil;
            if ([NUCExpression expressionFrom:aStream into:&anExpression])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                id <NUCToken> aColon = [aStream next];
                if ([aColon isColon])
                {
                    [aStream skipWhitespacesWithoutNewline];
                    
                    NUCConditionalExpression *aConditionalExpression2 = nil;
                    if ([self conditionalExpressionFrom:aStream into:&aConditionalExpression2])
                    {
                        if (aConditionalExpression)
                            *aConditionalExpression = [NUCConditionalExpression expressionWithLogicalORExpression:aLogicalOrExpression questionMarkPunctuator:aQuestionMark expression:anExpression colonPunctuator:aColon conditionalExpression:aConditionalExpression2];
                        
                        return YES;
                    }
                }
            }
        }
        else
        {
            [aStream setPosition:aPosition];
            
            if (aConditionalExpression)
                *aConditionalExpression = [NUCConditionalExpression expressionWithLogicalORExpression:aLogicalOrExpression];
            
            return YES;
        }
        
        [aStream setPosition:aPosition];
    }

    return NO;
}

+ (instancetype)expressionWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression
{
    return [self expressionWithLogicalORExpression:aLogicalORExpression questionMarkPunctuator:nil expression:nil colonPunctuator:nil conditionalExpression:nil];
}

+ (instancetype)expressionWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression questionMarkPunctuator:(id <NUCToken>)aQuestionMarkPunctuator expression:(NUCExpression *)anExpression colonPunctuator:(id <NUCToken>)aColonPunctuator conditionalExpression:(NUCConditionalExpression *)aConditionalExpression
{
    return [[[self alloc] initWithLogicalORExpression:aLogicalORExpression questionMarkPunctuator:aQuestionMarkPunctuator expression:anExpression colonPunctuator:aColonPunctuator conditionalExpression:aConditionalExpression] autorelease];
}

- (instancetype)initWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression questionMarkPunctuator:(id <NUCToken>)aQuestionMarkPunctuator expression:(NUCExpression *)anExpression colonPunctuator:(id <NUCToken>)aColonPunctuator conditionalExpression:(NUCConditionalExpression *)aConditionalExpression
{
    if ([self initWithType:NUCExpressionConditionalExpressionType])
    {
        logicalORExpression = [aLogicalORExpression retain];
        questionMarkPunctuator = [aQuestionMarkPunctuator retain];
        expression = [anExpression retain];
        colonPunctuator = [aColonPunctuator retain];
        conditionalExpression = [aConditionalExpression retain];
    }
    
    return self;
}

- (void)dealloc
{
    [logicalORExpression release];
    [questionMarkPunctuator release];
    [expression release];
    [colonPunctuator release];
    [conditionalExpression release];
    
    [super dealloc];
}

- (NUCLogicalORExpression *)logicalORExpression
{
    return logicalORExpression;
}

- (id <NUCToken>)questionMarkPunctuator
{
    return questionMarkPunctuator;
}

- (NUCExpression *)expression
{
    return expression;
}

- (id <NUCToken>)colonPunctuator
{
    return colonPunctuator;
}

- (NUCConditionalExpression *)conditionalExpression
{
    return conditionalExpression;
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    NUCExpressionResult *anExpressionResult = [[self logicalORExpression] evaluateWith:aPreprocessor];
    
    if ([self questionMarkPunctuator])
    {
        if ([anExpressionResult intValue])
            return [[self expression] evaluateWith:aPreprocessor];
        else
            return [[self conditionalExpression] evaluateWith:aPreprocessor];
    }
    else
        return anExpressionResult;
}

@end
