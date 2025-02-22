//
//  NUCLexicalElement.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//

#import <Foundation/NSObject.h>

#import <Nursery/NURegion.h>

#import "NUCTokenProtocol.h"

@class NSString, NSMutableArray, NSMutableString;
@class NUCPreprocessor;

extern NSString * const NUCBasicSourceCharacters;
extern NSString * const NUCBasicSourceCharactersExceptSingleQuoteAndBackslash;
extern NSString * const NUCSpace;
extern NSString * const NUCLF;
extern NSString * const NUCCRLF;
extern NSString * const NUCCR;
extern NSString * const NUCBackslash;
extern NSString * const NUCLessThanSign;
extern NSString * const NUCGreaterThanSign;
extern NSString * const NUCDoubleQuotationMark;
extern NSString * const NUCHash;
extern NSString * const NUCHashHash;
extern NSString * const NUCEllipsis;
extern NSString * const NUCOpeningParenthesisPunctuator;
extern NSString * const NUCClosingParenthesisPunctuator;
extern NSString * const NUCOpeningBracePunctuator;
extern NSString * const NUCClosingBracePunctuator;
extern NSString * const NUCCommaPunctuator;
extern NSString * const NUCQuestionMarkPunctuator;
extern NSString * const NUCColonPunctuator;
extern NSString * const NUCSemicolonPunctuator;
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

extern NSString * const NUCIdentifierDefined;
extern NSString * const NUCIdentifierSTDC;
extern NSString * const NUCIdentifierFPCONTRACT;
extern NSString * const NUCIdentifierFENVACCESS;
extern NSString * const NUCIdentifierCXLIMITEDRANGE;
extern NSString * const NUCIdentifierON;
extern NSString * const NUCIdentifierOFF;
extern NSString * const NUCIdentifierDEFAULT;
extern NSString * const NUCIdentifierPragmaOperator;

extern NSString * const NUCPredefinedMacroVA_ARGS;
extern NSString * const NUCPredefinedMacroLINE;
extern NSString * const NUCPredefinedMacroFILE;
extern NSString * const NUCPredefinedMacroDATE;
extern NSString * const NUCPredefinedMacroTIME;

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
extern NSString * const NUCSmallF;
extern NSString * const NUCLargeF;
extern NSString * const NUCSmallL;
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

extern NSString * const NUCKeywordVoid;
extern NSString * const NUCKeywordInt;
extern NSString * const NUCKeywordReturn;

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
    NUCLexicalElementConstantType,
    NUCLexicalElementKeywordType
} NUCLexicalElementType;


@interface NUCLexicalElement : NSObject <NUCToken>
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

+ (NSArray *)NUCPreprocessingDirectiveNames;

+ (NSArray *)NUCKeywords;

+ (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aCharacterSet string:(NSString *)aString;
+ (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aCharacterSet string:(NSString *)aString range:(NSRange)aRangeToSearch;
+ (NSRange)rangeOfDigitSequenceFrom:(NSString *)aString;
+ (NSRange)rangeOfDigitSequenceFrom:(NSString *)aString range:(NSRange)aRangeToSearch;

+ (instancetype)lexicalElementWithType:(NUCLexicalElementType)aType;

- (instancetype)initWithType:(NUCLexicalElementType)aType;

- (NUCLexicalElementType)type;
- (NSString *)typeName;

- (NSString *)preprocessedStringWithPreprocessor:(NUCPreprocessor *)aPreprocessor;
- (void)addPreprocessedStringTo:(NSMutableString *)aString with:(NUCPreprocessor *)aPreprocessor;

@end














