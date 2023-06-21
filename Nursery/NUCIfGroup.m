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
#import "NUCPreprocessor.h"
#import "NUCPpTokens.h"

#import <Foundation/NSString.h>

@implementation NUCIfGroup

+ (BOOL)ifGroupFrom:(NUCPreprocessingTokenStream *)aStream  with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCIfGroup **)anIfGroup
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
            NUCLexicalElementType anIfGroupType = [self lexicalElementTypeForDirectiveName:anIfGroupTypeString];
            NUCDecomposedPreprocessingToken *aTypeName = aToken;
            NUCLexicalElement *anExpressionOrIdentifier = nil;
            NUCNewline *aNewline = nil;
            
            if (!aGroupIsSkipped)
            {
                if (anIfGroupType == NUCLexicalElementIfType)
                {
                    [aStream skipWhitespaces];
                    
                    id aPpTokens = nil;
                    [self readPpTokensUntilNewlineFrom:aStream into:&aPpTokens];
                    
                    id aPpTokensWithMacroInvocations = [aPreprocessor ppTokensWithMacroInvocationsByInstantiateMacroInvocationsIn:aPpTokens];
                    NUCPpTokens *aMacroExecutedPpTokens = [aPreprocessor executeMacrosInPpTokens:aPpTokensWithMacroInvocations];
                    NUCPreprocessingTokenStream *aMacroExecutedStream = [[[NUCPreprocessingTokenStream alloc] initWithPreprocessingTokens:[aMacroExecutedPpTokens ppTokens]] autorelease];
                    
                    [NUCConstantExpression constantExpressionFrom:aStream into:&anExpressionOrIdentifier];
                }
                else if (anIfGroupType == NUCLexicalElementIfdefType
                    || anIfGroupType == NUCLexicalElementIfndefType)
                {
                    [aStream skipWhitespaces];
                    anExpressionOrIdentifier = [aStream next];
                }
            }
            else
                [self readPpTokensUntilNewlineFrom:aStream into:&anExpressionOrIdentifier];
            
            
            if (aHash && anExpressionOrIdentifier && [NUCNewline newlineFrom:aStream into:&aNewline])
            {
                NUCGroup *aGroup = nil;
                [NUCGroup groupFrom:aStream with:aPreprocessor isSkipped:aGroupIsSkipped into:&aGroup];
                
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

+ (NUCLexicalElementType)lexicalElementTypeForDirectiveName:(NSString *)aName
{
    NUCLexicalElementType anIfGroupType = NUCLexicalElementNone;
    
    if ([aName isEqualToString:NUCPreprocessingDirectiveIf])
        anIfGroupType = NUCLexicalElementIfType;
    else if ([aName isEqualToString:NUCPreprocessingDirectiveIfdef])
        anIfGroupType = NUCLexicalElementIfdefType;
    else if ([aName isEqualToString:NUCPreprocessingDirectiveIfndef])
        anIfGroupType = NUCLexicalElementIfndefType;
    
    return anIfGroupType;
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

- (void)executeWith:(NUCPreprocessor *)aPreprocessor
{
    if ([self isIf])
    {
        [(NUCConstantExpression *)[self expression] executeWith:aPreprocessor];
    }
    else if ([self isIfdef])
    {

    }
    else if ([self isIfndef])
    {

    }
}

@end
