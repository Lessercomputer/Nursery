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
        [self decomposeHeaderNameFrom:aScanner into:aPreprocessingTokens];
        [self scanPpNumberFrom:aScanner addTo:aPreprocessingTokens];
        [self scanCharacterConstantFrom:aScanner addTo:aPreprocessingTokens];
        [self scanStringLiteralFrom:aScanner addTo:aPreprocessingTokens];
        [self scanPunctuatorFrom:aScanner addTo:aPreprocessingTokens];
        [self scanCommentFrom:aScanner];
        [aScanner scanCharactersFromSet:[NUCLexicalElement NUCBasicSourceCharacterSetExceptSingleQuoteAndBackslash] intoString:NULL];
    }
}

- (BOOL)scanGroupFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    BOOL anElementWasScanned = NO;
    
    while (YES)
    {
        if ([self scanGroupPartFrom:aScanner addTo:anElements])
            anElementWasScanned = YES;
        else
            break;
    }
    
    return anElementWasScanned;
}

- (BOOL)scanGroupPartFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    if ([self scanIfSectionFrom:aScanner addTo:anElements])
        return YES;
    else if ([self scanControlLineFrom:aScanner addTo:anElements])
        return YES;
    else if ([self scanTextLineFrom:aScanner addTo:anElements])
        return YES;
    else if ([self scanHashAndNonDirectiveFrom:aScanner addTo:anElements])
        return YES;
    else
        return NO;
}

- (BOOL)scanIfSectionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    if ([self scanIfGroupFrom:aScanner addTo:anElements])
    {
        [self scanElifGroupsFrom:aScanner addTo:anElements];
        [self scanElseGroupFrom:aScanner addTo:anElements];
        if ([self scanEndifLineFrom:aScanner addTo:anElements])
            return YES;
    }
    
    return NO;
}

- (BOOL)scanControlLineFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanTextLineFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanHashAndNonDirectiveFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanIfGroupFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([aScanner scanString:NUCHashIf intoString:NULL])
    {
        
    }
    
    return NO;
}

- (BOOL)scanConstantExpressionFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
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

- (BOOL)scanIdentifierFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    if ([self scanIdentifierNondigitFrom:aScanner])
    {
        while ([self scanDigitFrom:aScanner] || [self scanIdentifierNondigitFrom:aScanner]);
    }
    
    if (aScanLocation != [aScanner scanLocation])
    {
        NSRange anIdentifierRange = NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation);
        
        [anElements addObject:[NUCLexicalElement lexicalElementWithRange:anIdentifierRange type:NUCLexicalElementIdentifierType]];
        
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

- (BOOL)scanPpNumberFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    BOOL aCharacterWasScanned = NO;
    
    do
    {
        if ([self scanDigitFrom:aScanner])
            aCharacterWasScanned = YES;
        else if ([self scanPeriodFrom:aScanner])
            aCharacterWasScanned = YES;
        else if ([self scanIdentifierNondigitFrom:aScanner])
            aCharacterWasScanned = YES;
        else if ([self scanSmallEFrom:aScanner] || [self scanLargeEFrom:aScanner])
        {
            [self scanSignFrom:aScanner];
            aCharacterWasScanned = YES;
        }
        else if ([self scanSmallPFrom:aScanner] || [self scanLargePFrom:aScanner])
        {
            [self scanSignFrom:aScanner];
            aCharacterWasScanned = YES;
        }
    }
    while (aCharacterWasScanned);
    
    if ([aScanner scanLocation] != aScanLocation)
    {
        [anElements addObject:[NUCLexicalElement lexicalElementWithRange:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation) type:NUCLexicalElementPpNumberType]];
        
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

- (BOOL)scanStringLiteralFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    [aScanner scanString:NUCStringLiteralEncodingPrefixSmallU8 intoString:NULL]
        || [aScanner scanString:NUCStringLiteralEncodingPrefixSmallU intoString:NULL]
        || [aScanner scanString:NUCStringLiteralEncodingPrefixLargeU intoString:NULL]
        || [aScanner scanString:NUCStringLiteralEncodingPrefixLargeL intoString:NULL];
    
    if ([aScanner scanString:NUCDoubleQuotationMark intoString:NULL])
    {
        [self scanSCharSequenceFrom:aScanner addTo:anElements];
        
        if ([aScanner scanString:NUCDoubleQuotationMark intoString:NULL])
            return YES;
        else
            [aScanner setScanLocation:aScanLocation];
    }
    
    return NO;
}

- (BOOL)scanSCharSequenceFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)aTokens
{
    return NO;
}

- (BOOL)scanPunctuatorFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanCommentFrom:(NSScanner *)aScanner
{
    return NO;
}

- (BOOL)scanConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    if ([self scanIntegerConstantFrom:aScanner addTo:anElements]
        || [self scanFloatingConstantFrom:aScanner addTo:anElements]
        || [self scanEnumerationConstantFrom:aScanner addTo:anElements]
        || [self scanCharacterConstantFrom:aScanner addTo:anElements])
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
    
    if ([aScanner scanCharactersFromSet:[NUCLexicalElement NUCDigitCharacterSet] intoString:NULL])
    {
        [anElements addObject:[NUCLexicalElement lexicalElementWithRange:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation) type:NUCLexicalElementDigitSequenceType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanEnumerationConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanCharacterConstantFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    NSUInteger aScanLocation = [aScanner scanLocation];
    
    [aScanner scanString:NUCLargeL intoString:NULL]
        || [aScanner scanString:NUCSmallU intoString:NULL]
        || [aScanner scanString:NUCLargeU intoString:NULL];
    
    if ([aScanner scanString:NUCSingleQuote intoString:NULL]
        && [self scanCCharSequenceFrom:aScanner]
        && [aScanner scanString:NUCSingleQuote intoString:NULL])
    {
        [anElements addObject:[NUCLexicalElement lexicalElementWithRange:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation) type:NUCLexicalElementCharacterConstantType]];
        
        return YES;
    }
    else
        return NO;
}

- (BOOL)scanCCharSequenceFrom:(NSScanner *)aScanner
{
    return [aScanner scanCharactersFromSet:[NUCLexicalElement NUCBasicSourceCharacterSetExceptSingleQuoteAndBackslash] intoString:NULL]
            || [self scanEscapeSequenceFrom:aScanner];
}

- (BOOL)scanEscapeSequenceFrom:(NSScanner *)aScanner
{
    return [self scanSimpleEscapeSequenceFrom:aScanner]
            || [self scanOctalEscapeSequenceFrom:aScanner]
            || [self scanHexadecimalEscapeSequenceFrom:aScanner]
            || [self scanUniversalCharacterNameFrom:aScanner];
}

- (BOOL)scanSimpleEscapeSequenceFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:@"\'" intoString:NULL]
            || [aScanner scanString:@"\"" intoString:NULL]
            || [aScanner scanString:@"\?" intoString:NULL]
            || [aScanner scanString:@"\\" intoString:NULL]
            || [aScanner scanString:@"\a" intoString:NULL]
            || [aScanner scanString:@"\b" intoString:NULL]
            || [aScanner scanString:@"\f" intoString:NULL]
            || [aScanner scanString:@"\n" intoString:NULL]
            || [aScanner scanString:@"\r" intoString:NULL]
            || [aScanner scanString:@"\t" intoString:NULL]
            || [aScanner scanString:@"\v" intoString:NULL];
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
            
            NSRange aRange = [aString rangeOfCharacterFromSet:[NUCLexicalElement NUCOctalDigitCharacterSet] options:0 range:NSMakeRange([aScanner scanLocation], aLength)];
            
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
        if ([aScanner scanCharactersFromSet:[NUCLexicalElement NUCHexadecimalDigitCharacterSet] intoString:NULL])
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
        NSRange aHexdecimalDigitRange = [[aScanner string] rangeOfCharacterFromSet:[NUCLexicalElement NUCHexadecimalDigitCharacterSet] options:0 range:NSMakeRange([aScanner scanLocation], 4)];
        
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
        [anElements addObject:[NUCLexicalElement lexicalElementWithRange:aRange type:NUCLexicalElementIntegerConstantType]];
        
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
        [anElements addObject:[NUCLexicalElement lexicalElementWithRange:NSMakeRange(aScanLocation, 1) type:NUCLexicalElementUnsignedSuffixType]];
        
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
        [anElements addObject:[NUCLexicalElement lexicalElementWithRange:NSMakeRange(aScanLocation, 1) type:NUCLexicalElementLongSuffixType]];
        
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
        [anElements addObject:[NUCLexicalElement lexicalElementWithRange:NSMakeRange(aScanLocation, 2) type:NUCLexicalElementLongLongSuffixType]];
        
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
        if ([aScanner scanCharactersFromSet:[NUCLexicalElement NUCOctalDigitCharacterSet] intoString:NULL])
        {
            [anElements addObject:[NUCLexicalElement lexicalElementWithRange:NSMakeRange(aScanLocation, [aScanner scanLocation] - aScanLocation) type:NUCLexicalElementOctalConstantType]];
            
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
    return [aScanner scanCharactersFromSet:[NUCLexicalElement NUCNonzeroDigitCharacterSet] intoString:NULL];
}

- (BOOL)scanNondigitFrom:(NSScanner *)aScanner
{
    return [aScanner scanCharactersFromSet:[NUCLexicalElement NUCDigitCharacterSet] intoString:NULL];
}

- (BOOL)scanDigitFrom:(NSScanner *)aScanner
{
    return [aScanner scanCharactersFromSet:[NUCLexicalElement NUCDigitCharacterSet] intoString:NULL];
}

- (BOOL)scanPeriodFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCPeriod intoString:NULL];
}

- (BOOL)scanElifGroupsFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanElseGroupFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
    return NO;
}

- (BOOL)scanEndifLineFrom:(NSScanner *)aScanner addTo:(NSMutableArray *)anElements
{
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
    if ([self decomposeHeaderNameFrom:aScanner beginWith:NUCLessThanSign endWith:NUCGreaterThanSign characterSet:[NUCLexicalElement NUCHCharCharacterSet] isHChar:YES into:anElements])
        return YES;
    else if ([self decomposeHeaderNameFrom:aScanner beginWith:NUCDoubleQuotationMark endWith:NUCDoubleQuotationMark characterSet:[NUCLexicalElement NUCQCharCharacterSet] isHChar:NO into:anElements])
        return YES;
    else
        return NO;
}

- (BOOL)decomposeHeaderNameFrom:(NSScanner *)aScanner beginWith:(NSString *)aBeginChar endWith:(NSString *)anEndChar characterSet:(NSCharacterSet *)aCharacterSet isHChar:(BOOL)anIsHChar into:(NSMutableArray *)anElements
{
    NSUInteger aScanlocation = [aScanner scanLocation];
    
    if ([aScanner scanString:aBeginChar intoString:NULL])
    {
        NUCLexicalElementType anElementType;
        
        if (anIsHChar)
            anElementType = NUCLexicalElementGreaterThanSignType;
        else
            anElementType = NUCLexicalElementDoubleQuotationMarkType;
        
        [anElements addObject:[NUCLexicalElement lexicalElementWithRange:NSMakeRange(aScanlocation, [aBeginChar length]) type:anElementType]];
        
        if ([aScanner scanCharactersFromSet:aCharacterSet intoString:NULL])
        {
            if ([aScanner scanString:anEndChar intoString:NULL])
            {
                [anElements addObject:[NUCHeaderName lexicalElementWithRange:NSMakeRange(aScanlocation + [aBeginChar length], [aScanner scanLocation] - [anEndChar length]) isHChar:anIsHChar]];
                
                if (anIsHChar)
                    anElementType = NUCLexicalElementLessThanSignType;
                else
                    anElementType = NUCLexicalElementDoubleQuotationMarkType;
                
                [anElements addObject:[NUCLexicalElement lexicalElementWithRange:NSMakeRange([aScanner scanLocation] - [anEndChar length], [anEndChar length]) type:anElementType]];
                
                return YES;
            }
        }
    }
    
    [aScanner setScanLocation:aScanlocation];
    
    return NO;
}

@end
