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
#import "NUCPreprocessor.h"
#import "NUCPpTokensWithMacroInvocations.h"
#import "NUCMacroInvocation.h"
#import "NUCGroupPart.h"
#import "NUCTextLine.h"
#import "NUCControlLineDefineFunctionLike.h"
#import "NUCReplacedStringLiteral.h"
#import "NUCConcatenatedPpToken.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSSet.h>

@implementation NUCPpTokens

+ (BOOL)ppTokensFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPpTokens **)aToken
{
    NUCDecomposedPreprocessingToken *aPpToken = nil;
    NUCPpTokens *aPpTokens = nil;
    
    while ([[aStream peekNext] isNotNewLine])
    {
        aPpToken = [aStream next];
        
        if (!aPpTokens)
            aPpTokens = [NUCPpTokens ppTokens];
        
        [aPpTokens add:aPpToken];
    }
    
    if ([aPpTokens count])
    {
        if (aToken)
            *aToken = aPpTokens;
        
        return YES;
    }
    
    return NO;
}

+ (instancetype)ppTokens
{
    return [[[self alloc] initWithType:NUCLexicalElementPpTokensType] autorelease];
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

- (void)add:(NUCPreprocessingToken *)aPpToken
{
    [[self ppTokens] addObject:aPpToken];
}

- (void)addFromArray:(NSArray *)aPpTokens
{
    [[self ppTokens] addObjectsFromArray:aPpTokens];
}

- (NSMutableArray *)ppTokens
{
    if (!ppTokens)
        ppTokens = [NSMutableArray new];
    
    return ppTokens;
}

- (NSUInteger)count
{
    return [[self ppTokens] count];
}

- (NUCPreprocessingToken *)at:(NSUInteger)anIndex
{
    return [[self ppTokens] objectAtIndex:anIndex];
}

- (BOOL)isEqual:(id)anOther
{
    if (self == anOther)
        return YES;
    else
        return [[self ppTokens] isEqual:[anOther ppTokens]];
}

- (BOOL)containsIdentifier:(NUCIdentifier *)anIdentifier
{
    return [[self ppTokens] containsObject:anIdentifier];
}

- (void)enumerateObjectsUsingBlock:(void (^)( NUCPreprocessingToken*, NSUInteger, BOOL *))aBlock
{
    [[self ppTokens] enumerateObjectsUsingBlock:^(NUCPreprocessingToken * _Nonnull aPpToken, NSUInteger anIndex, BOOL * _Nonnull aStop) {
        aBlock(aPpToken, anIndex, aStop);
    }];
}

- (void)enumerateObjectsUsingBlock:(void (^)(NUCPreprocessingToken *, NSUInteger, BOOL *))aBlock skipWhitespaces:(BOOL)aSkipWhitespaces
{
    [[self ppTokens] enumerateObjectsUsingBlock:^(NUCPreprocessingToken * _Nonnull aPpToken, NSUInteger anIndex, BOOL * _Nonnull aStop) {
        if ([aPpToken isKindOfClass:[NUCDecomposedPreprocessingToken class]] && ![(NUCDecomposedPreprocessingToken *)aPpToken isWhitespace])
            aBlock(aPpToken, anIndex, aStop);
    }];
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromPpTokens:(NUCPpTokens *)aPpTokens with:(NUCPreprocessor *)aPreprocessor
{
    return [self ppTokensWithMacroInvocationsFrom:[aPpTokens ppTokens] with:aPreprocessor];
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFromTextLines:(NSArray *)aTextLines with:(NUCPreprocessor *)aPreprocessor
{
    NUCPpTokens *aPpTokensWithMacroInvocations = nil;
    NSMutableArray *aPpTokensInTextLines = [NSMutableArray array];
    
    [aTextLines enumerateObjectsUsingBlock:^(NUCGroupPart * _Nonnull aGroupPart, NSUInteger idx, BOOL * _Nonnull stop) {
        NUCTextLine *aTextLine = (NUCTextLine *)[aGroupPart content];
        [aPpTokensInTextLines addObjectsFromArray:[[aTextLine ppTokens] ppTokens]];
    }];
    
    aPpTokensWithMacroInvocations = [self ppTokensWithMacroInvocationsFrom:aPpTokensInTextLines with:aPreprocessor];
    
    return aPpTokensWithMacroInvocations;
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFrom:(NSArray *)aPpTokens with:(NUCPreprocessor *)aPreprocessor
{
    NUCPpTokens *aPpTokensWithMacroInvocations = [NUCPpTokensWithMacroInvocations ppTokens];
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];

        if ([aPpToken isIdentifier])
            [aPpTokensWithMacroInvocations add:[[NUCMacroInvocation class] identifierOrMacroInvocation:(NUCIdentifier *)aPpToken from:aPpTokenStream with:aPreprocessor parentMacroInvocation:nil replacingMacroNames:nil]];
        else
            [aPpTokensWithMacroInvocations add:aPpToken];
    }
    
    return aPpTokensWithMacroInvocations;
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFrom:(NSArray *)aPpTokens of:(NUCMacroInvocation *)aMacroInvocation with:(NUCPreprocessor *)aPreprocessor replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    if ([[aMacroInvocation define] isObjectLike])
        return [self ppTokensWithMacroInvocationsFrom:aPpTokens ofObjectLike:aMacroInvocation with:aPreprocessor replacingMacroNames:aReplacingMacroNames];
    else
        return [self ppTokensWithMacroInvocationsFrom:aPpTokens ofFunctionLike:aMacroInvocation with:aPreprocessor replacingMacroNames:aReplacingMacroNames];
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFrom:(NSArray *)aPpTokens ofObjectLike:(NUCMacroInvocation *)aMacroInvocation with:(NUCPreprocessor *)aPreprocessor replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NUCPpTokens *aPpTokensWithMacroInvocations = [NUCPpTokensWithMacroInvocations ppTokens];
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    while ([aPpTokenStream hasNext])
    {
        NSMutableArray *aPastingTokens = [self scanPastingTokensInObjectLikeMacroFrom:aPpTokenStream];
        
        if ([aPastingTokens count])
            [aPpTokensWithMacroInvocations add:[self concatenatePastingTokens:aPastingTokens]];
        else
        {
            NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];

            if ([aPpToken isIdentifier])
                [aPpTokensWithMacroInvocations add:[[NUCMacroInvocation class] identifierOrMacroInvocation:(NUCIdentifier *)aPpToken from:aPpTokenStream with:aPreprocessor parentMacroInvocation:aMacroInvocation replacingMacroNames:aReplacingMacroNames]];
            else
                [aPpTokensWithMacroInvocations add:aPpToken];
        }
    }
    
    return aPpTokensWithMacroInvocations;
}

+ (NUCConcatenatedPpToken *)concatenatePastingTokens:(NSMutableArray *)aPastingTokens
{
    NUCConcatenatedPpToken *aConcatenatedPpToken = [NUCConcatenatedPpToken concatenatedPpTokenWithLeft:[aPastingTokens objectAtIndex:0] right:[aPastingTokens objectAtIndex:1]];

    for (NSUInteger anIndex = 2; anIndex < [aPastingTokens count]; anIndex++)
        aConcatenatedPpToken = [NUCConcatenatedPpToken concatenatedPpTokenWithLeft:aConcatenatedPpToken right:[aPastingTokens objectAtIndex:anIndex]];
    
    return aConcatenatedPpToken;
}

+ (NSMutableArray *)scanPastingTokensInObjectLikeMacroFrom:(NUCPreprocessingTokenStream *)aPpTokenStream
{
    NSMutableArray *aPastingTokens = [NSMutableArray array];
    NSUInteger aPosition = [aPpTokenStream position];
    
    NUCDecomposedPreprocessingToken *aPrecededPpToken = [aPpTokenStream next];
    
    if ([aPrecededPpToken isNotWhitespace])
    {
        while ([aPpTokenStream hasNext])
        {
            aPosition = [aPpTokenStream position];
            
            [aPpTokenStream skipWhitespaces];
            
            if ([[aPpTokenStream peekNext] isHashHash])
            {
                [aPpTokenStream next];
                [aPpTokenStream skipWhitespaces];
                
                if (aPrecededPpToken)
                {
                    [aPastingTokens addObject:aPrecededPpToken];
                    aPrecededPpToken = nil;
                }
                
                NUCDecomposedPreprocessingToken *aFollowingPpToken = [aPpTokenStream next];
                
                if (aFollowingPpToken)
                    [aPastingTokens addObject:aFollowingPpToken];
            }
            else
            {
                [aPpTokenStream setPosition:aPosition];
                break;
            }
        }
    }
    
    if (![aPastingTokens count])
        [aPpTokenStream setPosition:aPosition];
    
    return aPastingTokens;
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFrom:(NSArray *)aPpTokens ofFunctionLike:(NUCMacroInvocation *)aMacroInvocation with:(NUCPreprocessor *)aPreprocessor replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NUCPpTokens *aPpTokensWithMacroInvocations = [NUCPpTokensWithMacroInvocations ppTokens];
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isHash])
        {
            NUCControlLineDefineFunctionLike *aMacroDefine = (NUCControlLineDefineFunctionLike *)[aMacroInvocation define];
            
            NSMutableArray *aPpTokens = [NSMutableArray array];
            aPpToken = [aPpTokenStream next];
            
            [aPpTokens addObjectsFromArray:[aPpTokenStream scanWhiteSpaces]];
            [aPpTokens addObjectsFromArray:[aMacroInvocation argumentAt:[aMacroDefine parameterIndexOf:(NUCIdentifier *)aPpToken]]];
            
            [aPpTokensWithMacroInvocations add:[NUCReplacedStringLiteral replacedStringLiteralWithPpTokens:aPpTokens]];
        }
        else if ([aPpToken isNotWhitespace])
        {
            NSUInteger aPosition = [aPpTokenStream position];
            [aPpTokenStream skipWhitespaces];
            
            if ([[aPpTokenStream peekNext] isHashHash])
            {
                [aPpTokenStream next];
                [aPpTokenStream skipWhitespaces];
                NUCDecomposedPreprocessingToken *aFolowingPpToken = [aPpTokenStream next];
                
                NUCConcatenatedPpToken *aConcatenatedPpToken = [NUCConcatenatedPpToken concatenatedPpTokenWithLeft:aPpToken right:aFolowingPpToken];
                [aPpTokensWithMacroInvocations add:aConcatenatedPpToken];
            }
            else
            {
                [aPpTokenStream setPosition:aPosition];
                
                if ([aPpToken isIdentifier])
                {
                    NUCIdentifier *anIdentifier = (NUCIdentifier *)aPpToken;
                    NUCControlLineDefineFunctionLike *aDefine = (NUCControlLineDefineFunctionLike *)[aMacroInvocation define];
                    if ([aDefine identifierIsParameter:anIdentifier])
                        [aPpTokensWithMacroInvocations addFromArray:[aMacroInvocation argumentAt:[aDefine parameterIndexOf:anIdentifier]]];
                    else
                        [aPpTokensWithMacroInvocations add:aPpToken];
                }
                else
                    [aPpTokensWithMacroInvocations add:aPpToken];
            }
        }
        else
            [aPpTokensWithMacroInvocations add:aPpToken];
    }

    return aPpTokensWithMacroInvocations;
}

- (NSMutableArray *)replaceMacrosWith:(NUCPreprocessor *)aPreprocessor
{
    if (![self isPpTokensWithMacroInvocations])
        return [self ppTokens];
    else
    {
        NSMutableArray *aMacroReplacedPpTokens = [NSMutableArray array];
        
        [self enumerateObjectsUsingBlock:^(NUCPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop) {
            
            if ([aPpToken isMacroInvocation])
            {
                NUCMacroInvocation *aMacroInvocation = (NUCMacroInvocation *)aPpToken;
                [aMacroInvocation addExpandedPpTokensTo:aMacroReplacedPpTokens With:aPreprocessor];
            }
            else
                [aMacroReplacedPpTokens addObject:aPpToken];
        }];

        return aMacroReplacedPpTokens;
    }
}

@end
