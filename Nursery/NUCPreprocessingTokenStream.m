//
//  NUCPreprocessingTokenStream.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/01/29.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingTokenStream.h"

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

- (NUCPreprocessingToken *)next
{
    NUCPreprocessingToken *aToken = nil;
    
    if ([self hasNext])
    {
        aToken = [[self preprocessingTokens] objectAtIndex:position++];
    }
    
    return aToken;
}

- (NSUInteger)position
{
    return [self position];
}

- (void)storePosition
{
    storedPosition = [self position];
}

- (void)restorePosition
{
    position = storedPosition;
}

- (BOOL)hasNext
{
    return [self position] < [[self preprocessingTokens] count];
}

- (NSArray *)preprocessingTokens
{
    return preprocessingTokens;
}

@end
