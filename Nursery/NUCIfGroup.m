//
//  NUCIfGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCIfGroup.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCNewline.h"
#import "NUCGroup.h"
#import "NUCConstantExpression.h"

#import <Foundation/NSString.h>

@implementation NUCIfGroup

+ (BOOL)ifGroupFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCIfGroup **)anIfGroup
{
    NSUInteger aPosition = [aStream position];
    [aStream skipWhitespaces];
    NUCDecomposedPreprocessingToken *aToken = [aStream next];
    
    if (aToken && [aToken isHash])
    {
        NUCDecomposedPreprocessingToken *aHash = aToken;
        [aStream skipWhitespacesWithoutNewline];
        aToken = [aStream next];
        
        if (aToken)
        {
            NSString *anIfGroupTypeString = [aToken content];
            NUCLexicalElementType anIfGroupType = NUCLexicalElementNone;
            NUCDecomposedPreprocessingToken *aTypeName = aToken;
            NUCLexicalElement *anExpressionOrIdentifier = nil;
            NUCNewline *aNewline = nil;
            
            if ([anIfGroupTypeString isEqualToString:NUCPreprocessingDirectiveIf])
            {
                anIfGroupType = NUCLexicalElementIfType;
                
                [aStream skipWhitespaces];
                [NUCConstantExpression constantExpressionFrom:aStream into:&anExpressionOrIdentifier];
            }
            else if ([anIfGroupTypeString isEqualToString:NUCPreprocessingDirectiveIfdef])
            {
                anIfGroupType = NUCLexicalElementIfdefType;
                
                [aStream skipWhitespaces];
                anExpressionOrIdentifier = [aStream next];
            }
            else if ([anIfGroupTypeString isEqualToString:NUCPreprocessingDirectiveIfndef])
            {
                anIfGroupType = NUCLexicalElementIfndefType;
                
                [aStream skipWhitespaces];
                anExpressionOrIdentifier = [aStream next];
            }
            
            if (aHash && anExpressionOrIdentifier && [NUCNewline newlineFrom:aStream into:&aNewline])
            {
                NUCGroup *aGroup = nil;
                [NUCGroup groupFrom:aStream into:&aGroup];
                
                if (anIfGroup)
                    *anIfGroup = [NUCIfGroup ifGroupWithType:anIfGroupType hash:aHash
                                                    directiveName:aTypeName expressionOrIdentifier:anExpressionOrIdentifier newline:aNewline group:aGroup];
                
                return YES;
            }
        }
    }

    [aStream setPosition:aPosition];
    
    return NO;
}

+ (instancetype)ifGroupWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aName expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    return [[[self alloc] initWithType:aType hash:aHash directiveName:aName expressionOrIdentifier:anExpressionOrIdentifier newline:aNewline group:aGroup] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aName expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    if (self = [super initWithType:aType])
    {
        hash = [aHash retain];
        directiveName = [aName retain];
        expressionOrIdentifier = [anExpressionOrIdentifier retain];
        newline = [aNewline retain];
        group = [aGroup retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    [directiveName release];
    [expressionOrIdentifier release];
    [newline release];
    [group release];
    
    [super dealloc];
}

- (BOOL)isIf
{
    return [self type] == NUCLexicalElementIfType;
}

- (BOOL)isElif
{
    return [self type] == NUCLexicalElementElifGroup;
}

- (BOOL)isIfdef
{
    return [self type] == NUCLexicalElementIfdefType;
}

- (BOOL)isIfndef
{
    return [self type] == NUCLexicalElementIfndefType;
}

- (NUCDecomposedPreprocessingToken *)hash
{
    return hash;
}

- (NUCLexicalElement *)expression
{
    return [self isIf] || [self isElif] ? expressionOrIdentifier : nil;
}

- (NUCLexicalElement *)identifier
{
    return ![self isIf] ? expressionOrIdentifier : nil;
}

- (NUCPreprocessingDirective *)newline
{
    return newline;
}

- (NUCGroup *)group
{
    return group;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    if ([self isIf])
    {
        [(NUCConstantExpression *)[self expression] preprocessWith:aPreprocessor];
    }
    else if ([self isIfdef])
    {

    }
    else if ([self isIfndef])
    {

    }
}

@end
