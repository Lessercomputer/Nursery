//
//  NUCDecomposer.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/05/15.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCDecomposer.h"
#import "NUCSourceFile.h"
#import "NUCLexicalElement.h"
#import "NUCDecomposedPreprocessingToken.h"
#import "NUCHeaderName.h"

#import <Foundation/NSString.h>
#import <Foundation/NSScanner.h>
#import <Foundation/NSArray.h>


@implementation NUCDecomposer

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

- (BOOL)scanIdentifierNondigitFrom:(NSScanner *)aScanner
{
    return [self scanNondigitFrom:aScanner];
}

- (BOOL)scanDigitFrom:(NSScanner *)aScanner
{
    return [aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCDigitCharacterSet] intoString:NULL];
}

- (BOOL)scanNondigitFrom:(NSScanner *)aScanner
{
    return [aScanner scanCharactersFromSet:[NUCDecomposedPreprocessingToken NUCNondigitCharacterSet] intoString:NULL];
}

- (BOOL)scanPeriodFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCPeriod intoString:NULL];
}

- (BOOL)scanSmallEFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCSmallE intoString:NULL];
}

- (BOOL)scanLargeEFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCLargeE intoString:NULL];
}

- (BOOL)scanSignFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCPlusSign intoString:NULL]
            || [aScanner scanString:NUCMinusSign intoString:NULL];
}

- (BOOL)scanSmallPFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCSmallP intoString:NULL];
}

- (BOOL)scanLargePFrom:(NSScanner *)aScanner
{
    return [aScanner scanString:NUCLargeP intoString:NULL];
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

@end
