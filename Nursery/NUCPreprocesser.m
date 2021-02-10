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
#import "NUCGroup.h"
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
    
    [self decomposePreprocessingFile:aSourceFile];
}

- (void)decomposePreprocessingFile:(NUCSourceFile *)aSourceFile
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
    
    NSMutableArray *aNonwhitespaces = [NSMutableArray array];
    
    [aPreprocessingTokens enumerateObjectsUsingBlock:^(NUCDecomposedPreprocessingToken * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj type] == NUCLexicalElementNonWhiteSpaceCharacterType)
            [aNonwhitespaces addObject:obj];
    }];
    NSLog(@"%@", aNonwhitespaces);
}

- (BOOL)scanPreprocessingFileFrom:(NSArray *)aPreprocessingTokens
{
    NUCPreprocessingTokenStream *aPreprocessingTokenStream = [NUCPreprocessingTokenStream preprecessingTokenStreamWithPreprocessingTokens:aPreprocessingTokens];
    NUCGroup *aGroup = nil;

    return [self scanGroupFrom:aPreprocessingTokenStream into:&aGroup];
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
    if ([self scanIfSectionFrom:aPreprocessingTokenStream into:aGroupPart])
        return YES;
    else if ([self scanControlLineFrom:aPreprocessingTokenStream into:aGroupPart])
        return YES;
    else if ([self scanTextLineFrom:aPreprocessingTokenStream into:aGroupPart])
        return YES;
    else if ([self scanHashAndNonDirectiveFrom:aPreprocessingTokenStream into:aGroupPart])
        return YES;
    else
        return NO;
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
        }
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
    return NO;
}

- (BOOL)scanTextLineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPreprocessingDirective **)aToken
{
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
        NUCPpTokens *aPpTokens = nil;
        NUCNewline *aNewline = nil;
        
        [aPreprocessingTokenStream skipWhitespacesWithoutNewline];
        
        if ([self scanPpTokensFrom:aPreprocessingTokenStream into:&aPpTokens])
        {
            if ([self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
            {
                if (aToken)
                    *aToken = [NUCNonDirective noneDirectiveWithHash:aPpToken ppTokens:aPpTokens newline:aNewline];
                
                return YES;
            }
        }
    }
    
    [aPreprocessingTokenStream setPosition:aPosition];
    
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
        
        if ([aPreprocessingTokenStream skipWhitespacesWithoutNewline]
                && (aToken = [aPreprocessingTokenStream next]))
        {
            NSString *anIfGroupTypeString = [aToken content];
            NUCLexicalElementType anIfGroupType = NUCLexicalElementNone;
            NUCDecomposedPreprocessingToken *aTypeName = aToken;
            NUCLexicalElement *anExpressionOrIdentifier = nil;
            NUCNewline *aNewline = nil;
            NUCGroup *aGroup = nil;
            
            if ([anIfGroupTypeString isEqualToString:NUCPreprocessingDirectiveIf])
            {
                anIfGroupType = NUCLexicalElementIfType;
                
                if ([aPreprocessingTokenStream skipWhitespacesWithoutNewline]
                        &&[self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
                    [self scanConstantExpressionFrom:aPreprocessingTokenStream into:&anExpressionOrIdentifier];
            }
            else if ([anIfGroupTypeString isEqualToString:NUCPreprocessingDirectiveIfdef])
            {
                anIfGroupType = NUCLexicalElementIfdefType;
                
                if ([aPreprocessingTokenStream skipWhitespacesWithoutNewline]
                        && [self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
                    anExpressionOrIdentifier = [aPreprocessingTokenStream next];
            }
            else if ([anIfGroupTypeString isEqualToString:NUCPreprocessingDirectiveIfndef])
            {
                anIfGroupType = NUCLexicalElementIfndefType;
                
                if ([aPreprocessingTokenStream skipWhitespacesWithoutNewline]
                        && [self scanNewlineFrom:aPreprocessingTokenStream into:&aNewline])
                    anExpressionOrIdentifier = [aPreprocessingTokenStream next];
            }
            
            if (aHash && anExpressionOrIdentifier && aNewline)
            {
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

- (BOOL)scanConstantExpressionFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCLexicalElement **)aConstantExpression
{
    
    return NO;
}

- (BOOL)scanConditionalExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanLogicalOrExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanLogicalAndExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanInclusiveOrExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanExclusiveOrExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanAndExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanEqualityExpresionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanEqualityExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanRelationalExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanShiftExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanAdditiveExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    
    return NO;
}

- (BOOL)scanMultiplicativeExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanCastExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanUnaryExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanPostfixExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanPrimaryExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    
    return NO;
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
    NSUInteger aLocation = [aScanner scanLocation];
    
    [aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCWhiteSpaceCharacterSet] intoString:NULL];
    
    if ([aScanner scanLocation] != aLocation)
        [aPreprocessingTokens addObject:[NUCDecomposedPreprocessingToken preprocessingTokenWithContentFromString:[aScanner string] range:NSMakeRange(aLocation, [aScanner scanLocation] - aLocation) type:NUCLexicalElementWhiteSpaceCharacterType]];
    
    [self decomposeCommentFrom:aScanner into:aPreprocessingTokens];
    
    return [aScanner scanLocation] != aLocation;
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
