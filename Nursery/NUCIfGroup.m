//
//  NUCIfGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCIfGroup.h"

@implementation NUCIfGroup

+ (instancetype)ifGroupWithType:(NUCLexicalElementType)aType hash:(NUCPreprocessingToken *)aHash expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    return [[[self alloc] initWithType:aType hash:aHash expressionOrIdentifier:anExpressionOrIdentifier newline:aNewline group:aGroup] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCPreprocessingToken *)aHash expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    if (self = [super initWithType:aType])
    {
        hash = [aHash retain];
        expressionOrIdentifier = [anExpressionOrIdentifier retain];
        newline = [aNewline retain];
        group = [aGroup retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
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

- (NUCPreprocessingToken *)hash
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

@end
