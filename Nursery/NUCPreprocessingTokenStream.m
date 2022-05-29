//
//  NUCPreprocessingTokenStream.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/01/29.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"

#import <Foundation/NSArray.h>

@implementation NUCPreprocessingTokenStream

+ (instancetype)preprecessingTokenStreamWithPreprocessingTokens:(NSArray *)aPreprocessingTokens
{
    return [[[self alloc] initWithPreprocessingTokens:aPreprocessingTokens] autorelease];
}

- (instancetype)initWithPreprocessingTokens:(NSArray *)aPreprocessingTokens
{
    if (self = [super init])
    {
        preprocessingTokens = [aPreprocessingTokens copy];
    }
    
    return self;
}

- (void)dealloc
{
    [preprocessingTokens release];
    
    [super dealloc];
}

- (NUCDecomposedPreprocessingToken *)next
{
    NUCDecomposedPreprocessingToken *aToken = nil;
    
    if ([self hasNext])
    {
        aToken = [[self preprocessingTokens] objectAtIndex:position++];
    }
    
    return aToken;
}

- (NSUInteger)position
{
    return position;
}

- (void)setPosition:(NSUInteger)aPosition
{
    position = aPosition;
}

- (BOOL)hasNext
{
    return [self position] < [[self preprocessingTokens] count];
}

- (NSArray *)preprocessingTokens
{
    return preprocessingTokens;
}

- (BOOL)skipWhitespaces
{
    NSUInteger aPosition = [self position];
    
    while ([[self peekNext] isWhitespace])
        [self next];
    
    return [self position] != aPosition;
}

- (BOOL)skipWhitespacesWithoutNewline
{
    NSUInteger aPosition = [self position];
    
    while ([[self peekNext] isWhitespacesWithoutNewline])
        [self next];
    
    return [self position] != aPosition;
}

- (NUCDecomposedPreprocessingToken *)peekNext
{
    return [self hasNext] ? [[self preprocessingTokens] objectAtIndex:[self position]] : nil;
}

@end
