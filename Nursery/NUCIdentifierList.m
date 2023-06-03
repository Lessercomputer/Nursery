//
//  NUCIdentifierList.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCIdentifierList.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"

#import <Foundation/NSArray.h>

@implementation NUCIdentifierList

+ (BOOL)identifierListFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCIdentifierList **)aToken
{
    NUCDecomposedPreprocessingToken *aPreprocessingToken = nil;
    NUCIdentifierList *anIdentifierList = [NUCIdentifierList identifierList];
    
    do
    {
        [aStream skipWhitespacesWithoutNewline];
        aPreprocessingToken = [aStream peekNext];
        
        if ([aPreprocessingToken isIdentifier])
            [anIdentifierList add:[aStream next]];
        else if ([aPreprocessingToken isComma])
            [aStream next];
        
        [aStream skipWhitespacesWithoutNewline];
        aPreprocessingToken = [aStream peekNext];
    }
    while ([aPreprocessingToken isComma] || [aPreprocessingToken isIdentifier]);
    
    if ([anIdentifierList count])
    {
        if (aToken)
            *aToken = anIdentifierList;
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)identifierList
{
    return [[[self alloc] initWithType:NUCLexicalElementIdentifierListType] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        identifiers = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [identifiers release];
    
    [super dealloc];
}

- (void)add:(NUCLexicalElement *)anIdentifier
{
    [[self identifiers] addObject:anIdentifier];
}

- (NSMutableArray *)identifiers
{
    return identifiers;
}

- (NSUInteger)count
{
    return [[self identifiers] count];
}

@end
