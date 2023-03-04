//
//  NUCPreprocesser.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocesser.h"
#import "NUCSourceFile.h"
#import "NUCLexicalElement.h"
#import "NUCHeaderName.h"

#import "NUCPreprocessingTokenStream.h"

#import "NUCPreprocessingFile.h"
#import "NUCGroup.h"
#import "NUCGroupPart.h"
#import "NUCIfGroup.h"
#import "NUCElifGroups.h"
#import "NUCElifGroup.h"
#import "NUCElseGroup.h"
#import "NUCEndifLine.h"
#import "NUCIfSection.h"
#import "NUCPreprocessingDirective.h"
#import "NUCNewline.h"
#import "NUCPpTokens.h"
#import "NUCTextLine.h"
#import "NUCNonDirective.h"
#import "NUCControlLine.h"
#import "NUCControlLineInclude.h"
#import "NUCControlLineDefineObjectLike.h"
#import "NUCControlLineDefineFunctionLike.h"
#import "NUCUndef.h"
#import "NUCLine.h"
#import "NUCError.h"
#import "NUCPragma.h"
#import "NUCIdentifierList.h"
#import "NUCReplacementList.h"
#import "NUCConstantExpression.h"
#import "NUCConditionalExpression.h"
#import "NUCLogicalORExpression.h"
#import "NUCLogicalANDExpression.h"
#import "NUCInclusiveORExpression.h"
#import "NUCExclusiveORExpression.h"
#import "NUCANDExpression.h"
#import "NUCEqualityExpression.h"
#import "NUCExpression.h"
#import "NUCRelationalExpression.h"
#import "NUCShiftExpression.h"
#import "NUCAdditiveExpression.h"
#import "NUCMultiplicativeExpression.h"
#import "NUCCastExpression.h"
#import "NUCUnaryExpression.h"
#import "NUCPostfixExpression.h"
#import "NUCPrimaryExpression.h"
#import "NUCConstant.h"
#import "NUCIntegerConstant.h"
#import "NURegion.h"
#import "NUCRangePair.h"
#import "NULibrary.h"

#import <Foundation/NSString.h>
#import <Foundation/NSScanner.h>
#import <Foundation/NSArray.h>

@implementation NUCPreprocesser

- (instancetype)initWithTranslationEnvironment:(NUCTranslationEnvironment *)aTranslationEnvironment
{
    if (self = [super init])
    {
        translationEnvironment = [aTranslationEnvironment retain];
    }
    
    return self;
}

- (void)dealloc
{
    [translationEnvironment release];
    translationEnvironment = nil;
    
    [super dealloc];
}

- (void)preprocessSourceFile:(NUCSourceFile *)aSourceFile
{
    NULibrary *aSourceStringRangeMappingPhase1toPhysicalSource = [NULibrary libraryWithComparator:[NUCRangePairFromComparator comparator]];
    NULibrary *aSourceStringRangeMappingPhase2ToPhase1 = [NULibrary libraryWithComparator:[NUCRangePairFromComparator comparator]];
    
    NSString *aLogicalSourceStringInPhase1 = [self preprocessPhase1:[aSourceFile physicalSourceString] forSourceFile:aSourceFile rangeMappingFromPhase1ToPhysicalSourceString:aSourceStringRangeMappingPhase1toPhysicalSource];
    NSString *aLogicalSourceStringInPhase2 = [self preprocessPhase2:aLogicalSourceStringInPhase1 forSourceFile:aSourceFile rangeMappingFromPhase2StringToPhase1String:aSourceStringRangeMappingPhase2ToPhase1];
    
    [aSourceFile setLogicalSourceString:aLogicalSourceStringInPhase2];
    
    NSArray *aPreprocessingTokens = [self decomposePreprocessingFile:aSourceFile];
//    NSMutableArray *aNonwhitespaces = [NSMutableArray array];
//
//    [aPreprocessingTokens enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj type] == NUCLexicalElementNonWhiteSpaceCharacterType)
//            [aNonwhitespaces addObject:obj];
//    }];
//    NSLog(@"%@", aNonwhitespaces);
    
    NUCPreprocessingFile *aPreprocessingFile = nil;
    
    if ([self scanPreprocessingFileFrom:aPreprocessingTokens into:&aPreprocessingFile])
        [self preprocessPreprocessingFile:aPreprocessingFile];
}

- (NSArray *)decomposePreprocessingFile:(NUCSourceFile *)aSourceFile
{
    NSMutableArray *aPreprocessingTokens = [NSMutableArray array];
    NSScanner *aScanner = [NSScanner scannerWithString:[aSourceFile logicalSourceString]];
    [aScanner setCharactersToBeSkipped:nil];
    
    while (![aScanner isAtEnd])
    {
        if ([self decomposeWhiteSpaceCharacterFrom:aScanner into:aPreprocessingTokens])
            continue;
        if ([self decomposeHeaderNameFrom:aScanner into:aPreprocessingTokens])
            continue;
        if ([self decomposeIdentifierFrom:aScanner into:aPreprocessingTokens])
            continue;
        if ([self decomposePpNumberFrom:aScanner into:aPreprocessingTokens])
            continue;
        if ([self decomposeCharacterConstantFrom:aScanner into:aPreprocessingTokens])
            continue;
        if ([self decomposeStringLiteralFrom:aScanner into:aPreprocessingTokens])
            continue;
        if ([self decomposePunctuatorFrom:aScanner into:aPreprocessingTokens])
            continue;
        if ([self decomposeNonWhiteSpaceCharacterFrom:aScanner into:aPreprocessingTokens])
            continue;
    }
    
    return aPreprocessingTokens;
}

- (BOOL)scanPreprocessingFileFrom:(NSArray *)aPreprocessingTokens into:(NUCPreprocessingFile **)aPreprocessingFile
{
    NUCPreprocessingTokenStream *aPreprocessingTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPreprocessingTokens];
    NUCGroup *aGroup = nil;

    if ([self scanGroupFrom:aPreprocessingTokenStream into:&aGroup])
    {
        if (aPreprocessingFile)
            *aPreprocessingFile = [NUCPreprocessingFile preprocessingFileWithGroup:aGroup];
        
        return YES;
    }
    
    return NO;
}

- (void)preprocessPreprocessingFile:(NUCPreprocessingFile *)aPreprocessingFile
{
    NUCGroup *aGroup = [aPreprocessingFile group];
    
    if (!aGroup)
        return;
    
    NSLog(@"%@", [aGroup description]);
    
    [[aGroup groupParts] enumerateObjectsUsingBlock:^(NUCGroupPart * _Nonnull aGroupPart, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NUCLexicalElementType aGroupPartType = [[aGroupPart content] type];
        
        switch (aGroupPartType)
        {
            case NUCLexicalElementIfSectionType:
                
                
                break;
            case NUCLexicalElementControlLineType:
                
                break;
                
            case NUCLexicalElementTextLineType:
                
                break;
                
            default:
                break;
        }
    }];
}

- (BOOL)scanGroupFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCGroup **)aToken
{
    NUCGroup *aGroup = [NUCGroup group];
    NUCPreprocessingDirective *aGroupPart = nil;
    BOOL aTokenScanned = NO;
    
    while ([self scanGroupPartFrom:aPreprocessingTokenStream into:&aGroupPart])
    {
        aTokenScanned = YES;
        [aGroup add:aGroupPart];
    }
    
    if (aToken)
        *aToken = aGroup;
    
    return aTokenScanned;
}

- (BOOL)scanGroupPartFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPreprocessingDirective **)aGroupPart
{
    NUCPreprocessingDirective *aPreprocessingDirective = nil;
    
    if ([self scanIfSectionFrom:aPreprocessingTokenStream into:&aPreprocessingDirective])
        ;
    else if ([self scanControlLineFrom:aPreprocessingTokenStream into:&aPreprocessingDirective])
        ;
    else if ([self scanTextLineFrom:aPreprocessingTokenStream into:&aPreprocessingDirective])
        ;
    else if ([self scanHashAndNonDirectiveFrom:aPreprocessingTokenStream into:&aPreprocessingDirective])
        ;
    else
        return NO;
    
    if (aGroupPart)
        *aGroupPart = [NUCGroupPart groupPartWithContent:aPreprocessingDirective];
    
    return YES;
}

- (BOOL)scanIfSectionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPreprocessingDirective **)anIfSection
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    NUCIfGroup *anIfGroup = nil;
    NUCElifGroups *anElifGroups = nil;
    NUCElseGroup *anElseGroup = nil;
    NUCEndifLine *anEndifLine = nil;
    
    if ([self scanIfGroupFrom:aPreprocessingTokenStream into:&anIfGroup])
    {
        [self scanElifGroupsFrom:aPreprocessingTokenStream into:&anElifGroups];
        [self scanElseGroupFrom:aPreprocessingTokenStream into:&anElseGroup];
        
        if ([self scanEndifLineFrom:aPreprocessingTokenStream into:&anEndifLine])
        {
            if (anIfSection)
            {
                *anIfSection = [NUCIfSection ifSectionWithIfGroup:anIfGroup elifGroups:anElifGroups elseGroup:anElseGroup endifLine:anEndifLine];
            }
            
            return YES;
        }
        else
            [aPreprocessingTokenStream setPosition:aPosition];
    }
    
    return NO;
}
- (BOOL)scanControlLineIncludeFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken
{
    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
    
    if ([[aDirectiveName content] isEqualToString:NUCPreprocessingDirectiveInclude])
    {
        NUCPpTokens *aPpTokens = nil;
        NUCNewline *aNewLine = nil;
        
        if ([self scanPpTokensFrom:aPreprocessingTokenStream into:&aPpTokens] && [aPpTokens isPpTokens])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewLine])
            {
                if (aToken)
                    *aToken = [NUCControlLineInclude includeWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewLine];
                
                return YES;
            }
        }
    }
    
    return NO;
}
    
- (BOOL)scanControlLineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPreprocessingDirective **)aToken
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    NUCDecomposedPreprocessingToken *aHash = [aPreprocessingTokenStream next];
    
    if (aHash && [aHash isHash])
    {
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        
        NUCDecomposedPreprocessingToken *aDirectiveName = [aPreprocessingTokenStream next];
        
        if (aDirectiveName)
        {
            if ([self scanControlLineIncludeFrom:aPreprocessingTokenStream hash:aHash directiveName:aDirectiveName into:aToken])
                return YES;
            else if ([self scanControlLineDefineFrom:aPreprocessingTokenStream hash:aHash directiveName:aDirectiveName into:aToken])
                return YES;
            else if ([self scanUndefFrom:aPreprocessingTokenStream hash:aHash directiveName:aDirectiveName into:aToken])
                return YES;
            else if ([self scanControlLineLineFrom:aPreprocessingTokenStream hash:aHash directiveName:aDirectiveName into:(NUCLine **)aToken])
                return YES;
            else if ([self scanErrorFrom:aPreprocessingTokenStream hash:aHash directiveName:aDirectiveName into:(NUCError **)aToken])
                return YES;
            else if ([self scanPragmaFrom:aPreprocessingTokenStream hash:aHash directiveName:aDirectiveName into:(NUCPragma **)aToken])
                return YES;
        }
        else
        {
            if ([self scanControlLineNewlineFrom:aPreprocessingTokenStream hash:aHash directiveName:aDirectiveName into:(NUCControlLine **)aToken])
                return YES;
        }
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (BOOL)scanControlLineDefineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken
{
    if (![[aDirectiveName content] isEqualToString:NUCPreprocessingDirectiveDefine])
        return NO;
    
    NUCDecomposedPreprocessingToken *anIdentifier = [aPreprocessingTokenStream next];
    
    if (!anIdentifier)
        return NO;
    
    NUCDecomposedPreprocessingToken *anLparen = [aPreprocessingTokenStream peekNext];

    if ([[anLparen content] isEqualToString:NUCOpeningParenthesisPunctuator])
    {
        [aPreprocessingTokenStream next];
        
        if ([self scanControlLineDefineFunctionLikeFrom:aPreprocessingTokenStream hash:aHash directiveName:aDirectiveName identifier:anIdentifier lparen:anLparen into:aToken])
            return YES;
    }
    else
    {
        if ([self scanControlLineDefineObjectLikeFrom:aPreprocessingTokenStream hash:aHash directiveName:aDirectiveName identifier:anIdentifier into:aToken])
            return YES;
    }
    
    return NO;
}

- (BOOL)scanControlLineDefineFunctionLikeFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen into:(NUCPreprocessingDirective **)aToken
{
    NUCDecomposedPreprocessingToken *anEllipsis = nil;
    NUCIdentifierList *anIdentifierList = nil;
    NUCDecomposedPreprocessingToken *anRparen = nil;
    NUCReplacementList *aReplacementList = nil;
    
    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
    [self scanIdentifierListFrom:aPreprocessingTokenStream into:&anIdentifierList];
    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];

    if (anIdentifierList)
    {
        if ([[aPreprocessingTokenStream peekNext] isComma])
        {
            [aPreprocessingTokenStream next];
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            if (![self scanEllipsisFrom:aPreprocessingTokenStream into:&anEllipsis])
                return NO;
        }
    }
    else
    {
        [self scanEllipsisFrom:aPreprocessingTokenStream into:&anEllipsis];
    }

    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
    anRparen = [aPreprocessingTokenStream next];
    
    if ([[anRparen content] isEqualToString:NUCClosingParenthesisPunctuator])
    {
        NUCNewline *aNewline = nil;
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        [self scanReplacementListFrom:aPreprocessingTokenStream into:&aReplacementList];
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        
        if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
        {
            if (aToken)
                *aToken = [NUCControlLineDefineFunctionLike defineWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier lparen:anLparen identifierList:anIdentifierList ellipsis:anEllipsis rparen:anRparen replacementList:aReplacementList newline:aNewline];
        }
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanControlLineDefineObjectLikeFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier into:(NUCPreprocessingDirective **)aToken
{
    NUCReplacementList *aReplacementList = nil;
    NUCNewline *aNewline = nil;

    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
    [self scanReplacementListFrom:aPreprocessingTokenStream into:&aReplacementList];
    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
    
    if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
    {
        if (aNewline)
        {
            if (aToken)
                *aToken = [NUCControlLineDefineObjectLike defineWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier replacementList:aReplacementList newline:aNewline];
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)scanReplacementListFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPreprocessingDirective **)aToken
{
    NUCPpTokens *aPpTokens = nil;
    
    if ([self scanPpTokensFrom:aPreprocessingTokenStream into:&aPpTokens])
    {
        if (aToken)
            *aToken = [NUCReplacementList replacementListWithPpTokens:aPpTokens];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanIdentifierListFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCIdentifierList **)aToken
{
    NUCDecomposedPreprocessingToken *aPreprocessingToken = nil;
    NUCIdentifierList *anIdentifierList = [NUCIdentifierList identifierList];
    
    do
    {
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        aPreprocessingToken = [aPreprocessingTokenStream peekNext];
        
        if ([aPreprocessingToken isIdentifier])
            [anIdentifierList add:[aPreprocessingTokenStream next]];
        else if ([aPreprocessingToken isComma])
            [aPreprocessingTokenStream next];
        
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        aPreprocessingToken = [aPreprocessingTokenStream peekNext];
    }
    while ([aPreprocessingToken isComma] || [aPreprocessingToken isIdentifier]);
    
    if ([anIdentifierList count])
    {
        if (aToken)
            *aToken = anIdentifierList;
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanEllipsisFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCDecomposedPreprocessingToken **)aToken
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    NUCDecomposedPreprocessingToken *anEllipsis = [aPreprocessingTokenStream next];
    
    if ([anEllipsis isEllipsis])
    {
        if (aToken)
            *aToken = anEllipsis;
        
        return YES;
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (BOOL)scanUndefFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken
{
    if ([aDirectiveName isUndef])
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        
        NUCDecomposedPreprocessingToken *anIdentifier = [aPreprocessingTokenStream next];
        NUCNewline *aNewline = nil;

        if ([anIdentifier isIdentifier])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                        
            if (anIdentifier && [self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
            {
                if (aToken)
                    *aToken = [NUCUndef undefWithHash:aHash directiveName:aDirectiveName identifier:anIdentifier newline:aNewline];
                
                return YES;
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
    }
    
    return NO;
}

- (BOOL)scanControlLineLineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCLine **)aToken
{
    if ([aDirectiveName isLine])
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCPpTokens *aTokens = nil;
        NUCNewline *aNewline = nil;
        
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        
        if ([self scanPpTokensFrom:aPreprocessingTokenStream into:&aTokens])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
            {
                if (aToken)
                    *aToken = [NUCLine lineWithHash:aHash directiveName:aDirectiveName ppTokens:aTokens newline:aNewline];
                
                return YES;
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
    }
    
    return NO;
}

- (BOOL)scanErrorFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCControlLine **)aToken
{
    if ([aDirectiveName isError])
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCPpTokens *aPpTokens = nil;
        NUCNewline *aNewline = nil;
        
        if ([self scanPpTokensFrom:aPreprocessingTokenStream into:&aPpTokens])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
            {
                if (aToken)
                    *aToken = [NUCError errorWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline];
                
                return YES;
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
    }
    
    return NO;
}

- (BOOL)scanPragmaFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCControlLine **)aToken
{
    if ([aDirectiveName isPragma])
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCPpTokens *aPpTokens = nil;
        NUCNewline *aNewline = nil;
        
        if ([self scanPpTokensFrom:aPreprocessingTokenStream into:&aPpTokens])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
            {
                if (aToken)
                    *aToken = [NUCPragma pragmaWithHash:aHash directiveName:aDirectiveName ppTokens:aPpTokens newline:aNewline];
                
                return YES;
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
    }
    
    return NO;
}

- (BOOL)scanControlLineNewlineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCControlLine **)aToken
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    NUCNewline *aNewline = nil;
    
    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
    
    if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
    {
        if (aToken)
            *aToken = [[[NUCControlLine alloc] initWithType:NUCLexicalElementControlLineNewlineType hash:aHash directiveName:aDirectiveName newline:aNewline] autorelease];
        
        return YES;
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (BOOL)scanTextLineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPreprocessingDirective **)aToken
{
    if ([[aPreprocessingTokenStream peekNext] isHash])
        return NO;
    
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    NUCPpTokens *aPpTokens = nil;
    NUCNewline *aNewline = nil;
    
    [self scanPpTokensFrom:aPreprocessingTokenStream into:&aPpTokens];
    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
    
    if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
    {
        if (aToken)
            *aToken = [NUCTextLine textLineWithPpTokens:aPpTokens newline:aNewline];
        
        return YES;
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (BOOL)scanPpTokensFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPpTokens **)aToken
{
    NUCDecomposedPreprocessingToken *aPpToken = nil;
    NUCPpTokens *aPpTokens = [NUCPpTokens ppTokens];
    
    while ([[aPreprocessingTokenStream peekNext] isNotWhitespace])
    {
        aPpToken = [aPreprocessingTokenStream next];
        [aPpTokens add:aPpToken];
        
        if (aToken)
            *aToken = aPpTokens;
    }
    
    return [aPpTokens count] ? YES : NO;
}

- (BOOL)scanPreprocessingTokenFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCDecomposedPreprocessingToken **)aToken
{
    NUCDecomposedPreprocessingToken *aPreprocessingToken = [aPreprocessingTokenStream peekNext];
    
    if (aPreprocessingToken && [aPreprocessingToken isNotWhitespace])
    {
        [aPreprocessingTokenStream next];
        
        if (aToken)
            *aToken = aPreprocessingToken;
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanHashAndNonDirectiveFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPreprocessingDirective **)aToken
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    NUCDecomposedPreprocessingToken *aPpToken = [aPreprocessingTokenStream next];
    
    if ([aPpToken isHash])
    {
        NUCNonDirective *aNonDirective = nil;

        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
    
        if ([self scanNonDirectiveFrom:aPreprocessingTokenStream into:&aNonDirective hash:aPpToken])
        {
            if (aToken)
                *aToken = aNonDirective;
            
            return YES;
        }
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (BOOL)scanNonDirectiveFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCNonDirective **)aToken hash:(NUCDecomposedPreprocessingToken *)aHash
{
    NUCPpTokens *aPpTokens = [NUCPpTokens ppTokens];
    NUCNewline *aNewline = nil;
    
    if ([[aPreprocessingTokenStream peekNext] isDirectiveName])
        return NO;
    
    if ([self scanPpTokensFrom:aPreprocessingTokenStream into:&aPpTokens] && [self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
    {
        if (aToken)
            *aToken = [NUCNonDirective noneDirectiveWithHash:aHash ppTokens:aPpTokens newline:aNewline];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanIfGroupFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCIfGroup **)anIfGroup
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    [aPreprocessingTokenStream skipWhitespaces];
    NUCDecomposedPreprocessingToken *aToken = [aPreprocessingTokenStream next];
    
    if (aToken && [aToken isHash])
    {
        NUCDecomposedPreprocessingToken *aHash = aToken;
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        aToken = [aPreprocessingTokenStream next];
        
        if (aToken)
        {
            NSString *anIfGroupTypeString = [aToken content];
            NUCLexicalElementType anIfGroupType = NUCLexicalElementNone;
            NUCDecomposedPreprocessingToken *aTypeName = aToken;
            NUCLexicalElement *anExpressionOrIdentifier = nil;
            NUCNewline *aNewline = nil;
            
            if ([anIfGroupTypeString isEqualToString:NUCPreprocessingDirectiveIf])
            {
                anIfGroupType = NUCLexicalElementIfType;
                
                [aPreprocessingTokenStream skipWhitespaces];
                [self scanConstantExpressionFrom:aPreprocessingTokenStream into:&anExpressionOrIdentifier];
            }
            else if ([anIfGroupTypeString isEqualToString:NUCPreprocessingDirectiveIfdef])
            {
                anIfGroupType = NUCLexicalElementIfdefType;
                
                [aPreprocessingTokenStream skipWhitespaces];
                anExpressionOrIdentifier = [aPreprocessingTokenStream next];
            }
            else if ([anIfGroupTypeString isEqualToString:NUCPreprocessingDirectiveIfndef])
            {
                anIfGroupType = NUCLexicalElementIfndefType;
                
                [aPreprocessingTokenStream skipWhitespaces];
                anExpressionOrIdentifier = [aPreprocessingTokenStream next];
            }
            
            if (aHash && anExpressionOrIdentifier && [self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
            {
                NUCGroup *aGroup = nil;
                [self scanGroupFrom:aPreprocessingTokenStream into:&aGroup];
                
                if (anIfGroup)
                    *anIfGroup = [NUCIfGroup ifGroupWithType:anIfGroupType hash:aHash
                                                    directiveName:aTypeName expressionOrIdentifier:anExpressionOrIdentifier newline:aNewline group:aGroup];
                
                return YES;
            }
        }
    }

    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (BOOL)scanNewlineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCNewline **)aNewline
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    NUCDecomposedPreprocessingToken *aToken = [aPreprocessingTokenStream next];
    NUCDecomposedPreprocessingToken *aCr = nil;
    NUCDecomposedPreprocessingToken *anLf = nil;
    
    if (aToken)
    {
        if ([[aToken content] isEqualToString:NUCCR])
        {
            aCr = aToken;
            aToken = [aPreprocessingTokenStream next];
            
            if (aToken && [[aToken content] isEqualToString:NUCLF])
                anLf = aToken;
            else
                [aPreprocessingTokenStream setPosition:aPosition];
        }
        else if ([[aToken content] isEqualToString:NUCLF])
        {
            anLf = aToken;
        }
        else
        {
            [aPreprocessingTokenStream setPosition:aPosition];
            
            return NO;
        }
        
        if (aNewline)
            *aNewline = [NUCNewline newlineWithCr:aCr lf:anLf];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanConstantExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCLexicalElement **)aToken
{
    NUCConditionalExpression *aConditionalExpression = nil;
    
    if ([self scanConditionalExpressionFrom:aPreprocessingTokenStream into:&aConditionalExpression])
    {
        if (aToken)
            *aToken = [NUCConstantExpression expressionWithConditionalExpression:aConditionalExpression];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanConditionalExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCConditionalExpression **)aToken
{
    NUCLogicalORExpression *aLogicalOrExpression = nil;
    if ([self scanLogicalORExpressionFrom:aPreprocessingTokenStream into:&aLogicalOrExpression])
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        
        NUCDecomposedPreprocessingToken *aQuestionMark = [aPreprocessingTokenStream next];
        if ([aQuestionMark isQuestionMark])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCExpression *anExpression = nil;
            if ([self scanExpressionFrom:aPreprocessingTokenStream into:&anExpression])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                NUCDecomposedPreprocessingToken *aColon = [aPreprocessingTokenStream next];
                if ([aColon isColon])
                {
                    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                    
                    NUCConditionalExpression *aConditionalExpression = nil;
                    if ([self scanConditionalExpressionFrom:aPreprocessingTokenStream into:&aConditionalExpression])
                    {
                        if (aToken)
                            *aToken = [NUCConditionalExpression expressionWithLogicalORExpression:aLogicalOrExpression questionMarkPunctuator:aQuestionMark expression:anExpression colonPunctuator:aColon conditionalExpression:aConditionalExpression];
                        
                        return YES;
                    }
                }
            }
        }
        else
        {
            [aPreprocessingTokenStream setPosition:aPosition];
            
            if (aToken)
                *aToken = [NUCConditionalExpression expressionWithLogicalORExpression:aLogicalOrExpression];
            
            return YES;
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
    }

    return NO;
}

- (BOOL)scanLogicalORExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCLogicalORExpression **)aToken
{
    NUCLogicalANDExpression *anAndExpression = nil;
    
    if ([self scanLogicalANDExpressionFrom:aPreprocessingTokenStream into:&anAndExpression])
    {
        if (aToken)
            *aToken = [NUCLogicalORExpression expressionWithLogicalANDExpression:anAndExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCLogicalORExpression *anORExpression = nil;
        
        if ([self scanLogicalORExpressionFrom:aPreprocessingTokenStream into:&anORExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOROperator = [aPreprocessingTokenStream next];
            if ([anOROperator isLogicalOROperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                if ([self scanLogicalANDExpressionFrom:aPreprocessingTokenStream into:&anAndExpression])
                {
                    if (aToken)
                        *aToken = [NUCLogicalORExpression expressionWithlogicalORExpression:anORExpression logicalOREperator:anOROperator logicalANDExpression:anAndExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        return NO;
    }
}

- (BOOL)scanExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCExpression **)aToken
{
    NUCConditionalExpression *aConditionalExpression = nil;
    
    if ([self scanConditionalExpressionFrom:aPreprocessingTokenStream into:&aConditionalExpression])
    {
        if (aToken)
            *aToken = [NUCExpression expressionWithConditionalExpression:aConditionalExpression];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanLogicalANDExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCLogicalANDExpression **)aToken
{
    NUCInclusiveORExpression *anInclusiveORExpression = nil;
    
    if ([self scanInclusiveORExpressionFrom:aPreprocessingTokenStream into:&anInclusiveORExpression])
    {
        if (aToken)
            *aToken = [NUCLogicalANDExpression expressionWithInclusiveORExpression:anInclusiveORExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCLogicalANDExpression *anAndExpression = nil;
        
        if ([self scanLogicalANDExpressionFrom:aPreprocessingTokenStream into:&anAndExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *aLogicalANDOperator = [aPreprocessingTokenStream next];
            if ([aLogicalANDOperator isLogicalANDOperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                if ([self scanInclusiveORExpressionFrom:aPreprocessingTokenStream into:&anInclusiveORExpression])
                {
                    if (aToken)
                        *aToken = [NUCLogicalANDExpression expressionWithLogicalANDExpression:anAndExpression logicalANDOperator:aLogicalANDOperator inclusiveORExpression:anInclusiveORExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        
        return NO;
    }
}

- (BOOL)scanInclusiveORExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCInclusiveORExpression **)aToken
{
    NUCExclusiveORExpression *anExclusiveORExpression = nil;
    
    if ([self scanExclusiveORExpressionFrom:aPreprocessingTokenStream into:&anExclusiveORExpression])
    {
        if (aToken)
            *aToken = [NUCInclusiveORExpression expressionExclusiveExpression:anExclusiveORExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCInclusiveORExpression *anInclusiveExpression = nil;
        
        if ([self scanInclusiveORExpressionFrom:aPreprocessingTokenStream into:&anInclusiveExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anInclusiveOROperator =  [aPreprocessingTokenStream next];
            if ([anInclusiveOROperator isInclusiveOROperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                NUCExclusiveORExpression *anExclusiveORExpression = nil;
                if ([self scanExclusiveORExpressionFrom:aPreprocessingTokenStream into:&anExclusiveORExpression])
                {
                    if (aToken)
                        *aToken = [NUCInclusiveORExpression expressionWithInclusiveORExpression:anInclusiveExpression inclusiveOROperator:anInclusiveOROperator exclusiveORExpression:anExclusiveORExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        
        return NO;
    }
}

- (BOOL)scanExclusiveORExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCExclusiveORExpression **)aToken
{
    NUCANDExpression *anANDExpression = nil;
    
    if ([self scanANDExpressionFrom:aPreprocessingTokenStream into:&anANDExpression])
    {
        if (aToken)
            *aToken = [NUCExclusiveORExpression expressionWithANDExpression:anANDExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCExclusiveORExpression *anExclusiveORExpression = nil;
        
        if ([self scanExclusiveORExpressionFrom:aPreprocessingTokenStream into:&anExclusiveORExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anExclusiveOROperator = [aPreprocessingTokenStream next];
            
            if ([anExclusiveOROperator isExclusiveOROperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                if ([self scanANDExpressionFrom:aPreprocessingTokenStream into:&anANDExpression])
                {
                    if (aToken)
                        *aToken = [NUCExclusiveORExpression expressionWithExclusiveORExpression:anExclusiveORExpression exclusiveOROperator:anExclusiveOROperator andExpression:anANDExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        
        return NO;
    }
}

- (BOOL)scanANDExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCANDExpression **)aToken
{
    NUCEqualityExpression *anEqulityExpression = nil;
    
    if ([self scanEqualityExpressionFrom:aPreprocessingTokenStream into:&anEqulityExpression])
    {
        if (aToken)
            *aToken = [NUCANDExpression expressionWithEqualityExpression:anEqulityExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCANDExpression *anANDExpression = nil;
        
        if ([self scanANDExpressionFrom:aPreprocessingTokenStream into:&anANDExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            NUCDecomposedPreprocessingToken *anAndOperator = [aPreprocessingTokenStream next];
            
            if ([anAndOperator isBitwiseANDOperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                NUCEqualityExpression *anEqulityExpression = nil;
                
                if ([self scanEqualityExpressionFrom:aPreprocessingTokenStream into:&anEqulityExpression])
                {
                    if (aToken)
                        *aToken = [NUCANDExpression expressionWithANDExpression:anANDExpression andOperator:anAndOperator equlityExpression:anEqulityExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        
        return NO;
    }
}

- (BOOL)scanEqualityExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCEqualityExpression **)aToken
{
    NUCRelationalExpression *aRelationalExpression = nil;
    
    if ([self scanRelationalExpressionFrom:aPreprocessingTokenStream into:&aRelationalExpression])
    {
        if (aToken)
            *aToken = [NUCEqualityExpression expressionWithRelationalExpression:aRelationalExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCEqualityExpression *anEqualityExpression = nil;
        
        if ([self scanEqualityExpressionFrom:aPreprocessingTokenStream into:&anEqualityExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aPreprocessingTokenStream next];
            
            if ([anOperator isEqualityOperator] || [anOperator isInequalityOperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                if ([self scanRelationalExpressionFrom:aPreprocessingTokenStream into:&aRelationalExpression])
                {
                    if (aToken)
                        *aToken = [NUCEqualityExpression expressionWithEqualityExpression:anEqualityExpression equalityOperator:anOperator relationalExpression:aRelationalExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        
        return NO;
    }
}

- (BOOL)scanRelationalExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCRelationalExpression **)aToken
{
    NUCShiftExpression *aShiftExpression = nil;
    
    if ([self scanShiftExpressionFrom:aPreprocessingTokenStream into:&aShiftExpression])
    {
        if (aToken)
            *aToken = [NUCRelationalExpression expressionWithShiftExpression:aShiftExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCRelationalExpression *aRelationalExpression = nil;
        
        if ([self scanRelationalExpressionFrom:aPreprocessingTokenStream into:&aRelationalExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anOperator = [aPreprocessingTokenStream next];
            
            if ([anOperator isRelationalOperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                if ([self scanShiftExpressionFrom:aPreprocessingTokenStream into:&aShiftExpression])
                {
                    if (aToken)
                        *aToken = [NUCRelationalExpression expressionWithRelationalExpression:aRelationalExpression relationalOperator:anOperator shiftExpression:aShiftExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        
        return NO;
    }
}

- (BOOL)scanShiftExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCShiftExpression **)aToken
{
    NUCAdditiveExpression *anAdditiveExpression = nil;
    
    if ([self scanAdditiveExpressionFrom:aPreprocessingTokenStream into:&anAdditiveExpression])
    {
        if (aToken)
            *aToken = [NUCShiftExpression expressionWithAdditiveExpression:anAdditiveExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCShiftExpression *aShiftExpression = nil;
        
        if ([self scanShiftExpressionFrom:aPreprocessingTokenStream into:&aShiftExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *aShiftOperator = [aPreprocessingTokenStream next];
            
            if ([aShiftOperator isShiftOperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                if ([self scanAdditiveExpressionFrom:aPreprocessingTokenStream into:&anAdditiveExpression])
                {
                    if (aToken)
                        *aToken = [NUCShiftExpression expressionWithShiftExpression:aShiftExpression shiftOperator:aShiftOperator additiveExpression:anAdditiveExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        
        return NO;
    }
}

- (BOOL)scanAdditiveExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCAdditiveExpression **)aToken
{
    NUCMultiplicativeExpression *aMultiplicativeExpression = nil;
    
    if ([self scanMultiplicativeExpressionFrom:aPreprocessingTokenStream into:&aMultiplicativeExpression])
    {
        if (aToken)
            *aToken = [NUCAdditiveExpression expressionWithMultiplicativeExpression:aMultiplicativeExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCAdditiveExpression *anAdditiveExpression = nil;
        
        if ([self scanAdditiveExpressionFrom:aPreprocessingTokenStream into:&anAdditiveExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *anAdditiveOperator = [aPreprocessingTokenStream next];
            
            if ([anAdditiveOperator isAdditiveOperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                if ([self scanMultiplicativeExpressionFrom:aPreprocessingTokenStream into:&aMultiplicativeExpression])
                {
                    if (aToken)
                        *aToken = [NUCAdditiveExpression expressionWithAdditiveExpression:anAdditiveExpression additiveOperator:anAdditiveOperator multiplicativeExpression:aMultiplicativeExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        return NO;
    }
}

- (BOOL)scanMultiplicativeExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCMultiplicativeExpression **)aToken
{
    NUCCastExpression *aCastExpression = nil;
    
    if ([self scanCastExpressionFrom:aPreprocessingTokenStream into:&aCastExpression])
    {
        if (aToken)
            *aToken = [NUCMultiplicativeExpression expressionWithCastExpression:aCastExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCMultiplicativeExpression *aMultiplicativeExpression = nil;
        
        if ([self scanMultiplicativeExpressionFrom:aPreprocessingTokenStream into:&aMultiplicativeExpression])
        {
            [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
            
            NUCDecomposedPreprocessingToken *aMultiplicativeOperator = [aPreprocessingTokenStream next];
            
            if ([aMultiplicativeOperator isMultiplicativeOperator])
            {
                [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                
                if ([self scanCastExpressionFrom:aPreprocessingTokenStream into:&aCastExpression])
                {
                    if (aToken)
                        *aToken = [NUCMultiplicativeExpression expressionWithMultiplicativeExpression:aMultiplicativeExpression multiplicativeOperator:aMultiplicativeOperator castExpression:aCastExpression];
                    
                    return YES;
                }
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        
        return NO;
    }
}

- (BOOL)scanCastExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCCastExpression **)aToken
{
    NUCUnaryExpression *anUnaryExpression = nil;
    
    if ([self scanUnaryExpressionFrom:aPreprocessingTokenStream into:&anUnaryExpression])
    {
        if (aToken)
            *aToken = [NUCCastExpression expressionWithUnaryExpression:anUnaryExpression];
        
        return YES;
    }
                       
    return NO;
}

- (BOOL)scanUnaryExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCUnaryExpression **)aToken
{
    NUCPostfixExpression *aPostfixExpression = nil;
    
    if ([self scanPostfixExpressionFrom:aPreprocessingTokenStream into:&aPostfixExpression])
    {
        if (aToken)
            *aToken = [NUCUnaryExpression expressionWithPostfixExpression:aPostfixExpression];
        
        return YES;
    }
    else
    {
        NSUInteger aPosition = [aPreprocessingTokenStream position];
        NUCDecomposedPreprocessingToken *anUnaryOperator = [aPreprocessingTokenStream next];
        
        if ([anUnaryOperator isUnaryOperator])
        {
            NUCCastExpression *aCastExpression = nil;
            
            if ([self scanCastExpressionFrom:aPreprocessingTokenStream into:&aCastExpression])
            {
                if (aToken)
                    *aToken = [NUCUnaryExpression expressionWithUnaryOperator:anUnaryOperator castExpression:aCastExpression];
                
                return YES;
            }
        }
        
        [aPreprocessingTokenStream setPosition:aPosition];
        
        return NO;
    }
    
    return NO;
}

- (BOOL)scanPostfixExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPostfixExpression **)aToken
{
    NUCPrimaryExpression *aPrimaryExpression = nil;
    
    if ([self scanPrimaryExpressionFrom:aPreprocessingTokenStream into:&aPrimaryExpression])
    {
        if (aToken)
            *aToken = [NUCPostfixExpression expressionWithPrimaryExpression:aPrimaryExpression];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanPrimaryExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPrimaryExpression **)anExpression
{
    NUCDecomposedPreprocessingToken *aToken = [aPreprocessingTokenStream next];
    NUCConstant *aConstant = nil;
    
    if ([aToken isIdentifier])
    {
        if (anExpression)
            *anExpression = [NUCPrimaryExpression expressionWithIdentifier:aToken];
        
        return YES;
    }
    else if ([self scanConstantFrom:aToken into:&aConstant])
    {
        if (anExpression)
            *anExpression = [NUCPrimaryExpression expressionWithConstant:aConstant];
        
        return YES;
    }
    else if ([aToken isStringLiteral])
    {
        if (anExpression)
            *anExpression = [NUCPrimaryExpression expressionWithStringLiteral:aToken];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanConstantFrom:(NUCDecomposedPreprocessingToken *)aPreprocessingToken into:(NUCConstant **)aConstant
{
    
    if ([self scanIntegerConstantFrom:aPreprocessingToken into:aConstant])
    {
        return YES;
    }
    else if ([aPreprocessingToken isCharacterConstant])
    {
        if (aConstant)
            *aConstant = [NUCConstant constantWithCharacterConstant:aPreprocessingToken];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)scanIntegerConstantFrom:(NUCDecomposedPreprocessingToken *)aPreprocessingToken into:(NUCConstant **)aConstant
{
    if (![aPreprocessingToken isPpNumber])
        return NO;
    
    NUUInt64 aValue = 0;
    NSString *aString = [aPreprocessingToken content];
    
    if ([aString hasPrefix:NUCHexadecimalPrefixSmall] || [aString hasPrefix:NUCHexadecimalPrefixLarge])
    {
        NSRange aHexDigitsRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCHexadecimalDigitCharacterSet] options:0 range:NSMakeRange(2, [aString length] - 2)];
        
        if (aHexDigitsRange.location == NSNotFound)
            return NO;
        
        for (NSUInteger aLocation = aHexDigitsRange.location; NSLocationInRange(aLocation, aHexDigitsRange); aLocation++)
        {
            unichar aCharacter = [aString characterAtIndex:aLocation];
            
            aValue *= 16;
            
            if (aCharacter >= 'a')
                aValue += aCharacter - 'a' + 10;
            else if (aCharacter >= 'A')
                aValue += aCharacter - 'A' + 10;
            else
                aValue += aCharacter - '0';
        }
    }
    else if ([aString hasPrefix:NUCOctalDigitZero])
    {
        NSRange anOctalDigitsRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCOctalDigitCharacterSet]];
        
        if (anOctalDigitsRange.location == NSNotFound)
            return NO;
        
        for (NSUInteger aLocation = anOctalDigitsRange.location; NSLocationInRange(aLocation, anOctalDigitsRange); aLocation++)
        {
            aValue *= 8;
            aValue += [aString characterAtIndex:aLocation] - '0';
        }
    }
    else
    {
        NSRange aDecimalDigitsRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCDigitCharacterSet]];
        
        if (aDecimalDigitsRange.location == NSNotFound)
            return NO;
        
        for (NSUInteger aLocation = aDecimalDigitsRange.location; NSLocationInRange(aLocation, aDecimalDigitsRange) ; aLocation++)
        {
            aValue *= 10;
            aValue += [aString characterAtIndex:aLocation] - '0';
        }
    }
    
    if (aConstant)
        *aConstant = [NUCConstant constantWithIntegerConstant:[NUCIntegerConstant constantWithPpNumber:aPreprocessingToken value:aValue]];
    
    return YES;
}

- (BOOL)decomposeIdentifierFrom:(NSScanner *)aScanner into:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([self scanIdentifierNondigitFrom:aScanner])
    {
        while ([self scanDigitFrom:aScanner] || [self scanIdentifierNondigitFrom:aScanner]);
    }
    
    if (aScanLocation != [aScanner scanLocation])
    {
        NSRange anIdentifierRange = NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation);
        
        [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:anIdentifierRange type:NUCLexicalElementIdentifierType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanIdentifierNondigitFrom:(NSScanner *)aScanner
{
    return [self scanNondigitFrom:aScanner];
}

- (BOOL)scanSmallEFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCSmallE intoString:NULL];
}

- (BOOL)scanLargeEFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCLargeE intoString:NULL];
}

- (BOOL)scanSmallPFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCSmallP intoString:NULL];
}

- (BOOL)scanLargePFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCLargeP intoString:NULL];
}

- (BOOL)decomposePpNumberFrom:(NSScanner *)aScanner into:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    BOOL aLoopShouldContinue = YES;
    
    while (aLoopShouldContinue)
    {
        BOOL aDigitScand = NO;
        
        if ([self scanDigitFrom:aScanner])
            aDigitScand = YES;
        else if ([self scanPeriodFrom:aScanner])
            aDigitScand = [self scanDigitFrom:aScanner];
        
        if (aDigitScand)
            aLoopShouldContinue = (([self scanSmallEFrom:aScanner] || [self scanLargeEFrom:aScanner]) && [self scanSignFrom:aScanner])
            || (([self scanSmallPFrom:aScanner] || [self scanLargePFrom:aScanner]) && [self scanSignFrom:aScanner])
            || [self scanIdentifierNondigitFrom:aScanner];
        else
            aLoopShouldContinue = NO;
    }
    
    if ([aScanner scanLocation] != aScanLocation)
    {
        [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation) type:NUCLexicalElementPpNumberType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanSignFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCPlusSign intoString:NULL]
            || [aScanner scanString:NUCMinusSign intoString:NULL];
}

- (BOOL)decomposeStringLiteralFrom:(NSScanner *)aScanner into:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    [aScanner scanString:NUCStringLiteralEncodingPrefixSmallU8 intoString:NULL]
        || [aScanner scanString:NUCStringLiteralEncodingPrefixSmallU intoString:NULL]
        || [aScanner scanString:NUCStringLiteralEncodingPrefixLargeU intoString:NULL]
        || [aScanner scanString:NUCStringLiteralEncodingPrefixLargeL intoString:NULL];
    
    if ([aScanner scanString:NUCDoubleQuotationMark intoString:NULL])
    {
        [self scanSCharSequenceFrom:aScanner into:NULL];
        
        if ([aScanner scanString:NUCDoubleQuotationMark intoString:NULL])
        {
            NSRange aRange = NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation);
            
            [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContent:[[aScanner string] substringWithRange:aRange] range:aRange type:NUCLexicalElementStringLiteralType]];
            
            return YES;
        }
        else
            [aScanner setScanLocation:aScanLocation];
    }
    
    return NO;
}

- (BOOL)scanSCharSequenceFrom:(NSScanner *)aScanner into:(NSString **)aString
{
    NSUInteger aLocation = [aScanner scanLocation];
    NSMutableString *anSCharSequence = [NSMutableString string];
    NSString *anSChars = nil, *anUnescapedSequence = nil;
    
    BOOL aShouldContinueToScan = YES;
    
    while (aShouldContinueToScan)
    {
        if ([aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCSourceCharacterSetExceptDoubleQuoteAndBackslashAndNewline] intoString:&anSChars])
        {
            [anSCharSequence appendString:anSChars];
        }
        else if ([self scanEscapeSequenceFrom:aScanner into:&anUnescapedSequence])
        {
            [anSCharSequence appendString:anUnescapedSequence];
        }
        else
            aShouldContinueToScan = NO;
    }
    
    if (aLocation != [aScanner scanLocation])
    {
        if (aString)
            *aString = [[anSCharSequence copy] autorelease];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)decomposePunctuatorFrom:(NSScanner *)aScanner into:(NSMutableArray *)aPreprocessingTokens
{
    __block BOOL aPunctuatorScand = NO;
    
    [[NUCDecomposedPreprocessingToken NUCPunctuators] enumerateObjectsUsingBlock:^(NSString *  _Nonnull aPunctuator, NSUInteger idx, BOOL * _Nonnull aStop) {
        
        NSUInteger aScanLocation = [aScanner scanLocation];
        
        if ([aScanner scanString:aPunctuator intoString:NULL])
        {
            [aPreprocessingTokens addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContent:aPunctuator range:NSMakeRange(aScanLocation, [aPunctuator length]) type:NUCLexicalElementPunctuatorType]];
            
            *aStop = aPunctuatorScand = YES;
        }
    }];
    
    return aPunctuatorScand;
}

- (BOOL)decomposeWhiteSpaceCharacterFrom:(NSScanner *)aScanner into:(NSMutableArray *)aPreprocessingTokens
{
    if ([self decomposWhitespaceWithoutNewlineFrom:aScanner into:aPreprocessingTokens])
        return YES;
    else if ([self decomposNewlineFrom:aScanner into:aPreprocessingTokens])
        return YES;
    else if ([self decomposeCommentFrom:aScanner into:aPreprocessingTokens])
        return YES;
    else
        return NO;
}

- (BOOL)decomposWhitespaceWithoutNewlineFrom:(NSScanner *)aScanner into:(NSMutableArray *)aPreprocessingTokens
{
    NSUInteger aLocation = [aScanner scanLocation];

    if ([aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCWhiteSpaceWithoutNewlineCharacterSet] intoString:NULL])
    {
        [aPreprocessingTokens addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aLocation, [aScanner scanLocation] - aLocation) type:NUCLexicalElementWhiteSpaceCharacterType]];
        
        return YES;
    }


    return NO;
}

- (BOOL)decomposNewlineFrom:(NSScanner *)aScanner into:(NSMutableArray *)aPreprocessingTokens
{
    NSUInteger aLocation = [aScanner scanLocation];
    NUCDecomposedPreprocessingToken *aToken = nil;
    
    if ([aScanner scanString:NUCLF intoString:NULL] || [aScanner scanString:NUCCRLF intoString:NULL] || [aScanner scanString:NUCCR intoString:NULL])
    {
        aToken = [NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aLocation, [aScanner scanLocation] - aLocation) type:NUCLexicalElementWhiteSpaceCharacterType];
        [aPreprocessingTokens addObject:aToken];
        
        return YES;
    }
        
    return NO;
}

- (BOOL)decomposeCommentFrom:(NSScanner *)aScanner into:(NSMutableArray *)aPreprocessingTokens
{
    NSString *aComment = nil;
    NSUInteger aCommentLocation = NSNotFound;
    
    if ([aScanner scanString:@"/*" intoString:NULL])
    {
        aCommentLocation = [aScanner scanLocation];
        
        [aScanner scanUpToString:@"*/" intoString:&aComment];
        [aScanner scanString:@"*/" intoString:NULL];
    
    }
    else if ([aScanner scanString:@"//" intoString:NULL])
    {
        aCommentLocation = [aScanner scanLocation];
        
        [aScanner scanUpToCharactersFromSet:[NUCDecomposedPreprocessingToken NUCNewlineCharacterSet] intoString:&aComment];
    }

    if (aCommentLocation != NSNotFound)
    {
        [aPreprocessingTokens addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContent:aComment range:NSMakeRange(aCommentLocation, [aComment length]) type:NUCLexicalElementCommentType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)decomposeNonWhiteSpaceCharacterFrom:(NSScanner *)aScanner into:(NSMutableArray *)aPreprocessingTokens
{
    NSRange aRange = [[aScanner string] rangeOfComposedCharacterSequenceAtIndex:[aScanner scanLocation]];
    
    if (aRange.location != NSNotFound)
    {
        [aPreprocessingTokens addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:aRange type:NUCLexicalElementNonWhiteSpaceCharacterType]];
        [aScanner setScanLocation:aRange.location + aRange.length];

        return YES;
    }
    
    return NO;
}

- (BOOL)scanConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    if ([self scanIntegerConstantFrom:aScanner addTo:anElements]
        || [self scanFloatingConstantFrom:aScanner addTo:anElements]
        || [self scanEnumerationConstantFrom:aScanner addTo:anElements]
        || [self decomposeCharacterConstantFrom:aScanner into:anElements])
        return YES;
    else
        return NO;
}

- (BOOL)scanIntegerConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    if ([self scanDecimalConstantFrom:aScanner addTo:anElements]
        || [self scanOctalConstantFrom:aScanner addTo:anElements]
        || [self scanHexadecimalConstantFrom:aScanner addTo:anElements])
    {
        [self scanIntegerSuffixFrom:aScanner addTo:anElements];
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanFloatingConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return [self scanDecimalFloatingConstantFrom:aScanner addTo:anElements]
            || [self scanHexadecimalFloatingConstantFrom:aScanner addTo:anElements];
}

- (BOOL)scanDecimalFloatingConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    
    return NO;
}

- (BOOL)scanHexadecimalFloatingConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    
    return NO;
}

- (BOOL)scanFractionalConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    
    return NO;
}

- (BOOL)scanDigitSequenceFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCDigitCharacterSet] intoString:NULL])
    {
        [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation) type:NUCLexicalElementDigitSequenceType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanEnumerationConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)decomposeCharacterConstantFrom:(NSScanner *)aScanner into:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    [aScanner scanString:NUCLargeL intoString:NULL]
        || [aScanner scanString:NUCSmallU intoString:NULL]
        || [aScanner scanString:NUCLargeU intoString:NULL];
    
    if ([aScanner scanString:NUCSingleQuote intoString:NULL]
        && [self scanCCharSequenceFrom:aScanner]
        && [aScanner scanString:NUCSingleQuote intoString:NULL])
    {
        [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation) type:NUCLexicalElementCharacterConstantType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanCCharSequenceFrom:(NSScanner *)aScanner
{
    return [aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCBasicSourceCharacterSetExceptSingleQuoteAndBackslash] intoString:NULL]
            || [self scanEscapeSequenceFrom:aScanner into:NULL];
}

- (BOOL)scanEscapeSequenceFrom:(NSScanner *)aScanner into:(NSString **)anEscapeSequence
{
    return [self scanSimpleEscapeSequenceFrom:aScanner into:anEscapeSequence]
            || [self scanOctalEscapeSequenceFrom:aScanner]
            || [self scanHexadecimalEscapeSequenceFrom:aScanner]
            || [self scanUniversalCharacterNameFrom:aScanner];
}

- (BOOL)scanSimpleEscapeSequenceFrom:(NSScanner *)aScanner into:(NSString **)anEscapedSequence
{
    NSString *aString = nil;
    
    [aScanner scanString:@"\\\'" intoString:&aString]
        || [aScanner scanString:@"\\\"" intoString:&aString]
        || [aScanner scanString:@"\\\?" intoString:&aString]
        || [aScanner scanString:@"\\\\" intoString:&aString]
        || [aScanner scanString:@"\\\a" intoString:&aString]
        || [aScanner scanString:@"\\\b" intoString:&aString]
        || [aScanner scanString:@"\\\f" intoString:&aString]
        || [aScanner scanString:@"\\\n" intoString:&aString]
        || [aScanner scanString:@"\\\r" intoString:&aString]
        || [aScanner scanString:@"\\\t" intoString:&aString]
        || [aScanner scanString:@"\\\v" intoString:&aString];

    if (aString)
    {
        if (anEscapedSequence)
            *anEscapedSequence = aString;
    
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanOctalEscapeSequenceFrom:(NSScanner *)aScanner
{
    if ([aScanner scanString:NUCBackslash intoString:NULL])
    {
        NSString *aString = [aScanner string];
        NSUInteger aLength = [aString length] - [aScanner scanLocation];
        
        if (aLength > 0)
        {
            if (aLength > 3) aLength = 3;
            
            NSRange aRange = [aString rangeOfCharacterFromSet:[NUCDecomposedPreprocessingToken NUCOctalDigitCharacterSet] options:0 range:NSMakeRange([aScanner scanLocation], aLength)];
            
            if (aRange.location != NSNotFound)
            {
                [aScanner setScanLocation:[aScanner scanLocation] + aRange.length];
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)scanHexadecimalEscapeSequenceFrom:(NSScanner *)aScanner
{
    if ([aScanner scanString:@"\\x" intoString:NULL])
    {
        if ([aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCHexadecimalDigitCharacterSet] intoString:NULL])
            return YES;
    }
    
    return NO;
}

- (BOOL)scanUniversalCharacterNameFrom:(NSScanner *)aScanner
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([aScanner scanString:@"\\u" intoString:NULL])
    {
        if ([self scanHexQuadFrom:aScanner])
            return YES;
        else
        {
            [aScanner setScanLocation:aScanLocation];
            return NO;
        }
    }
    else if ([aScanner scanString:@"\\U" intoString:NULL])
    {
        if ([self scanHexQuadFrom:aScanner] && [self scanHexQuadFrom:aScanner])
            return YES;
        else
        {
            [aScanner setScanLocation:aScanLocation];
            return NO;
        }
    }
    else
        return NO;
}

- (BOOL)scanHexQuadFrom:(NSScanner *)aScanner
{
    if ([[aScanner string] length] - [aScanner scanLocation] >= 4)
    {
        NSRange aHexdecimalDigitRange = [[aScanner string] rangeOfCharacterFromSet:[NUCDecomposedPreprocessingToken NUCHexadecimalDigitCharacterSet] options:0 range:NSMakeRange([aScanner scanLocation], 4)];
        
        if (aHexdecimalDigitRange.length == 4)
            return YES;
    }
    
    return NO;
}

- (BOOL)scanDecimalConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([self scanNonzeroDigitFrom:aScanner])
    {
        NSRange aRange;
        
        [self scanDigitFrom:aScanner];
        
        aRange = NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation);
        [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:aRange type:NUCLexicalElementIntegerConstantType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanIntegerSuffixFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    if ([self scanUnsignedSuffixFrom:aScanner addTo:anElements])
    {
        if ([self scanLongLongSuffixFrom:aScanner addTo:anElements])
            return YES;
        else
        {
            [self scanLongSuffixFrom:aScanner addTo:anElements];
            return YES;
        }
    }
    else if ([self scanLongLongSuffixFrom:aScanner addTo:anElements])
    {
        [self scanUnsignedSuffixFrom:aScanner addTo:anElements];
        return YES;
    }
    else if ([self scanLongSuffixFrom:aScanner addTo:anElements])
    {
        [self scanUnsignedSuffixFrom:aScanner addTo:anElements];
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanUnsignedSuffixFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([aScanner scanString:NUCUnsignedSuffixSmall intoString:NULL]
            || [aScanner scanString:NUCUnsignedSuffixLarge intoString:NULL])
    {
        [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aScanLocation, 1) type:NUCLexicalElementUnsignedSuffixType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanLongSuffixFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([aScanner scanString:NUCLongSuffixSmall intoString:NULL]
            || [aScanner scanString:NUCLongSuffixLarge intoString:NULL])
    {
        [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aScanLocation, 1) type:NUCLexicalElementLongSuffixType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanLongLongSuffixFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([aScanner scanString:NUCLongLongSuffixSmall intoString:NULL]
            || [aScanner scanString:NUCLongLongSuffixLarge intoString:NULL])
    {
        [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aScanLocation, 2) type:NUCLexicalElementLongLongSuffixType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanOctalConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([aScanner scanString:NUCOctalDigitZero intoString:NULL])
    {
        if ([aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCOctalDigitCharacterSet] intoString:NULL])
        {
            [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation) type:NUCLexicalElementOctalConstantType]];
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)scanHexadecimalConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanNonzeroDigitFrom:(NSScanner *)aScanner
{
    return [aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCNonzeroDigitCharacterSet] intoString:NULL];
}

- (BOOL)scanNondigitFrom:(NSScanner *)aScanner
{
    return [aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCNondigitCharacterSet] intoString:NULL];
}

- (BOOL)scanDigitFrom:(NSScanner *)aScanner
{
    return [aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCDigitCharacterSet] intoString:NULL];
}

- (BOOL)scanPeriodFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCPeriod intoString:NULL];
}

- (BOOL)scanElifGroupsFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCElifGroups **)aToken
{
    NUCElifGroups *anElifGroups = [NUCElifGroups elifGroups];
    NUCElifGroup *anElifGroup = nil;
    
    while ([self scanElifGroupFrom:aPreprocessingTokenStream into:&anElifGroup])
        [anElifGroups add:anElifGroup];

    if (aToken && [anElifGroups count])
        *aToken = anElifGroups;
    
    return [anElifGroups count] ? YES : NO;
}

- (BOOL)scanElifGroupFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCElifGroup **)anElifGroup
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    [aPreprocessingTokenStream skipWhitespaces];
    NUCDecomposedPreprocessingToken *aToken = [aPreprocessingTokenStream next];
    
    if (aToken && [aToken isHash])
    {
        NUCLexicalElement *aConstantExpression = nil;
        
        if ([aPreprocessingTokenStream skipWhitespacesWithoutNewline])
        {
            NUCDecomposedPreprocessingToken *anElif = [aPreprocessingTokenStream next];
            if ([[anElif content] isEqualToString:NUCPreprocessingDirectiveElif])
            {
                if ([self scanConstantExpressionFrom:aPreprocessingTokenStream into:&aConstantExpression])
                {
                    NUCNewline *aNewline = nil;
                    [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
                    
                    if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
                    {
                        NUCGroup *aGroup = nil;
                        [self scanGroupFrom:aPreprocessingTokenStream into:&aGroup];
                        
                        if (anElifGroup)
                            *anElifGroup = [NUCElifGroup elifGroupWithType:NUCLexicalElementElifGroup hash:aToken directiveName:anElif expressionOrIdentifier:aConstantExpression newline:aNewline group:aGroup];
                    }
                    
                    return YES;
                }
            }
        }
    }

    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (BOOL)scanElseGroupFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCElseGroup **)anElseGroup
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    NUCDecomposedPreprocessingToken *aToken = [aPreprocessingTokenStream next];
    
    if (aToken && [aToken isHash])
    {
        NUCDecomposedPreprocessingToken *aHash = aToken;
        NUCNewline *aNewline = nil;
        NUCDecomposedPreprocessingToken *anElse = [aPreprocessingTokenStream next];
        
        if (anElse && [[anElse content] isEqualToString:NUCPreprocessingDirectiveElse])
        {
            if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
            {
                NUCGroup *aGroup = nil;
                [self scanGroupFrom:aPreprocessingTokenStream into:&aGroup];
                
                if (anElseGroup)
                {
                    *anElseGroup = [NUCElseGroup elseGroupWithHash:aHash directiveName:anElse newline:aNewline group:aGroup];
                }
                
                return YES;
            }
        }
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (BOOL)scanEndifLineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPreprocessingDirective **)anEndifLine
{
    NSUInteger aPosition = [aPreprocessingTokenStream position];
    [aPreprocessingTokenStream skipWhitespaces];
    NUCDecomposedPreprocessingToken *aToken = [aPreprocessingTokenStream next];
    
    if (aToken && [aToken isHash])
    {
        NUCDecomposedPreprocessingToken *aHash = aToken;
        NUCDecomposedPreprocessingToken *anEndif = [aPreprocessingTokenStream next];
        
        if (anEndif && [[anEndif content] isEqualToString:NUCPreprocessingDirectiveEndif])
        {
            NUCNewline *aNewline = nil;
            if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
            {
                if (anEndif)
                    *anEndifLine = [NUCEndifLine endifLineWithHash:aHash endif:anEndif newline:aNewline];
                
                return YES;
            }
        }
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (NSString *)preprocessPhase1:(NSString *)aPhysicalSourceString forSourceFile:(NUCSourceFile *)aSourceFile rangeMappingFromPhase1ToPhysicalSourceString:(NULibrary *)aRangeMappingFromPhase1ToPhysicalSourceString
{
    NSMutableString *aLogicalSourceStringInPhase1 = [NSMutableString string];
    NSScanner *aScanner = [NSScanner scannerWithString:aPhysicalSourceString];
    [aScanner setCharactersToBeSkipped:nil];
    NSString *aScannedString = nil;
    
    while (![aScanner isAtEnd])
    {
        NSUInteger aScanLocation = [aScanner scanLocation];
        
        if ([aScanner scanString:NUCTrigraphSequenceBeginning intoString:NULL])
        {
            if ([aScanner scanString:NUCTrigraphSequenceEqual intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceHash];
            else if ([aScanner scanString:NUCTrigraphSequenceLeftBlacket intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceLeftSquareBracket];
            else if ([aScanner scanString:NUCTrigraphSequenceSlash intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceBackslash];
            else if ([aScanner scanString:NUCTrigraphSequenceRightBracket intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceRightSquareBracket];
            else if ([aScanner scanString:NUCTrigraphSequenceApostrophe intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceCircumflex];
            else if ([aScanner scanString:NUCTrigraphSequenceLeftLessThanSign intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceLeftCurlyBracket];
            else if ([aScanner scanString:NUCTrigraphSequenceQuestionMark intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceVerticalbar];
            else if ([aScanner scanString:NUCTrigraphSequenceGreaterThanSign intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceRightCurlyBracket];
            else if ([aScanner scanString:NUCTrigraphSequenceHyphen intoString:NULL])
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceTilde];
            else
                [aLogicalSourceStringInPhase1 appendString:NUCTrigraphSequenceBeginning];
            
            if (aScanLocation != [aScanner scanLocation])
            {
                NUCRangePair *aRangePair = [NUCRangePair rangePairWithRangeFrom:NUMakeRegion([aLogicalSourceStringInPhase1 length], 1) rangeTo:NUMakeRegion(aScanLocation, 3)];
                
                [aRangeMappingFromPhase1ToPhysicalSourceString setObject:aRangePair forKey:aRangePair];
            }
        }
        else if ([aScanner scanUpToString:NUCTrigraphSequenceBeginning intoString:&aScannedString])
        {
            [aLogicalSourceStringInPhase1 appendString:aScannedString];
        }
    }
    
    return aLogicalSourceStringInPhase1;
}

- (NSString *)preprocessPhase2:(NSString *)aLogicalSourceStringInPhase1 forSourceFile:(NUCSourceFile *)aSourceFile rangeMappingFromPhase2StringToPhase1String:(NULibrary *)aRangeMappingFromPhase2StringToPhase1String
{
    NSMutableString *aLogicalSourceStringInPhase2 = [NSMutableString string];
    NSScanner *aScanner = [NSScanner scannerWithString:aLogicalSourceStringInPhase1];
    [aScanner setCharactersToBeSkipped:nil];
    NSString *aScannedString = nil;
    
    while (![aScanner isAtEnd])
    {
        NSUInteger aScanLocation = [aScanner scanLocation];
        
        if ([aScanner scanString:NUCBackslash intoString:NULL])
        {
            NSString *aNewLineString = nil;
            
            if ([aScanner scanString:NUCCRLF intoString:&aNewLineString]
                  || [aScanner scanString:NUCLF intoString:&aNewLineString]
                  || [aScanner scanString:NUCCR intoString:&aNewLineString])
            {
                NUCRangePair *aRangePair = [NUCRangePair rangePairWithRangeFrom:NUMakeRegion([aLogicalSourceStringInPhase2 length], 0) rangeTo:NUMakeRegion(aScanLocation, 1 + [aNewLineString length])];
                
                id anExistingObject = [aRangeMappingFromPhase2StringToPhase1String objectForKey:aRangePair];
                
                if (anExistingObject)
                {
                    if ([anExistingObject isKindOfClass:[NUCRangePair class]])
                    {
                        NSMutableArray *anArray = [NSMutableArray array];
                        [aRangeMappingFromPhase2StringToPhase1String setObject:anArray forKey:anExistingObject];
                        anExistingObject = anArray;
                    }
                    
                    [(NSMutableArray *)anExistingObject addObject:aRangePair];
                }
                else
                    [aRangeMappingFromPhase2StringToPhase1String setObject:aRangePair forKey:aRangePair];
            }
            else
            {
                [aLogicalSourceStringInPhase2 appendString:NUCBackslash];
            }
        }
        else if ([aScanner scanUpToString:NUCBackslash intoString:&aScannedString])
        {
            [aLogicalSourceStringInPhase2 appendString:aScannedString];
        }
    }
    
    return aLogicalSourceStringInPhase2;
}

- (BOOL)decomposeHeaderNameFrom:(NSScanner *)aScanner into:(NSMutableArray *)anElements
{
    if ([self decomposeHeaderNameFrom:aScanner beginWith:NUCLessThanSign endWith:NUCGreaterThanSign characterSet:[NUCDecomposedPreprocessingToken NUCHCharCharacterSet] isHChar:YES into:anElements])
        return YES;
    else if ([self decomposeHeaderNameFrom:aScanner beginWith:NUCDoubleQuotationMark endWith:NUCDoubleQuotationMark characterSet:[NUCDecomposedPreprocessingToken NUCQCharCharacterSet] isHChar:NO into:anElements])
        return YES;
    else
        return NO;
}

- (BOOL)decomposeHeaderNameFrom:(NSScanner *)aScanner beginWith:(NSString *)aBeginChar endWith:(NSString *)anEndChar characterSet:(NSCharacterSet *)aCharacterSet isHChar:(BOOL)anIsHChar into:(NSMutableArray *)anElements
{
    NSUInteger aScanlocation = [aScanner scanLocation];
    
    if ([aScanner scanString:aBeginChar intoString:NULL])
    {
        if ([aScanner scanCharactersFromSet:aCharacterSet intoString:NULL])
        {
            if ([aScanner scanString:anEndChar intoString:NULL])
            {
                NUCLexicalElementType anElementType;

                [anElements addObject:[NUCHeaderName preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aScanlocation + [aBeginChar length], [aScanner scanLocation] - [anEndChar length]) isHChar:anIsHChar]];
                
                if (anIsHChar)
                    anElementType = NUCLexicalElementLessThanSignType;
                else
                    anElementType = NUCLexicalElementDoubleQuotationMarkType;
                
                [anElements addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange([aScanner scanLocation] - [anEndChar length], [anEndChar length]) type:anElementType]];
                
                return YES;
            }
        }
    }
    
    [aScanner setScanLocation:aScanlocation];
    
    return NO;
}

@end
