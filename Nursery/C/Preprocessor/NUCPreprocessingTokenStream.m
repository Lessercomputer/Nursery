//
//  NUCPreprocessingTokenStream.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/01/29.
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
        aToken = [[self preprocessingTokens] objectAtIndex:position++];
    
    return aToken;
}

- (NUCDecomposedPreprocessingToken *)previous
{
    NUCDecomposedPreprocessingToken *aToken = nil;
    
    if ([self hasPrevious])
        aToken = [[self preprocessingTokens] objectAtIndex:--position];
    
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

- (BOOL)hasPrevious
{
    return [self position]  != 0;
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

- (NSArray *)scanWhiteSpaces
{
    NSMutableArray *aPpTokens = nil;
    
    while ([[self peekNext] isWhitespace])
    {
        if (!aPpTokens)
            aPpTokens = [NSMutableArray array];
        [aPpTokens addObject:[self next]];
    }
    
    return aPpTokens;
}

- (NUCDecomposedPreprocessingToken *)peekNext
{
    return [self hasNext] ? [[self preprocessingTokens] objectAtIndex:[self position]] : nil;
}

- (NUCDecomposedPreprocessingToken *)peekPrevious
{
    NSUInteger aPosition = [self position];
    NSArray *aTokens = [self preprocessingTokens];
    
    return aPosition > 0 && aPosition <= [aTokens count] ? [aTokens objectAtIndex:aPosition - 1] : nil;
}

- (BOOL)nextIsWhitespaces
{
    return [[self peekNext] isWhitespace] ? YES : NO;
}

- (BOOL)nextIsWhitespacesWithoutNewline
{
    return [[self peekNext] isWhitespacesWithoutNewline] ? YES : NO;
}

@end
