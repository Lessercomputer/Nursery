//
//  NUCMacroArgument.m
//  Nursery
//
//  Created by aki on 2023/08/04.
//

#import "NUCMacroArgument.h"

#import <Foundation/NSArray.h>

@implementation NUCMacroArgument

+ (instancetype)argument
{
    return [[self new] autorelease];
}

- (instancetype)init
{
    return [self initWithType:NUCLexicalElementNone];
}

- (void)dealloc
{
    [argument release];
    
    [super dealloc];
}

- (void)add:(NUCPreprocessingToken *)aPpToken
{
    [[self argument] addObject:aPpToken];
}

- (NSMutableArray *)argument
{
    if (!argument)
        argument = [NSMutableArray new];
    return argument;
}

- (BOOL)isPlacemaker
{
    __block BOOL anIsPlacemaker = YES;
    
    [[self argument] enumerateObjectsUsingBlock:^(NUCPreprocessingToken * _Nonnull aPpToken, NSUInteger anIndex, BOOL * _Nonnull aStop) {
        if ([aPpToken isNotWhitespace])
        {
            anIsPlacemaker = NO;
            *aStop = YES;
        }
    }];
    
    return anIsPlacemaker;
}

- (BOOL)isMacroArgument
{
    return YES;
}

- (NSArray *)ppTokensByTrimingWhitespaces
{
    return [self trimWhitspaces:[self argument]];
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

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces
{
    __block NUCPreprocessingToken *aPpTokenToReturn = nil;
    
    [[self argument] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NUCPreprocessingToken * _Nonnull aPpToken, NSUInteger anINdex, BOOL * _Nonnull aStop) {
        if ([aPpToken isNotWhitespace])
        {
            aPpTokenToReturn = aPpToken;
            *aStop = YES;
        }
    }];
    
    return aPpTokenToReturn;
}

@end
