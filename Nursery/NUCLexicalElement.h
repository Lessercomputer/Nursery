//
//  NUCLexicalElement.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

#import <Nursery/NURegion.h>

@class NSString;

extern NSString * const NUCBasicSourceCharacters;
extern NSString * const NUCBasicSourceCharactersExceptSingleQuoteAndBackslash;
extern NSString * const NUCLF;
extern NSString * const NUCCRLF;
extern NSString * const NUCCR;
extern NSString * const NUCBackslash;
extern NSString * const NUCLessThanSign;
extern NSString * const NUCGreaterThanSign;
extern NSString * const NUCDoubleQuotationMark;
extern NSString * const NUCHash;
extern NSString * const NUCHashIf;
extern NSString * const NUCHashIfdef;
extern NSString * const NUCHashIfndef;

extern NSString * const NUCTrigraphSequenceEqual;
extern NSString * const NUCTrigraphSequenceLeftBlacket;
extern NSString * const NUCTrigraphSequenceSlash;
extern NSString * const NUCTrigraphSequenceRightBracket;
extern NSString * const NUCTrigraphSequenceApostrophe;
extern NSString * const NUCTrigraphSequenceLeftLessThanSign;
extern NSString * const NUCTrigraphSequenceQuestionMark;
extern NSString * const NUCTrigraphSequenceGreaterThanSign;
extern NSString * const NUCTrigraphSequenceHyphen;

extern NSString * const NUCTrigraphSequenceBeginning;

extern NSString * const NUCTrigraphSequenceHash;
extern NSString * const NUCTrigraphSequenceLeftSquareBracket;
extern NSString * const NUCTrigraphSequenceBackslash;
extern NSString * const NUCTrigraphSequenceRightSquareBracket;
extern NSString * const NUCTrigraphSequenceCircumflex;
extern NSString * const NUCTrigraphSequenceLeftCurlyBracket;
extern NSString * const NUCTrigraphSequenceVerticalbar;
extern NSString * const NUCTrigraphSequenceRightCurlyBracket;
extern NSString * const NUCTrigraphSequenceTilde;

extern NSString * const NUCIdentifierNondigit;
extern NSString * const NUCIdentifierDigit;

extern NSString * const NUCNonzeroDigits;
extern NSString * const NUCDigits;
extern NSString * const NUCPeriod;
extern NSString * const NUCSmallE;
extern NSString * const NUCLargeE;
extern NSString * const NUCSmallP;
extern NSString * const NUCLargeP;
extern NSString * const NUCPlusSign;
extern NSString * const NUCMinusSign;
extern NSString * const NUCOctalDigitZero;
extern NSString * const NUCOctalDigits;
extern NSString * const NUCHexadecimalDigits;
extern NSString * const NUCUnsignedSuffixSmall;
extern NSString * const NUCUnsignedSuffixLarge;
extern NSString * const NUCLongSuffixSmall;
extern NSString * const NUCLongSuffixLarge;
extern NSString * const NUCLongLongSuffixSmall;
extern NSString * const NUCLongLongSuffixLarge;
extern NSString * const NUCSingleQuote;
extern NSString * const NUCLargeL;
extern NSString * const NUCSmallU;
extern NSString * const NUCLargeU;

extern NSString * const NUCStringLiteralEncodingPrefixSmallU8;
extern NSString * const NUCStringLiteralEncodingPrefixSmallU;
extern NSString * const NUCStringLiteralEncodingPrefixLargeU;
extern NSString * const NUCStringLiteralEncodingPrefixLargeL;

typedef enum : NSUInteger {
    NUCLexicalElementGroupType,
    NUCLexicalElementGroupPartType,
    NUCLexicalElementHeaderNameType,
    NUCLexicalElementLessThanSignType,
    NUCLexicalElementGreaterThanSignType,
    NUCLexicalElementDoubleQuotationMarkType,
    NUCLexicalElementIdentifierType,
    NUCLexicalElementIntegerConstantType,
    NUCLexicalElementUnsignedSuffixType,
    NUCLexicalElementLongSuffixType,
    NUCLexicalElementLongLongSuffixType,
    NUCLexicalElementOctalConstantType,
    NUCLexicalElementPpNumberType,
    NUCLexicalElementDigitSequenceType,
    NUCLexicalElementCharacterConstantType
} NUCLexicalElementType;

@interface NUCLexicalElement : NSObject
{
    NUCLexicalElementType type;
    NSString *content;
    NURegion range;
}

+ (instancetype)lexicalElementWithContent:(NSString *)aContent range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

+ (instancetype)lexicalElementWithRange:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

+ (instancetype)lexicalElementWithContent:(NSString *)aContent region:(NURegion)aRange type:(NUCLexicalElementType)anElementType;

- (instancetype)initWithRange:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

- (instancetype)initWithContent:(NSString *)aContent region:(NURegion)aRange type:(NUCLexicalElementType)anElementType;

+ (NSCharacterSet *)NUCBasicSourceCharacterSetExceptSingleQuoteAndBackslash;
+ (NSCharacterSet *)NUCHCharCharacterSet;
+ (NSCharacterSet *)NUCQCharCharacterSet;
+ (NSCharacterSet *)NUCNonzeroDigitCharacterSet;
+ (NSCharacterSet *)NUCDigitCharacterSet;
+ (NSCharacterSet *)NUCOctalDigitCharacterSet;
+ (NSCharacterSet *)NUCHexadecimalDigitCharacterSet;

- (NSString *)content;

@end

@interface NUCHeaderName : NUCLexicalElement
{
    BOOL isHChar;
}

+ (instancetype)lexicalElementWithRange:(NSRange)aRange isHChar:(BOOL)anIsHChar;

+ (instancetype)lexicalElementWithContent:(NSString *)aContent range:(NSRange)aRange isHChar:(BOOL)anIsHChar;

- (instancetype)initWithRange:(NSRange)aRange isHChar:(BOOL)anIsHChar;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange isHChar:(BOOL)anIsHChar;

- (BOOL)isHChar;
- (BOOL)isQChar;

@end
