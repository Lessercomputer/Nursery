//
//  NUCControlLineDefineFunctionLike.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLineDefineFunctionLike.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCNewline.h"
#import "NUCIdentifierList.h"
#import "NUCReplacementList.h"
#import "NUCPpTokens.h"
#import "NUCDiagnostic.h"
#import "NUCDiagnostics.h"

#import <Foundation/NSString.h>

@implementation NUCControlLineDefineFunctionLike

+ (BOOL)controlLineDefineFunctionLikeFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen into:(NUCPreprocessingDirective **)aToken
{
    NUCDecomposedPreprocessingToken *anEllipsis = nil;
    NUCIdentifierList *anIdentifierList = nil;
    NUCDecomposedPreprocessingToken *anRparen = nil;
    NUCReplacementList *aReplacementList = nil;
    
    [aStream skipWhitespacesWithoutNewline];
    [NUCIdentifierList identifierListFrom:aStream into:&anIdentifierList];
    [aStream skipWhitespacesWithoutNewline];

    if (anIdentifierList)
    {
        if ([[aStream peekNext] isComma])
        {
            [aStream next];
            [aStream skipWhitespacesWithoutNewline];
            
            if (![NUCDecomposedPreprocessingToken ellipsisFrom:aStream into:&anEllipsis])
                return NO;
        }
    }
    else
    {
        [NUCDecomposedPreprocessingToken ellipsisFrom:aStream into:&anEllipsis];
    }

    [aStream skipWhitespacesWithoutNewline];
    anRparen = [aStream next];
    
    if ([[anRparen content] isEqualToString:NUCClosingParenthesisPunctuator])
    {
        NUCNewline *aNewline = nil;
        [aStream skipWhitespacesWithoutNewline];
        [NUCReplacementList replacementListFrom:aStream into:&aReplacementList];
        [aStream skipWhitespacesWithoutNewline];
        
        if ([NUCNewline newlineFrom:aStream into:&aNewline])
        {
            if (aToken)
                *aToken = [NUCControlLineDefineFunctionLike defineWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier lparen:anLparen identifierList:anIdentifierList ellipsis:anEllipsis rparen:anRparen replacementList:aReplacementList newline:aNewline];
        }
        
        return YES;
    }
    
    return NO;
}
+ (instancetype)defineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen identifierList:(NUCIdentifierList *)anIdentifierList ellipsis:(NUCDecomposedPreprocessingToken *)anEllipsis rparen:(NUCDecomposedPreprocessingToken *)anRparen replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline
{
    return [[[self alloc] initWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier lparen:anLparen identifierList:anIdentifierList ellipsis:anEllipsis rparen:anRparen replacementList:aReplacementList newline:aNewline] autorelease];
}

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCIdentifier *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen identifierList:(NUCIdentifierList *)anIdentifierList ellipsis:(NUCDecomposedPreprocessingToken *)anEllipsis rparen:(NUCDecomposedPreprocessingToken *)anRparen replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline
{
    if (self = [super initWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier replacementList:aReplacementList newline:aNewline])
    {
        lparen = [anLparen retain];
        identifierList = [anIdentifierList retain];
        ellipsis = [anEllipsis retain];
        rparen = [anRparen retain];
    }
    
    return self;
}

- (void)dealloc
{
    [lparen release];
    [identifierList release];
    [ellipsis release];
    [rparen release];
    [hashOperatorOperandIndexesInParameters release];
    
    [super dealloc];
}

- (NUCDecomposedPreprocessingToken *)lparen
{
    return lparen;
}

- (NUCIdentifierList *)identifierList
{
    return identifierList;
}

- (NUCDecomposedPreprocessingToken *)ellipsis
{
    return ellipsis;
}

- (NUCDecomposedPreprocessingToken *)rparen
{
    return rparen;
}

- (BOOL)isFunctionLike
{
    return YES;
}

- (BOOL)isEqual:(id)anObject
{
    if (self == anObject)
        return YES;
    else if (![super isEqual:anObject])
        return NO;
    else
    {
        NUCControlLineDefineFunctionLike *aDefineFunctionLike = anObject;
        
        return ([self ellipsis] && [aDefineFunctionLike ellipsis])
                    || (![self ellipsis] && ![aDefineFunctionLike ellipsis]);
    }
}

- (NSMutableArray *)parameters
{
    if (!parameters)
    {
        __block NSMutableArray *aParameters = [NSMutableArray array];
        
        [[self identifierList] enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken *aPpToken, NSUInteger anIndex, BOOL *aStop) {
            
            if ([aPpToken isIdentifier])
                [aParameters addObject:aPpToken];
        }];
        
        parameters = aParameters;
    }
    
    return parameters;
}

- (NSUInteger)parameterCount
{
    return [[self parameters] count];
}

- (BOOL)identifierIsParameter:(NUCIdentifier *)anIdentifier
{
    if (![self ellipsis])
        return [[self parameters] containsObject:anIdentifier];
    else
        return [[anIdentifier content] isEqual:NUCPredfinedMacroVA_ARGS];
}

- (NSUInteger)parameterIndexOf:(NUCIdentifier *)anIdentifier
{
    if (![[anIdentifier content] isEqual:NUCPredfinedMacroVA_ARGS])
        return [[self parameters] indexOfObject:anIdentifier];
    else
        return [self parameterCount] ? [self parameterCount] - 1 : 0;;
}

- (BOOL)parameterIsHashOperatorOperandAt:(NSUInteger)anIndex
{
    if (anIndex >= [self parameterCount])
        return NO;
    
    return [[self hashOperatorOperandIndexesInParameters] containsIndex:anIndex];
}

- (NSMutableIndexSet *)hashOperatorOperandIndexesInParameters
{
    if (!hashOperatorOperandIndexesInParameters)
        [self getHashOperatorOperandIndexesInParameters:NULL];
    
    return hashOperatorOperandIndexesInParameters;
}

- (void)getHashOperatorOperandIndexesInParameters:(NUCDiagnostics **)aDiagnostics
{
    NSMutableIndexSet *aHashOperatorOperandIndexesInParameters = [NSMutableIndexSet indexSet];
    NUCPreprocessingTokenStream *aStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:[[[self replacementList] ppTokens] ppTokens]];
    NUCDiagnostics *aParameterDiagnostics = [NUCDiagnostics diagnostics];
     
    while ([aStream hasNext])
    {
        NUCDecomposedPreprocessingToken *aPpToken = [aStream next];
        
        if ([aPpToken isHash])
        {
            [aStream skipWhitespaces];
            
            aPpToken = [aStream next];
            
            if ([aPpToken isIdentifier])
            {
                NSUInteger aParameterIndex = [self parameterIndexOf:(NUCIdentifier *)aPpToken];
                
                if (aParameterIndex != NSNotFound)
                    [aHashOperatorOperandIndexesInParameters addIndex:aParameterIndex];
                else
                    [aParameterDiagnostics add:[NUCDiagnostic diagnostic]];
            }
        }
    }
    
    hashOperatorOperandIndexesInParameters = [aHashOperatorOperandIndexesInParameters retain];
    
    if (aDiagnostics)
        *aDiagnostics = aParameterDiagnostics;
}

@end
