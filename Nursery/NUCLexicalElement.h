//
//  NUCLexicalElement.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

#import <Nursery/NURegion.h>

@class NSString, NSMutableArray;

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
extern NSString * const NUCEllipsis;
extern NSString * const NUCOpeningParenthesisPunctuator;
extern NSString * const NUCClosingParenthesisPunctuator;
extern NSString * const NUCCommaPunctuator;
extern NSString * const NUCQuestionMarkPunctuator;
extern NSString * const NUCColonPunctuator;
extern NSString * const NUCLogicalOROperator;
extern NSString * const NUCLogicalANDOperator;
extern NSString * const NUCInclusiveOROperator;
extern NSString * const NUCExclusiveOROperator;
extern NSString * const NUCBitwiseANDOperator;
extern NSString * const NUCInequalityOperator;
extern NSString * const NUCEqualityOperator;
extern NSString * const NUCLessThanOperator;
extern NSString * const NUCLessThanOrEqualToOperator;
extern NSString * const NUCGreaterThanOperator;
extern NSString * const NUCGreaterThanOrEqualToOperator;
extern NSString * const NUCLeftShiftOperator;
extern NSString * const NUCRightShiftOperator;
extern NSString * const NUCAdditionOperator;
extern NSString * const NUCSubtractionOperator;
extern NSString * const NUCMultiplicationOperator;
extern NSString * const NUCDivisionOperator;
extern NSString * const NUCRemainderOperator;
extern NSString * const NUCUnaryPlusOperator;
extern NSString * const NUCUnaryMinusOperator;
extern NSString * const NUCBitwiseComplementOperator;
extern NSString * const NUCLogicalNegationOperator;
extern NSString * const NUCPreprocessingDirectiveIf;
extern NSString * const NUCPreprocessingDirectiveIfdef;
extern NSString * const NUCPreprocessingDirectiveIfndef;
extern NSString * const NUCPreprocessingDirectiveEndif;
extern NSString * const NUCPreprocessingDirectiveElse;
extern NSString * const NUCPreprocessingDirectiveElif;
extern NSString * const NUCPreprocessingDirectiveInclude;
extern NSString * const NUCPreprocessingDirectiveDefine;
extern NSString * const NUCPreprocessingDirectiveUndef;
extern NSString * const NUCPreprocessingDirectiveLine;
extern NSString * const NUCPreprocessingDirectiveError;
extern NSString * const NUCPreprocessingDirectivePragma;

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
extern NSString * const NUCHexadecimalPrefixSmall;
extern NSString * const NUCHexadecimalPrefixLarge;
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
    NUCLexicalElementNone,
    NUCLexicalElementStringLiteralType,
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
    NUCLexicalElementCharacterConstantType,
    NUCLexicalElementCommentType,
    NUCLexicalElementPunctuatorType,
    NUCLexicalElementNonWhiteSpaceCharacterType,
    NUCLexicalElementWhiteSpaceCharacterType,
    NUCLexicalElementProcessingFileType,
    NUCLexicalElementIfSectionType,
    NUCLexicalElementGroupType,
    NUCLexicalElementGroupPartType,
    NUCLexicalElementIfType,
    NUCLexicalElementIfdefType,
    NUCLexicalElementIfndefType,
    NUCLexicalElementEndifType,
    NUCLexicalElementNewlineType,
    NUCLexicalElementEndifLineType,
    NUCLexicalElementElifGroups,
    NUCLexicalElementElifGroup,
    NUCLexicalElementElseType,
    NUCLexicalElementPpTokensType,
    NUCLexicalElementTextLineType,
    NUCLexicalElementControlLineType,
    NUCLexicalElementReplacementListType,
    NUCLexicalElementIdentifierListType,
    NUCLexicalElementDefineType,
    NUCLexicalElementUndefType,
    NUCLexicalElementLineType,
    NUCLexicalElementErrorType,
    NUCLexicalElementPragmaType,
    NUCLexicalElementControlLineNewlineType,
    NUCLexicalElementConstantExpressionType,
    NUCLexicalElementConditionalExpressionType,
    NUCLexicalElementExpressionType,
    NUCLexicalElementLogicalORExpressionType,
    NUCLexicalElementLogicalANDExpressionType,
    NUCLexicalElementInclusiveORExpressionType,
    NUCLexicalElementExclusiveORExpressionType,
    NUCLexicalElementANDExpressionType,
    NUCLexicalElementEqualityExpressionType,
    NUCLexicalElementRelationalExpressionType,
    NUCLexicalElementShiftExpressionType,
    NUCLexicalElementAdditiveExpressionType,
    NUCLexicalElementMultiplicativeExpressionType,
    NUCLexicalElementCastExpressionType,
    NUCLexicalElementUnaryExpressionType,
    NUCLexicalElementPostfixExpressionType,
    NUCLexicalElementPrimaryExpressionType,
    NUCLexicalElementConstantType
} NUCLexicalElementType;

@interface NUCLexicalElement : NSObject
{
    NUCLexicalElementType type;
}

+ (NSCharacterSet *)NUCBasicSourceCharacterSetExceptSingleQuoteAndBackslash;
+ (NSCharacterSet *)NUCSourceCharacterSetExceptDoubleQuoteAndBackslashAndNewline;
+ (NSCharacterSet *)NUCHCharCharacterSet;
+ (NSCharacterSet *)NUCQCharCharacterSet;
+ (NSCharacterSet *)NUCNonzeroDigitCharacterSet;
+ (NSCharacterSet *)NUCNondigitCharacterSet;
+ (NSCharacterSet *)NUCDigitCharacterSet;
+ (NSCharacterSet *)NUCOctalDigitCharacterSet;
+ (NSCharacterSet *)NUCHexadecimalDigitCharacterSet;
+ (NSCharacterSet *)NUCWhiteSpaceCharacterSet;
+ (NSCharacterSet *)NUCWhiteSpaceWithoutNewlineCharacterSet;
+ (NSCharacterSet *)NUCNewlineCharacterSet;

+ (NSArray *)NUCPunctuators;

+ (instancetype)lexicalElementWithType:(NUCLexicalElementType)aType;

- (instancetype)initWithType:(NUCLexicalElementType)aType;

- (NUCLexicalElementType)type;

@end














