//
//  NUCConcatenatedPpToken.m
//  Nursery
//
//  Created by aki on 2023/06/09.
//

#import "NUCConcatenatedPpToken.h"
#import "NUCPreprocessingTokenDecomposer.h"
#import <Foundation/NSString.h>

@implementation NUCConcatenatedPpToken

+ (instancetype)concatenatedPpTokenWithPpTokens:(NSArray *)aPpTokens
{
    return [[[self alloc] initWithPpTokens:aPpTokens] autorelease];
}

- (instancetype)initWithPpTokens:(NSArray *)aPpTokens
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

- (NSArray *)ppTokens
{
    return ppTokens;
}

- (NSString *)string
{
    NSMutableString *aString = [NSMutableString string];
    [self addStringTo:aString];
    
    return aString;
}

- (void)addStringTo:(NSMutableString *)aString
{
    [[self ppTokens] enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken * _Nonnull aPpToken, NSUInteger anIndex, BOOL * _Nonnull aStop) {
        [aPpToken addStringForConcatinationTo:aString];
    }];
}

- (NUCPreprocessingToken *)concatenatedPpToken
{
    if (!concatenatedPpTokens)
        concatenatedPpTokens = [[[[NUCPreprocessingTokenDecomposer new] autorelease] decomposePreprocessingTokensIn:[self string]] retain];
    
    if ([concatenatedPpTokens count] == 1)
        return [concatenatedPpTokens firstObject];
    else
        return nil;
}

- (BOOL)isConcatenatedToken
{
    return YES;
}

- (BOOL)isValid
{
    return [self concatenatedPpToken] ? YES : NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> token: %@", [self class], self, [self string]];
}

@end
