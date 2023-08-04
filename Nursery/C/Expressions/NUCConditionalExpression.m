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

@implementation NUCConditionalExpression

+ (BOOL)conditionalExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCConditionalExpression **)aToken
{
    NUCLogicalORExpression *aLogicalOrExpression = nil;
    if ([NUCLogicalORExpression logicalORExpressionFrom:aStream into:&aLogicalOrExpression])
    {
        NSUInteger aPosition = [aStream position];
        [aStream skipWhitespacesWithoutNewline];
        
        NUCDecomposedPreprocessingToken *aQuestionMark = [aStream next];
        if ([aQuestionMark isQuestionMark])
        {
            [aStream skipWhitespacesWithoutNewline];
            
            NUCExpression *anExpression = nil;
            if ([NUCExpression expressionFrom:aStream into:&anExpression])
            {
                [aStream skipWhitespacesWithoutNewline];
                
                NUCDecomposedPreprocessingToken *aColon = [aStream next];
                if ([aColon isColon])
                {
                    [aStream skipWhitespacesWithoutNewline];
                    
                    NUCConditionalExpression *aConditionalExpression = nil;
                    if ([self conditionalExpressionFrom:aStream into:&aConditionalExpression])
                    {
                        if (aToken)
                            *aToken = [NUCConditionalExpression expressionWithLogicalORExpression:aLogicalOrExpression questionMarkPunctuator:aQuestionMark expression:anExpression colonPunctuator:aColon conditionalExpression:aConditionalExpression];
                        
                        return YES;
                    }
                }
            }
        }
        else
        {
            [aStream setPosition:aPosition];
            
            if (aToken)
                *aToken = [NUCConditionalExpression expressionWithLogicalORExpression:aLogicalOrExpression];
            
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

+ (instancetype)expressionWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression questionMarkPunctuator:(NUCDecomposedPreprocessingToken *)aQuestionMarkPunctuator expression:(NUCExpression *)anExpression colonPunctuator:(NUCDecomposedPreprocessingToken *)aColonPunctuator conditionalExpression:(NUCConditionalExpression *)aConditionalExpression
{
    return [[[self alloc] initWithLogicalORExpression:aLogicalORExpression questionMarkPunctuator:aQuestionMarkPunctuator expression:anExpression colonPunctuator:aColonPunctuator conditionalExpression:aConditionalExpression] autorelease];
}

- (instancetype)initWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression questionMarkPunctuator:(NUCDecomposedPreprocessingToken *)aQuestionMarkPunctuator expression:(NUCExpression *)anExpression colonPunctuator:(NUCDecomposedPreprocessingToken *)aColonPunctuator conditionalExpression:(NUCConditionalExpression *)aConditionalExpression
{
    if ([self initWithType:NUCLexicalElementConditionalExpressionType])
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

- (NUCDecomposedPreprocessingToken *)questionMarkPunctuator
{
    return questionMarkPunctuator;
}

- (NUCExpression *)expression
{
    return expression;
}

- (NUCDecomposedPreprocessingToken *)colonPunctuator
{
    return colonPunctuator;
}

- (NUCConditionalExpression *)conditionalExpression
{
    return conditionalExpression;
}

- (void)executeWith:(NUCPreprocessor *)aPreprocessor
{
    
}

@end
