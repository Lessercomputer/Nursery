//
//  NUCMacroInvocation.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/07.
//

#import "NUCMacroInvocation.h"
#import "NUCControlLineDefine.h"
#import "NUCPreprocessor.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCConcatenatedPpToken.h"
#import "NUCPpTokens.h"
#import "NUCPpTokensWithMacroInvocations.h"
#import "NUCIdentifier.h"
#import "NUCControlLineDefineFunctionLike.h"
#import "NUCReplacementList.h"
#import "NUCSubstitutedStringLiteral.h"
#import "NUCMacroArgument.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSString.h>

@implementation NUCMacroInvocation

+ (instancetype)macroInvocationWithDefine:(NUCControlLineDefine *)aDefine
{
    return [[[self alloc] initWithDefine:aDefine] autorelease];
}

+ (NUCPreprocessingToken *)identifierOrMacroInvocation:(NUCIdentifier *)anIdentifier from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor parentMacroInvocation:(NUCMacroInvocation *)aParentMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    if ([aReplacingMacroNames containsObject:anIdentifier])
        return anIdentifier;
    
    NUCControlLineDefine *aMacroDefineToInvoke = [aPreprocessor macroDefineFor:anIdentifier];
    
    if (!aMacroDefineToInvoke)
        return anIdentifier;
    else
    {
        NUCMacroInvocation *aMacroInvocation = [NUCMacroInvocation macroInvocationWithDefine:aMacroDefineToInvoke];
        
        if ([aMacroDefineToInvoke isFunctionLike])
        {
            NSUInteger aPosition = [aPpTokenStream position];
            [aMacroInvocation setWhitespacesFollowingMacroName:[aPpTokenStream scanWhiteSpaces]];
            NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
            
            if ([aPpToken isOpeningParenthesis])
            {
                [aMacroInvocation setOpeningParenthesis:aPpToken];
                [aMacroInvocation setArguments:[self macroInvocationArgumentsOf:aMacroInvocation from:aPpTokenStream with:aPreprocessor parentMacroInvocation:aParentMacroInvocation replacingMacroNames:aReplacingMacroNames]];
                
                if ([[aPpTokenStream peekPrevious] isClosingParenthesis])
                    [aMacroInvocation setClosingParenthesis:aPpToken];
                else
                    return nil;
            }
            else
            {
                [aPpTokenStream setPosition:aPosition];
                return anIdentifier;
            }
        }
        
        if (!aReplacingMacroNames)
            aReplacingMacroNames = [NSMutableSet set];
        
        [aReplacingMacroNames addObject:[aMacroDefineToInvoke identifier]];
        
        NUCPpTokens *aPpTokens = [[aMacroDefineToInvoke replacementList] ppTokens];
        NUCPpTokens *aPpTokensWithMacroInvocations = [[NUCPpTokens class] ppTokensWithMacroInvocationsFrom:[aPpTokens ppTokens] of:aMacroInvocation with:aPreprocessor replacingMacroNames:aReplacingMacroNames];
        [aMacroInvocation setPpTokensWithMacroinvocations:(NUCPpTokensWithMacroInvocations *)aPpTokensWithMacroInvocations];
        
        [aReplacingMacroNames removeObject:[aMacroDefineToInvoke identifier]];
        
        return aMacroInvocation;
    }
}

+ (NSMutableArray *)macroInvocationArgumentsOf:(NUCMacroInvocation *)aMacroInvocation from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor parentMacroInvocation:(NUCMacroInvocation *)aParentMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NSMutableArray *anArguments = [NSMutableArray array];
    
    while ([aPpTokenStream hasNext] && (![anArguments count] || [[aPpTokenStream peekNext] isComma]))
    {
        NUCMacroArgument *anArgument = [self macroInvocationArgumentAt:[anArguments count] of:aMacroInvocation from:aPpTokenStream with:aPreprocessor parentMacroInvocation:aParentMacroInvocation replacingMacroNames:aReplacingMacroNames];
        if (anArgument)
            [anArguments addObject:anArgument];
        else
            break;
    }
    
    return anArguments;
}

+ (NUCMacroArgument *)macroInvocationArgumentAt:(NSUInteger)anIndex of:(NUCMacroInvocation *)aMacroinvocation from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor parentMacroInvocation:(NUCMacroInvocation *)aParentMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NUCMacroArgument *anArgument = [NUCMacroArgument argument];
    NSInteger anOpeningParenthesisCount = 1;
    NUCControlLineDefineFunctionLike *aDefine = (NUCControlLineDefineFunctionLike *)[aMacroinvocation define];
    BOOL aCurrentArgumentIsVaArgs = [aDefine ellipsis] && anIndex >= [aDefine parameterCount];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isOpeningParenthesis])
        {
            [anArgument add:aPpToken];
            anOpeningParenthesisCount++;
        }
        else if ([aPpToken isClosingParenthesis])
        {
            anOpeningParenthesisCount--;
            if (anOpeningParenthesisCount == 0)
                break;
            else
                [anArgument add:aPpToken];
        }
        else if ([aPpToken isIdentifier])
        {
            if ([(NUCControlLineDefineFunctionLike *)[aMacroinvocation define] parameterIsHashOperatorOperandAt:anIndex])
                [anArgument add:aPpToken];
            else
                [anArgument add:[self identifierOrMacroInvocation:(NUCIdentifier *)aPpToken from:aPpTokenStream with:aPreprocessor parentMacroInvocation:aParentMacroInvocation replacingMacroNames:aReplacingMacroNames]];
        }
        else if ([aPpToken isWhitespace])
        {
            [aPpTokenStream skipWhitespaces];
            [anArgument add:[NUCDecomposedPreprocessingToken whitespace]];
        }
        else if ([aPpToken isComma])
        {
            if (aCurrentArgumentIsVaArgs)
                [anArgument add:aPpToken];
            else
            {
                if (anIndex != 0 && ![anArgument precededComma])
                    [anArgument setPrecededComma:aPpToken];
                else if (anOpeningParenthesisCount == 1)
                {
                    [aPpTokenStream previous];
                    break;
                }
            }
        }
        else
            [anArgument add:aPpToken];
    }
    
    return anArgument;
}

- (instancetype)init
{
    return [self initWithDefine:nil];
}

- (instancetype)initWithDefine:(NUCControlLineDefine *)aDefine
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        define = aDefine;
        arguments = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [whitespacesFollowingMacroName release];
    [openingParenthesis release];
    [closingParenthesis release];
    [arguments release];
    [ppTokensWithMacroinvocations release];
    
    [super dealloc];
}

- (NUCControlLineDefine *)define
{
    return define;
}

- (void)setDefine:(NUCControlLineDefine *)aDefine
{
    define = aDefine;
}

- (BOOL)isObjectLike
{
    return [[self define] isObjectLike];
}

- (BOOL)isFunctionLike
{
    return [[self define] isFunctionLike];
}

- (NSMutableArray *)arguments
{
    return arguments;
}

- (void)setArguments:(NSMutableArray *)anArguments
{
    [[self arguments] setArray:anArguments];
}

- (NUCMacroArgument *)vaArgs
{
    if (![[self define] isFunctionLike])
        return nil;
    
    NUCControlLineDefineFunctionLike *aDefine = (NUCControlLineDefineFunctionLike *)[self define];
    
    if ([aDefine ellipsis])
        return [[self arguments] lastObject];
    else
        return nil;
}

- (NUCMacroArgument *)argumentAt:(NSUInteger)anIndex
{
    return [[self arguments] objectAtIndex:anIndex];
}

- (NUCMacroArgument *)argumentFor:(NUCIdentifier *)aParameterIdentifier
{
    NUCControlLineDefineFunctionLike *aFunctionLikeDefine = [[self define] isFunctionLike] ? (NUCControlLineDefineFunctionLike *)[self define] : nil;
    
    if (aFunctionLikeDefine)
        return [self argumentAt:[aFunctionLikeDefine parameterIndexOf:aParameterIdentifier]];
    
    return nil;
}

- (void)addArgument:(NUCMacroArgument *)anArgument
{
    [[self arguments] addObject:anArgument];
}

- (NUCPpTokensWithMacroInvocations *)ppTokensWithMacroinvocations
{
    return ppTokensWithMacroinvocations;
}

- (void)setPpTokensWithMacroinvocations:(NUCPpTokensWithMacroInvocations *)aPpTokens
{
    [ppTokensWithMacroinvocations release];
    ppTokensWithMacroinvocations = [aPpTokens retain];
}

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces
{
    return [[self ppTokensWithMacroinvocations] lastPpTokenWithoutWhitespaces];
}

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespacesIndexInto:(NSUInteger *)anIndex
{
    NSUInteger aLastPpTokenIndexWithoutWhitespaces = [[self ppTokensWithMacroinvocations] lastPpTokenIndexWithoutWhitespaces];
    if (aLastPpTokenIndexWithoutWhitespaces == NSUIntegerMax)
        return nil;
    else
    {
        if (*anIndex)
            *anIndex = aLastPpTokenIndexWithoutWhitespaces;
        return [[self ppTokensWithMacroinvocations] at:aLastPpTokenIndexWithoutWhitespaces];
    }
}

- (NUCMacroInvocation *)lastMacroInvocation
{
    NUCMacroInvocation *aMacroInvocation = [[self ppTokensWithMacroinvocations] lastMacroInvocation];
    if (aMacroInvocation)
        return aMacroInvocation;
    else
        return self;
}

- (BOOL)isMacroInvocation
{
    return YES;
}

- (BOOL)isNotWhitespace
{
    return YES;
}

- (NSMutableArray *)expandedPpTokens
{
    NSMutableArray *anExpandedPpTokens = [NSMutableArray array];
    
    [self addExpandedPpTokensTo:anExpandedPpTokens With:nil];
    
    return anExpandedPpTokens;
}

- (void)addUnexpandedPpTokensTo:(NSMutableArray *)aPpTokens
{
    [aPpTokens addObject:[[self define] identifier]];
    
    if ([self isFunctionLike])
    {
        if ([self whitespacesFollowingMacroName])
            [aPpTokens addObjectsFromArray:[self whitespacesFollowingMacroName]];
        
        [aPpTokens addObject:[self openingParenthesis]];
        
        [[self arguments] enumerateObjectsUsingBlock:^(NUCMacroArgument * _Nonnull anArgument, NSUInteger idx, BOOL * _Nonnull stop) {
            [anArgument addUnexpandedPpTokensTo:aPpTokens];
        }];
        
        [aPpTokens addObject:[self closingParenthesis]];
    }
}

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens
{
    [self addExpandedPpTokensTo:aPpTokens With:nil];
}

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens With:(NUCPreprocessor *)aPreprocessor
{
    NSUInteger anOverlappedMacroNameIndex = [[self ppTokensWithMacroinvocations] overlappedMacroNameIndex];
    
    [[self ppTokensWithMacroinvocations] enumerateObjectsUsingBlock:^(NUCPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop) {
        
        if ([aPpToken isMacroInvocation])
            [(NUCMacroInvocation *)aPpToken addExpandedPpTokensTo:aPpTokens With:aPreprocessor];
        else if (anIndex != anOverlappedMacroNameIndex)
            [aPpToken addExpandedPpTokensTo:aPpTokens];
    }];
}

- (NSString *)stringForSubstitution
{
    return [[[self define] identifier] string];
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@", name:%@", [[[self define] identifier] string]];
}

- (NUCDecomposedPreprocessingToken *)closingParenthesis
{
    return closingParenthesis;
}

- (NUCDecomposedPreprocessingToken *)openingParenthesis
{
    return openingParenthesis;
}

- (void)setClosingParenthesis:(NUCDecomposedPreprocessingToken *)aClosingParenthesis
{
    [closingParenthesis autorelease];
    closingParenthesis = [aClosingParenthesis retain];
}

- (void)setOpeningParenthesis:(NUCDecomposedPreprocessingToken *)anOpeningParenthesis
{
    [openingParenthesis autorelease];
    openingParenthesis = [anOpeningParenthesis retain];
}

- (void)setWhitespacesFollowingMacroName:(NSArray *)aWhitespaces
{
    [whitespacesFollowingMacroName autorelease];
    whitespacesFollowingMacroName = [aWhitespaces retain];
}

- (NSArray *)whitespacesFollowingMacroName
{
    return whitespacesFollowingMacroName;
}

@end
