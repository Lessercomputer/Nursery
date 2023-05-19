//
//  NUCPpTokens.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPpTokens.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCPreprocessingTokenStream.h"

#import <Foundation/NSArray.h>

@implementation NUCPpTokens

+ (BOOL)ppTokensFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPpTokens **)aToken
{
    NUCDecomposedPreprocessingToken *aPpToken = nil;
    NUCPpTokens *aPpTokens = [NUCPpTokens ppTokens];
    
    while ([[aStream peekNext] isNotWhitespace])
    {
        aPpToken = [aStream next];
        [aPpTokens add:aPpToken];
        
        if (aToken)
            *aToken = aPpTokens;
    }
    
    return [aPpTokens count] ? YES : NO;
}

+ (instancetype)ppTokens
{
    return [[[self alloc] initWithType:NUCLexicalElementPpTokensType] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        ppTokens = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

- (void)add:(NUCDecomposedPreprocessingToken *)aPpToken
{
    [[self ppTokens] addObject:aPpToken];
}

- (NSMutableArray *)ppTokens
{
    return ppTokens;
}

- (NSUInteger)count
{
    return [[self ppTokens] count];
}

- (BOOL)isEqual:(id)anOther
{
    if (self == anOther)
        return YES;
    else if (![super isEqual:anOther])
        return NO;
    else
        return [[self ppTokens] isEqual:[anOther ppTokens]];
}

- (BOOL)containsIdentifier:(NUCIdentifier *)anIdentifier
{
    return [[self ppTokens] containsObject:anIdentifier];
}

- (NUCDecomposedPreprocessingToken *)replacementTargetFor:(NUCIdentifier *)anIdentifier
{
    __block NUCDecomposedPreprocessingToken *aFoundToken = nil;
    
    [self enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop) {
        if ([aPpToken isEqual:anIdentifier])
        {
            aFoundToken = aPpToken;
            *aStop = YES;
        }
    }];
    
    return aFoundToken;
}

- (void)enumerateObjectsUsingBlock:(void (^)(NUCDecomposedPreprocessingToken *, NSUInteger, BOOL *))aBlock
{
    [[self ppTokens] enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken   * _Nonnull aPpToken, NSUInteger anIndex, BOOL * _Nonnull aStop) {
        aBlock(aPpToken, anIndex, aStop);
    }];
}

@end
