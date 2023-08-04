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
            [aPpTokenStream skipWhitespaces];
            NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
            
            if ([aPpToken isOpeningParenthesis])
            {
                [aMacroInvocation setArguments:[self macroInvocationArgumentsOf:aMacroInvocation from:aPpTokenStream with:aPreprocessor parentMacroInvocation:aParentMacroInvocation replacingMacroNames:aReplacingMacroNames]];
                
                if (![[aPpTokenStream peekPrevious] isClosingParenthesis])
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
        [aMacroInvocation setPpTokensWithMacroinvocations:aPpTokensWithMacroInvocations];
        
        [aReplacingMacroNames removeObject:[aMacroDefineToInvoke identifier]];
        
        return aMacroInvocation;
    }
}

+ (NSMutableArray *)macroInvocationArgumentsOf:(NUCMacroInvocation *)aMacroInvocation from:(NUCPreprocessingTokenStream *)aPpTokenStream with:(NUCPreprocessor *)aPreprocessor parentMacroInvocation:(NUCMacroInvocation *)aParentMacroInvocation replacingMacroNames:(NSMutableSet *)aReplacingMacroNames
{
    NSMutableArray *anArguments = [NSMutableArray array];
    
    while ([aPpTokenStream hasNext] && ![[aPpTokenStream peekPrevious] isClosingParenthesis])
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
    NSInteger anOpeningParenthesisCount = 0;
    NUCControlLineDefineFunctionLike *aDefine = (NUCControlLineDefineFunctionLike *)[aMacroinvocation define];
    BOOL aCurrentArgumentIsVaArgs = [aDefine ellipsis] && anIndex >= [aDefine parameterCount];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
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
        else
        {
            if ([aPpToken isComma])
            {
                if (anOpeningParenthesisCount == 0)
                {
                    if (aCurrentArgumentIsVaArgs)
                        [anArgument add:aPpToken];
                    else
                        break;
                }
            }
            else if ([aPpToken isOpeningParenthesis])
            {
                [anArgument add:aPpToken];
                anOpeningParenthesisCount++;
            }
            else if ([aPpToken isClosingParenthesis])
            {
                if (anOpeningParenthesisCount == 0)
                    break;
                
                [anArgument add:aPpToken];
                anOpeningParenthesisCount--;
            }
            else
                [anArgument add:aPpToken];
        }
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
    [arguments release];
    [ppTokensWithMacroinvocations release];
    [overlappedMacroInvocation release];
    
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

- (void)addArgument:(NUCMacroArgument *)anArgument
{
    [[self arguments] addObject:anArgument];
}

- (NUCPpTokens *)ppTokensWithMacroinvocations
{
    return ppTokensWithMacroinvocations;
}

- (void)setPpTokensWithMacroinvocations:(NUCPpTokens *)aPpTokens
{
    [ppTokensWithMacroinvocations release];
    ppTokensWithMacroinvocations = [aPpTokens retain];
}

- (NUCPreprocessingToken *)lastPpTokenWithoutWhitespaces
{
    return [[self ppTokensWithMacroinvocations] lastPpTokenWithoutWhitespaces];
}

- (NUCMacroInvocation *)lastMacroInvocationWithoutWhitespaces
{
    NUCMacroInvocation *aMacroInvocation = [[self ppTokensWithMacroinvocations] lastMacroInvocationWithoutWhitespaces];
    if (aMacroInvocation)
        return aMacroInvocation;
    else
        if ([self isOverlapped])
            return [self lastOverlappedMacroInvocation];
        else
            return self;
}

- (NUCMacroInvocation *)overlappedMacroInvocation
{
    return overlappedMacroInvocation;
}

- (NUCMacroInvocation *)lastOverlappedMacroInvocation
{
    if ([self isOverlapped])
        return [[self overlappedMacroInvocation] lastOverlappedMacroInvocation];
    else
        return self;
}

- (void)setOverlappedMacroInvocation:(NUCMacroInvocation *)aMacroInvocation
{
    overlappedMacroInvocation = [aMacroInvocation retain];
}

- (BOOL)isOverlapped
{
    return [self overlappedMacroInvocation] ? YES : NO;
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

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens With:(NUCPreprocessor *)aPreprocessor
{
    [[self ppTokensWithMacroinvocations] enumerateObjectsUsingBlock:^(NUCPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop) {
        
        if ([aPpToken isMacroInvocation])
            [(NUCMacroInvocation *)aPpToken addExpandedPpTokensTo:aPpTokens With:aPreprocessor];
        else
            [aPpTokens addObject:aPpToken];
    }];
}

- (NSArray *)executeHashHashOperetorsInReplacementList:(NSArray *)aPpTokens
{
    NUCPreprocessingTokenStream *aPpTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPpTokens];
    
    if ([[aPpTokenStream peekNext] isHashHash])
        return nil;
    
    NSMutableArray *aPpTokensAfterPreprocessingOfHashHashOperators = [NSMutableArray array];
    
    while ([aPpTokenStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aPpTokenStream next];
        
        if ([aPpToken isIdentifier])
        {
            while ([aPpTokenStream nextIsWhitespacesWithoutNewline])
                [aPpTokensAfterPreprocessingOfHashHashOperators addObject:[aPpTokenStream next]];
            
            if ([aPpTokenStream hasNext])
            {
                NUCDecomposedPreprocessingToken *aHashHashOrOther = [aPpTokenStream next];
                
                if ([aHashHashOrOther isHashHash])
                {
                    while ([aPpTokenStream nextIsWhitespacesWithoutNewline])
                        [aPpTokensAfterPreprocessingOfHashHashOperators addObject:[aPpTokenStream next]];
                    
                    NUCDecomposedPreprocessingToken *aHashHashOperatorOperand = [aPpTokenStream next];
                    
                    if (aHashHashOperatorOperand)
                    {
                        NUCConcatenatedPpToken *aConcatenatedPpToken = [[NUCConcatenatedPpToken alloc] initWithLeft:aPpToken right:aHashHashOperatorOperand];
                        
                        [aPpTokensAfterPreprocessingOfHashHashOperators addObject:aConcatenatedPpToken];
                        [aConcatenatedPpToken release];
                    }
                    else
                        return nil;
                }
                else
                    [aPpTokensAfterPreprocessingOfHashHashOperators addObject:aPpToken];
            }
        }
        else
            [aPpTokensAfterPreprocessingOfHashHashOperators addObject:aPpToken];
    }
    
    return aPpTokensAfterPreprocessingOfHashHashOperators;
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@", name:%@", [[[self define] identifier] string]];
}

@end
