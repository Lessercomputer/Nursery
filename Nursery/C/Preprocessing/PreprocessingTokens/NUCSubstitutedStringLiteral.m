//
//  NUCSubstitutedStringLiteral.m
//  Nursery
//
//  Created by aki on 2023/07/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCSubstitutedStringLiteral.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <Foundation/NSCharacterSet.h>

@implementation NUCSubstitutedStringLiteral

+ (instancetype)substitutedStringLiteralWithPpTokens:(NSMutableArray *)aPpTokens
{
    return [[[self alloc] initWithPpTokens:aPpTokens] autorelease];
}

- (instancetype)initWithPpTokens:(NSMutableArray *)aPpTokens
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        ppTokens = [aPpTokens retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

- (NSMutableArray *)ppTokens
{
    if (!ppTokens)
        ppTokens = [NSMutableArray new];
    
    return ppTokens;
}

- (NSString *)string
{
    if (!string)
        string = [[self getString] retain];
    
    return string;
}

- (NSString *)getString
{
    NSArray *aPpTokens = [self trimWhitspaces:[self ppTokens]];

    if (![aPpTokens count])
        return @"";
    
    NSMutableString *aString = [NSMutableString string];
    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    while ([aStream hasNext])
    {
        if ([[aStream peekNext] isWhitespace])
        {
            [aString appendString:NUCSpace];
            [aStream skipWhitespaces];
        }
        else
            [aString appendString:[[aStream next] string]];
    }
    
    return aString;
}

- (NSArray *)trimWhitspaces:(NSArray *)aPpTokens
{
    if (![aPpTokens count])
        return nil;
    
    NSUInteger aStartIndex = 0, aStopIndex = [aPpTokens count] - 1;
    
    while (aStartIndex < [aPpTokens count])
    {
        if ([[aPpTokens objectAtIndex:aStartIndex] isWhitespace])
            aStartIndex++;
        else
            break;
    }

    while (aStopIndex != NSNotFound && aStopIndex >= 0)
    {
        if ([[aPpTokens objectAtIndex:aStopIndex] isWhitespace])
            aStopIndex = aStopIndex == 0 ? NSNotFound : aStopIndex - 1;
        else
            break;
    }
    
    if (aStartIndex < [aPpTokens count] && aStopIndex != NSNotFound)
        return [aPpTokens subarrayWithRange:NSMakeRange(aStartIndex, aStartIndex - aStopIndex + 1)];
    else
        return nil;
}


@end
