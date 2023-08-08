//
//  NUCConcatenatedPpToken.m
//  Nursery
//
//  Created by aki on 2023/06/09.
//

#import "NUCConcatenatedPpToken.h"
#import "NUCDecomposer.h"
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
    NSArray *aTokens = [[[NUCDecomposer new] autorelease] decomposePreprocessingTokensIn:[self string]];
    if ([aTokens count] == 1)
        return [aTokens firstObject];
    else
        return nil;
}

- (BOOL)isValid
{
    return [self concatenatedPpToken] ? YES : NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> token: %@", self, self, [self string]];
}

@end
