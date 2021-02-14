//
//  NUCConditionalExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCConditionalExpression.h"

@implementation NUCConditionalExpression

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

@end
