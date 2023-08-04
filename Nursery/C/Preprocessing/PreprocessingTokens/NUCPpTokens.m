//
//  NUCPpTokens.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
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
#import "NUCSubstitutedStringLiteral.h"
#import "NUCConcatenatedPpToken.h"
#import "NUCMacroArgument.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSString.h>

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
    if (aPpTokens)
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

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces
{
    __block NUCDecomposedPreprocessingToken *aPpTokenToReturn = nil;
    
    [[self ppTokens] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NUCDecomposedPreprocessingToken * _Nonnull aPpToken, NSUInteger anINdex, BOOL * _Nonnull aStop) {
        if ([aPpToken isNotWhitespace])
        {
            aPpTokenToReturn = aPpToken;
            *aStop = YES;
        }
    }];
    
    if ([aPpTokenToReturn isMacroInvocation])
        return [(NUCMacroInvocation *)aPpTokenToReturn lastPpTokenWithoutWhitespaces];
    else
        return aPpTokenToReturn;
}

- (NUCMacroInvocation *)lastMacroInvocationWithoutWhitespaces
{
    __block NUCDecomposedPreprocessingToken *aPpTokenToReturn = nil;
    
    [[self ppTokens] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NUCDecomposedPreprocessingToken * _Nonnull aPpToken, NSUInteger anINdex, BOOL * _Nonnull aStop) {
        if ([aPpToken isNotWhitespace])
        {
            aPpTokenToReturn = aPpToken;
            *aStop = YES;
        }
    }];
    
    if ([aPpTokenToReturn isMacroInvocation])
    {
        NUCMacroInvocation *aMacroInvocationOrNil = [(NUCMacroInvocation *)aPpTokenToReturn lastMacroInvocationWithoutWhitespaces];
        if (aMacroInvocationOrNil)
            return [aMacroInvocationOrNil lastMacroInvocationWithoutWhitespaces];
    }
    
    return nil;
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
    return [self ppTokensWithMacroInvocationsFrom:aPpTokens of:nil with:aPreprocessor replacingMacroNames:nil];
}

+ (NUCPpTokens *)ppTokensWithMacroInvocationsFrom:(NSArray *)aPpTokens of:(NUCMacroInvocation *)aMacroInvocation with:(NUCPreprocessor *)aPreprocessor replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NUCPpTokens *aPpTokensForMacroInvocation = [NUCPpTokensWithMacroInvocations ppTokens];
    NUCPreprocessingTokenStream *aPpTokenStream = nil;
    
    if (!aMacroInvocation)
        aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    else if ([[aMacroInvocation define] isObjectLike])
        aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:[self applyHashOrHashHashOpelatorInReplacementList:aPpTokens forMacroInvocation:aMacroInvocation]];
    else
        aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:[self applyOpelatorAndSubstituteParametersInReplacementList:aPpTokens forMacroInvocation:aMacroInvocation]];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];

        if ([aPpToken isIdentifier])
        {
            NUCPreprocessingToken *anIdentifierOrMacroInvocation = [[NUCMacroInvocation class] identifierOrMacroInvocation:(NUCIdentifier *)aPpToken from:aPpTokenStream with:aPreprocessor parentMacroInvocation:aMacroInvocation replacingMacroNames:aReplacingMacroNames];
            [aPpTokensForMacroInvocation add:anIdentifierOrMacroInvocation];
        }
        else if ([aPpToken isWhitespace])
        {
            NSArray *aWhitespaces = [aPpTokenStream scanWhiteSpaces];
                            
            if (![[aPpTokenStream peekNext] isOpeningParenthesis])
            {
                [aPpTokensForMacroInvocation add:aPpToken];
                [aPpTokensForMacroInvocation addFromArray:aWhitespaces];
            }
        }
        else if ([aPpToken isOpeningParenthesis])
        {
            NUCMacroInvocation *aMacroInvocationOrNil = [aPpTokensForMacroInvocation lastMacroInvocationWithoutWhitespaces];
            if (aMacroInvocationOrNil)
            {
                id aLastPpTokenWithoutWhitespaceInMacroInvocation = [aMacroInvocationOrNil lastPpTokenWithoutWhitespaces];
                if ([aLastPpTokenWithoutWhitespaceInMacroInvocation isIdentifier])
                {
                    [aPpTokenStream previous];
                    
                    NUCPreprocessingToken *anIdentifierOrMacroInvocation = [[NUCMacroInvocation class] identifierOrMacroInvocation:(NUCIdentifier *)aLastPpTokenWithoutWhitespaceInMacroInvocation from:aPpTokenStream with:aPreprocessor parentMacroInvocation:aMacroInvocation replacingMacroNames:aReplacingMacroNames];
                    
                    if ([anIdentifierOrMacroInvocation isMacroInvocation])
                        [aMacroInvocationOrNil setOverlappedMacroInvocation:(NUCMacroInvocation *)anIdentifierOrMacroInvocation];
                    else
                    {
                        [aPpTokenStream next];
                        [aPpTokensForMacroInvocation add:aPpToken];
                    }
                }
                else
                    [aPpTokensForMacroInvocation add:aPpToken];
            }
            else
                [aPpTokensForMacroInvocation add:aPpToken];
        }
        else
            [aPpTokensForMacroInvocation add:aPpToken];
    }
    
    return aPpTokensForMacroInvocation;
}

+ (NSMutableArray *)applyOpelatorAndSubstituteParametersInReplacementList:(NSArray *)aReplacementList forMacroInvocation:(NUCMacroInvocation *)aMacroInvocation
{
    return [self substituteParametersInOperatorAppliedReplacementList:[self applyHashOrHashHashOpelatorInReplacementList:aReplacementList forMacroInvocation:aMacroInvocation] forMacroInvocation:aMacroInvocation];
}

+ (NSMutableArray *)applyHashOrHashHashOpelatorInReplacementList:(NSArray *)aReplacementList forMacroInvocation:(NUCMacroInvocation *)aMacroInvocation
{
    NSMutableArray *aHashHashOperatorAppliedPpTokens = [NSMutableArray array];
    NUCPreprocessingTokenStream *aPpTokenStream = nil;
    NUCControlLineDefine *aMacroDefine = [aMacroInvocation define];
    
    if ([aMacroDefine isFunctionLike])
    {
        NSMutableArray *aHashOperatorAppliedPpTokens = [NSMutableArray array];
        aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aReplacementList];
        
        while ([aPpTokenStream hasNext])
        {
            NUCSubstitutedStringLiteral *aSubstitutedStringLiteral = [self substitutedStringInFunctionLikeMacro:aMacroInvocation from:aPpTokenStream];
            
            if (aSubstitutedStringLiteral)
                [aHashOperatorAppliedPpTokens addObject:aSubstitutedStringLiteral];
            else
                [aHashOperatorAppliedPpTokens addObject:[aPpTokenStream next]];
        }
        
        aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aHashOperatorAppliedPpTokens];
    }
    else
        aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aReplacementList];

    while ([aPpTokenStream hasNext])
    {
        NUCConcatenatedPpToken *aConcatenatedPpToken = [self concatenatedPpTokenInMacro:aMacroInvocation from:aPpTokenStream];

        if (aConcatenatedPpToken)
            [aHashHashOperatorAppliedPpTokens addObject:aConcatenatedPpToken];
        else
            [aHashHashOperatorAppliedPpTokens addObject:[aPpTokenStream next]];
    }
    
    return aHashHashOperatorAppliedPpTokens;
}

+ (NSMutableArray *)substituteParametersInOperatorAppliedReplacementList:(NSArray *)anOperatorAppliedReplacementList forMacroInvocation:(NUCMacroInvocation *)aMacroInvocation
{
    NSMutableArray *aSubstitutedReplacementList = [NSMutableArray array];
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:anOperatorAppliedReplacementList];
    NUCControlLineDefineFunctionLike *aFunctionLikeDefine = (NUCControlLineDefineFunctionLike *)[aMacroInvocation define];
    
    while ([aPpTokenStream hasNext])
    {
        NUCPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
        {
            NUCIdentifier *anIdentifier = (NUCIdentifier *)aPpToken;
            if ([aFunctionLikeDefine identifierIsParameter:anIdentifier])
                [aSubstitutedReplacementList addObjectsFromArray:[[aMacroInvocation argumentAt:[aFunctionLikeDefine parameterIndexOf:anIdentifier]] argument]];
            else
                [aSubstitutedReplacementList addObject:aPpToken];
        }
        else
            [aSubstitutedReplacementList addObject:aPpToken];
    }
    
    return aSubstitutedReplacementList;
}

+ (NUCConcatenatedPpToken *)concatenatePastingTokens:(NSMutableArray *)aPastingTokens
{
    NUCConcatenatedPpToken *aConcatenatedPpToken = [NUCConcatenatedPpToken concatenatedPpTokenWithLeft:[aPastingTokens objectAtIndex:0] right:[aPastingTokens objectAtIndex:1]];

    for (NSUInteger anIndex = 2; anIndex < [aPastingTokens count]; anIndex++)
        aConcatenatedPpToken = [NUCConcatenatedPpToken concatenatedPpTokenWithLeft:aConcatenatedPpToken right:[aPastingTokens objectAtIndex:anIndex]];
        
    return aConcatenatedPpToken;
}

+ (NUCSubstitutedStringLiteral *)substitutedStringInFunctionLikeMacro:(NUCMacroInvocation *)aMacroInvocation from:(NUCPreprocessingTokenStream *)aPpTokenStream
{
    NUCSubstitutedStringLiteral *aSubstitutedStringLiteral = nil;
    NUCControlLineDefineFunctionLike *aFunctionLikeMacroDefine = (NUCControlLineDefineFunctionLike *)[aMacroInvocation define];
    NSUInteger aPosition = [aPpTokenStream position];
    NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
    
    if ([aPpToken isHash])
    {
        [aPpTokenStream skipWhitespaces];
        aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
        {
            NUCMacroArgument *anArgument = [aMacroInvocation argumentAt:[aFunctionLikeMacroDefine parameterIndexOf:(NUCIdentifier *)aPpToken]];
            aSubstitutedStringLiteral = [NUCSubstitutedStringLiteral substitutedStringLiteralWithMacroArgument:anArgument];
        }
        else
            [aPpTokenStream setPosition:aPosition];
    }
    else
        [aPpTokenStream setPosition:aPosition];
    
    return aSubstitutedStringLiteral;
}

+ (NUCConcatenatedPpToken *)concatenatedPpTokenInMacro:(NUCMacroInvocation *)aMacroInvocation from:(NUCPreprocessingTokenStream *)aReplacementListPpTokenStream
{
    NSMutableArray *aPastingTokens = [self scanPastingTokensInMacro:aMacroInvocation from:aReplacementListPpTokenStream];
    NUCConcatenatedPpToken *aConcatenetedPpToken = nil;
    
    if ([aPastingTokens count])
    {
        aConcatenetedPpToken = [self concatenatePastingTokens:aPastingTokens];
        
        if ([aConcatenetedPpToken isValid])
        {
            
        }
    }
    
    return aConcatenetedPpToken;
}

+ (NSMutableArray *)scanPastingTokensInMacro:(NUCMacroInvocation *)aMacroInvocation from:(NUCPreprocessingTokenStream *)aReplacementListPpTokenStream
{
    NSMutableArray *aPastingTokens = [NSMutableArray array];
    NSUInteger aPosition = [aReplacementListPpTokenStream position];
    
    NUCDecomposedPreprocessingToken *aPrecededPpToken = [aReplacementListPpTokenStream next];
    
    if ([aPrecededPpToken isNotWhitespace])
    {
        while ([aReplacementListPpTokenStream hasNext])
        {
            NSUInteger aPosition2 = [aReplacementListPpTokenStream position];
            
            [aReplacementListPpTokenStream skipWhitespaces];
            
            if ([[aReplacementListPpTokenStream peekNext] isHashHash])
            {
                [aReplacementListPpTokenStream next];
                [aReplacementListPpTokenStream skipWhitespaces];
                
                if (aPrecededPpToken)
                {
                    [aPastingTokens addObject:aPrecededPpToken];
                    aPrecededPpToken = nil;
                }
                
                NUCDecomposedPreprocessingToken *aFollowingPpToken = [aReplacementListPpTokenStream next];
                
                if (aFollowingPpToken)
                    [aPastingTokens addObject:aFollowingPpToken];
            }
            else
            {
                [aReplacementListPpTokenStream setPosition:aPosition2];
                break;
            }
        }
    }
    
    if (![aPastingTokens count])
        [aReplacementListPpTokenStream setPosition:aPosition];
    
    return aPastingTokens;
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
