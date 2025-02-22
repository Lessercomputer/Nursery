//
//  NUCLexicalElements.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//

#import "NUCLexicalElement.h"

#import <Foundation/NSCharacterSet.h>

#define NUCEnumToNSString(aType) @#aType

NSString * const NUCBasicSourceCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!\"#%&'()*+,-./:;<=>?[\\]^_{|}~";
NSString * const NUCBasicSourceCharactersExceptSingleQuoteAndBackslash = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!\"#%&()*+,-./:;<=>?[]^_{|}~";
//NSString * const NUCSourceCharactersExceptDoubleQuoteAndBackslashAndNewline = nil;
NSString * const NUCSpace = @" ";
NSString * const NUCLF = @"\n";
NSString * const NUCCRLF = @"\r\n";
NSString * const NUCCR = @"\r";
NSString * const NUCBackslash = @"\\";
NSString * const NUCLessThanSign = @"<";
NSString * const NUCGreaterThanSign = @">";
NSString * const NUCDoubleQuotationMark = @"\"";
NSString * const NUCHash = @"#";
NSString * const NUCHashHash = @"##";
NSString * const NUCEllipsis = @"...";
NSString * const NUCOpeningParenthesisPunctuator = @"(";
NSString * const NUCClosingParenthesisPunctuator = @")";
NSString * const NUCOpeningBracePunctuator = @"{";
NSString * const NUCClosingBracePunctuator = @"}";
NSString * const NUCCommaPunctuator = @",";
NSString * const NUCQuestionMarkPunctuator = @"?";
NSString * const NUCColonPunctuator = @":";
NSString * const NUCSemicolonPunctuator = @";";
NSString * const NUCLogicalOROperator = @"||";
NSString * const NUCLogicalANDOperator = @"&&";
NSString * const NUCInclusiveOROperator = @"|";
NSString * const NUCExclusiveOROperator = @"^";
NSString * const NUCBitwiseANDOperator = @"&";
NSString * const NUCInequalityOperator = @"!=";
NSString * const NUCEqualityOperator = @"==";
NSString * const NUCLessThanOperator = @"<";
NSString * const NUCLessThanOrEqualToOperator = @"<=";
NSString * const NUCGreaterThanOperator = @">";
NSString * const NUCGreaterThanOrEqualToOperator = @">=";
NSString * const NUCLeftShiftOperator = @"<<";
NSString * const NUCRightShiftOperator = @">>";
NSString * const NUCAdditionOperator = @"+";
NSString * const NUCSubtractionOperator = @"-";
NSString * const NUCMultiplicationOperator = @"*";
NSString * const NUCDivisionOperator = @"/";
NSString * const NUCRemainderOperator = @"%";
NSString * const NUCUnaryPlusOperator = @"+";
NSString * const NUCUnaryMinusOperator = @"-";
NSString * const NUCBitwiseComplementOperator = @"~";
NSString * const NUCLogicalNegationOperator = @"!";
NSString * const NUCPreprocessingDirectiveIf = @"if";
NSString * const NUCPreprocessingDirectiveIfdef = @"ifdef";
NSString * const NUCPreprocessingDirectiveIfndef = @"ifndef";
NSString * const NUCPreprocessingDirectiveEndif = @"endif";
NSString * const NUCPreprocessingDirectiveElse = @"else";
NSString * const NUCPreprocessingDirectiveElif = @"elif";
NSString * const NUCPreprocessingDirectiveInclude = @"include";
NSString * const NUCPreprocessingDirectiveDefine = @"define";
NSString * const NUCPreprocessingDirectiveUndef = @"undef";
NSString * const NUCPreprocessingDirectiveLine = @"line";
NSString * const NUCPreprocessingDirectiveError = @"error";
NSString * const NUCPreprocessingDirectivePragma = @"pragma";

NSString * const NUCIdentifierDefined = @"defined";
NSString * const NUCIdentifierSTDC = @"STDC";
NSString * const NUCIdentifierFPCONTRACT = @"FP_CONTRACT";
NSString * const NUCIdentifierFENVACCESS = @"FENV_ACCESS";
NSString * const NUCIdentifierCXLIMITEDRANGE = @"CX_LIMITED_RANGE";
NSString * const NUCIdentifierON = @"ON";
NSString * const NUCIdentifierOFF = @"OFF";
NSString * const NUCIdentifierDEFAULT = @"DEFAULT";
NSString * const NUCIdentifierPragmaOperator = @"_Pragma";

NSString * const NUCPredefinedMacroVA_ARGS = @"__VA_ARGS__";
NSString * const NUCPredefinedMacroLINE = @"__LINE__";
NSString * const NUCPredefinedMacroFILE = @"__FILE__";
NSString * const NUCPredefinedMacroDATE = @"__DATE__";
NSString * const NUCPredefinedMacroTIME = @"__TIME__";

NSString * const NUCTrigraphSequenceBeginning = @"??";

NSString * const NUCTrigraphSequenceEqual = @"=";
NSString * const NUCTrigraphSequenceLeftBlacket = @"(";
NSString * const NUCTrigraphSequenceSlash = @"/";
NSString * const NUCTrigraphSequenceRightBracket = @")";
NSString * const NUCTrigraphSequenceApostrophe = @"'";
NSString * const NUCTrigraphSequenceLeftLessThanSign = @"<";
NSString * const NUCTrigraphSequenceQuestionMark = @"!";
NSString * const NUCTrigraphSequenceGreaterThanSign = @">";
NSString * const NUCTrigraphSequenceHyphen = @"-";

NSString * const NUCTrigraphSequenceHash = @"#";
NSString * const NUCTrigraphSequenceLeftSquareBracket = @"[";
NSString * const NUCTrigraphSequenceBackslash = @"\\";
NSString * const NUCTrigraphSequenceRightSquareBracket = @"]";
NSString * const NUCTrigraphSequenceCircumflex = @"^";
NSString * const NUCTrigraphSequenceLeftCurlyBracket = @"{";
NSString * const NUCTrigraphSequenceVerticalbar = @"|";
NSString * const NUCTrigraphSequenceRightCurlyBracket = @"}";
NSString * const NUCTrigraphSequenceTilde = @"~";

NSString * const NUCKeywordAuto = @"auto";
NSString * const NUCKeywordBreak = @"break";
NSString * const NUCKeywordCase = @"case";
NSString * const NUCKeywordChar = @"char";
NSString * const NUCKeywordConst = @"const";
NSString * const NUCKeywordContinue = @"continue";
NSString * const NUCKeywordDefault = @"default";
NSString * const NUCKeywordDo = @"do";
NSString * const NUCKeywordDouble = @"double";
NSString * const NUCKeywordElse = @"else";
NSString * const NUCKeywordEnum = @"enum";
NSString * const NUCKeywordExtern = @"extern";
NSString * const NUCKeywordFloat = @"float";
NSString * const NUCKeywordFor = @"for";
NSString * const NUCKeywordGoto = @"goto";
NSString * const NUCKeywordIf = @"if";
NSString * const NUCKeywordInline = @"inline";
NSString * const NUCKeywordInt = @"int";
NSString * const NUCKeywordLong = @"long";
NSString * const NUCKeywordRegister = @"register";
NSString * const NUCKeywordRestrict = @"restrict";
NSString * const NUCKeywordReturn = @"return";
NSString * const NUCKeywordShort = @"short";
NSString * const NUCKeywordSigned = @"signed";
NSString * const NUCKeywordSizeof = @"sizeof";
NSString * const NUCKeywordStatic = @"static";
NSString * const NUCKeywordStruct = @"struct";
NSString * const NUCKeywordSwitch = @"switch";
NSString * const NUCKeywordTypedef = @"typedef";
NSString * const NUCKeywordUnion = @"union";
NSString * const NUCKeywordUnsigned = @"unsigned";
NSString * const NUCKeywordVoid = @"void";
NSString * const NUCKeywordVolatile = @"volatile";
NSString * const NUCKeywordWhile = @"while";
NSString * const NUCKeywordAlignas = @"_Alignas";
NSString * const NUCKeywordAlignof = @"_Alignof";
NSString * const NUCKeywordAtomic = @"_Atomic";
NSString * const NUCKeywordBool = @"_Bool";
NSString * const NUCKeywordComplex = @"_Complex";
NSString * const NUCKeywordGeneric = @"_Generic";
NSString * const NUCKeywordImaginary = @"_Imaginary";
NSString * const NUCKeywordNoreturn = @"_Noretun";
NSString * const NUCKeywordStaticAssert = @"_Static_assert";
NSString * const NUCKeywordThreadLocal = @"_Thread_local";

NSString * const NUCIdentifierNondigit = @"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
NSString * const NUCIdentifierDigit = @"0123456789";

NSString * const NUCNonzeroDigits = @"123456789";
NSString * const NUCDigits = @"0123456789";
NSString * const NUCPeriod = @".";
NSString * const NUCSmallE = @"e";
NSString * const NUCLargeE = @"E";
NSString * const NUCSmallP = @"p";
NSString * const NUCLargeP = @"P";
NSString * const NUCSmallF = @"f";
NSString * const NUCLargeF = @"F";
NSString * const NUCSmallL = @"l";
NSString * const NUCPlusSign = @"+";
NSString * const NUCMinusSign = @"-";
NSString * const NUCOctalDigitZero = @"0";
NSString * const NUCOctalDigits = @"01234567";
NSString * const NUCHexadecimalPrefixSmall = @"0x";
NSString * const NUCHexadecimalPrefixLarge = @"0X";
NSString * const NUCHexadecimalDigits = @"0123456789abcdefABCDEF";
NSString * const NUCUnsignedSuffixSmall = @"u";
NSString * const NUCUnsignedSuffixLarge = @"U";
NSString * const NUCLongSuffixSmall = @"l";
NSString * const NUCLongSuffixLarge = @"L";
NSString * const NUCLongLongSuffixSmall = @"ll";
NSString * const NUCLongLongSuffixLarge = @"LL";
NSString * const NUCSingleQuote = @"'";
NSString * const NUCLargeL = @"L";
NSString * const NUCSmallU = @"u";
NSString * const NUCLargeU = @"U";
NSString * const NUCStringLiteralEncodingPrefixSmallU8 = @"u8";
NSString * const NUCStringLiteralEncodingPrefixSmallU = @"u";
NSString * const NUCStringLiteralEncodingPrefixLargeU = @"U";
NSString * const NUCStringLiteralEncodingPrefixLargeL = @"L";

static NSCharacterSet *NUCBasicSourceCharacterSetExceptSingleQuoteAndBackslash;
static NSCharacterSet *NUCSourceCharacterSetExceptDoubleQuoteAndBackslashAndNewline;
static NSCharacterSet *NUCHCharCharacterSet;
static NSCharacterSet *NUCQCharCharacterSet;
static NSCharacterSet *NUCNonzeroDigitCharacterSet;
static NSCharacterSet *NUCNondigitCharacterSet;
static NSCharacterSet *NUCDigitCharacterSet;
static NSCharacterSet *NUCOctalDigitCharacterSet;
static NSCharacterSet *NUCHexadecimalDigitCharacterSet;
static NSCharacterSet *NUCNewlineCharacterSet;

static NSArray *NUCPunctuators;

static NSArray *NUCPreprocessingDirectiveNames;

static NSArray *NUCKeywords;

@implementation NUCLexicalElement

+ (void)initialize
{
    if (self == [NUCLexicalElement class])
    {
        NSCharacterSet *aBasicSourceCharacterSet = [NSCharacterSet characterSetWithCharactersInString:NUCBasicSourceCharacters];
        NSMutableCharacterSet *aBasicSourceMutableCharacterSet = [[aBasicSourceCharacterSet mutableCopy] autorelease];
        
        NUCBasicSourceCharacterSetExceptSingleQuoteAndBackslash = [[NSCharacterSet characterSetWithCharactersInString:NUCBasicSourceCharactersExceptSingleQuoteAndBackslash] copy];
        
        [aBasicSourceMutableCharacterSet removeCharactersInString:@"\"\\\r\n"];
        NUCSourceCharacterSetExceptDoubleQuoteAndBackslashAndNewline = [aBasicSourceMutableCharacterSet copy];
        
        NUCHCharCharacterSet = [[[NSCharacterSet characterSetWithCharactersInString:@"\r\n>"] invertedSet] copy];
        NUCQCharCharacterSet = [[[NSCharacterSet characterSetWithCharactersInString:@"\r\n\""] invertedSet] copy];
        NUCNonzeroDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCNonzeroDigits] copy];
        NUCNondigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] copy];
        NUCDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCDigits] copy];
        NUCOctalDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCOctalDigits] copy];
        NUCHexadecimalDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCHexadecimalDigits] copy];
        NUCNewlineCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCCRLF] copy];
        
        NUCPunctuators = [[NSArray arrayWithObjects:@"[", @"]", @"(", @")", @"{", @"}", @"...", @"->",
                           @"++", @"--", @"&&", @"*=", @"+=", @"-=", @"==", @"!=", @"~", @"!",
                           @"/=", @"%=", @"<<=", @">>=", @"<:", @":>", @"<<", @">>", @"^=", @"||", @"&=", @"|=",
                           @"?", @":", @";", @".",
                           @"=", @"*", @"/", @"%", @"+", @"-", @"<=", @">=", @"&", @"^", @"|",
                           @",", @"##", @"#",
                           @"<%", @"%>", @"<", @">", @"%:%:", @"%:", nil] copy];
        
        NUCPreprocessingDirectiveNames = [[NSArray arrayWithObjects:NUCPreprocessingDirectiveIf, NUCPreprocessingDirectiveIfdef, NUCPreprocessingDirectiveIfndef, NUCPreprocessingDirectiveEndif, NUCPreprocessingDirectiveElse, NUCPreprocessingDirectiveElif, NUCPreprocessingDirectiveInclude, NUCPreprocessingDirectiveDefine, NUCPreprocessingDirectiveUndef, NUCPreprocessingDirectiveLine, NUCPreprocessingDirectiveError, NUCPreprocessingDirectivePragma, nil] copy];
        
        NUCKeywords = [[NSArray arrayWithObjects:NUCKeywordAuto, NUCKeywordBreak, NUCKeywordCase, NUCKeywordChar, NUCKeywordConst, NUCKeywordContinue, NUCKeywordDefault, NUCKeywordDo, NUCKeywordDouble, NUCKeywordElse, NUCKeywordEnum, NUCKeywordExtern, NUCKeywordFloat, NUCKeywordFor, NUCKeywordGoto, NUCKeywordIf, NUCKeywordInline, NUCKeywordInt, NUCKeywordLong, NUCKeywordRegister, NUCKeywordRestrict, NUCKeywordReturn,  NUCKeywordShort, NUCKeywordSigned, NUCKeywordSizeof, NUCKeywordStatic, NUCKeywordStruct, NUCKeywordSwitch, NUCKeywordTypedef, NUCKeywordUnion, NUCKeywordUnsigned, NUCKeywordVoid, NUCKeywordVolatile, NUCKeywordWhile, NUCKeywordAlignas, NUCKeywordAlignof, NUCKeywordAtomic, NUCKeywordBool, NUCKeywordComplex, NUCKeywordGeneric, NUCKeywordImaginary, NUCKeywordNoreturn, NUCKeywordStaticAssert, NUCKeywordThreadLocal, nil] copy];
    }
}

+ (NSCharacterSet *)NUCBasicSourceCharacterSetExceptSingleQuoteAndBackslash
{
    return NUCBasicSourceCharacterSetExceptSingleQuoteAndBackslash;
}

+ (NSCharacterSet *)NUCSourceCharacterSetExceptDoubleQuoteAndBackslashAndNewline
{
    return NUCSourceCharacterSetExceptDoubleQuoteAndBackslashAndNewline;
}

+ (NSCharacterSet *)NUCHCharCharacterSet
{
    return NUCHCharCharacterSet;
}

+ (NSCharacterSet *)NUCQCharCharacterSet
{
    return NUCQCharCharacterSet;
}

+ (NSCharacterSet *)NUCNonzeroDigitCharacterSet
{
    return NUCNonzeroDigitCharacterSet;
}

+ (NSCharacterSet *)NUCNondigitCharacterSet
{
    return NUCNondigitCharacterSet;
}

+ (NSCharacterSet *)NUCDigitCharacterSet
{
    return NUCDigitCharacterSet;
}

+ (NSCharacterSet *)NUCOctalDigitCharacterSet
{
    return NUCOctalDigitCharacterSet;
}

+ (NSCharacterSet *)NUCHexadecimalDigitCharacterSet
{
    return NUCHexadecimalDigitCharacterSet;
}

+ (NSCharacterSet *)NUCWhiteSpaceCharacterSet
{
    return [NSCharacterSet whitespaceAndNewlineCharacterSet];
}

+ (NSCharacterSet *)NUCWhiteSpaceWithoutNewlineCharacterSet
{
    return [NSCharacterSet whitespaceCharacterSet];
}

+ (NSCharacterSet *)NUCNewlineCharacterSet
{
    return NUCNewlineCharacterSet;
}

+ (NSArray *)NUCPunctuators
{
    return NUCPunctuators;
}

+ (NSArray *)NUCPreprocessingDirectiveNames
{
    return NUCPreprocessingDirectiveNames;
}

+ (NSArray *)NUCKeywords
{
    return NUCKeywords;
}

+ (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aCharacterSet string:(NSString *)aString
{
    NSRange aRangeOfString = NSMakeRange(0, [aString length]);
    return [self rangeOfCharactersFromSet:aCharacterSet string:aString range:aRangeOfString];
}

+ (NSRange)rangeOfCharactersFromSet:(NSCharacterSet *)aCharacterSet string:(NSString *)aString range:(NSRange)aRangeToSearch
{
    NSRange aSubRangeToSearch = aRangeToSearch;
    BOOL aCharacterIsFound = NO;
    
    while (YES)
    {
        if (NSLocationInRange(aSubRangeToSearch.location, aRangeToSearch))
        {
            NSRange aRangeOfCharacter = [aString rangeOfCharacterFromSet:aCharacterSet options:NSAnchoredSearch range:aSubRangeToSearch];
            
            if (aRangeOfCharacter.location != NSNotFound)
            {
                aSubRangeToSearch.location += aRangeOfCharacter.length;
                aSubRangeToSearch.length -= aRangeOfCharacter.length;
                aCharacterIsFound = YES;
            }
            else
                break;
        }
        else
            break;
    }
    
    if (aCharacterIsFound)
        return NSMakeRange(aRangeToSearch.location, aSubRangeToSearch.location - aRangeToSearch.location);
    else
        return NSMakeRange(NSNotFound, 0);
}

+ (NSRange)rangeOfDigitSequenceFrom:(NSString *)aString
{
    return [self rangeOfCharactersFromSet:[self NUCDigitCharacterSet] string:aString];
}

+ (NSRange)rangeOfDigitSequenceFrom:(NSString *)aString range:(NSRange)aRangeToSearch;
{
    return [self rangeOfCharactersFromSet:[self NUCDigitCharacterSet] string:aString range:aRangeToSearch];
}

+ (instancetype)lexicalElementWithType:(NUCLexicalElementType)aType
{
    return [[[self alloc] initWithType:aType] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super init])
    {
        type = aType;
    }
    
    return self;
}

- (NUCLexicalElementType)type
{
    return type;
}

- (NSString *)typeName
{
    switch ([self type])
    {
        case NUCLexicalElementNone:
            return NUCEnumToNSString(NUCLexicalElementNone);
        case NUCLexicalElementPpNumberType:
            return NUCEnumToNSString(NUCLexicalElementPpNumberType);
        case NUCLexicalElementCommentType:
            return NUCEnumToNSString(NUCLexicalElementCommentType);
        case NUCLexicalElementPunctuatorType:
            return NUCEnumToNSString(NUCLexicalElementPunctuatorType);
        case NUCLexicalElementNonWhiteSpaceCharacterType:
            return NUCEnumToNSString(NUCLexicalElementNonWhiteSpaceCharacterType);
        case NUCLexicalElementWhiteSpaceCharacterType:
            return NUCEnumToNSString(NUCLexicalElementWhiteSpaceCharacterType);
        default:
            return [NSString stringWithFormat:@"%lu", [self type]];
    }
}

- (BOOL)isIdentifier
{
    return [self type] == NUCLexicalElementIdentifierType;
}

- (BOOL)isCharacterConstant
{
    return [self type] == NUCLexicalElementCharacterConstantType;
}

- (BOOL)isStringLiteral
{
    return [self type] == NUCLexicalElementStringLiteralType;
}

- (BOOL)isKeyword
{
    return [self type] == NUCLexicalElementKeywordType;
}

- (BOOL)isConstant
{
    return [self type] == NUCLexicalElementConstantType;
}

- (BOOL)isPunctuator
{
    return [self type] == NUCLexicalElementPunctuatorType;
}

- (BOOL)isClosingBrace
{
    return NO;
}

- (BOOL)isClosingParenthesis
{
    return NO;
}

- (BOOL)isComma
{
    return NO;
}

- (BOOL)isEllipsis
{
    return NO;
}

- (BOOL)isOpeningBrace
{
    return NO;
}

- (BOOL)isOpeningParenthesis
{
    return NO;
}

- (BOOL)isIntegerConstant
{
    return NO;
}

- (BOOL)isPpNumber
{
    return [self type] == NUCLexicalElementPpNumberType;
}

- (BOOL)isUnaryPlusOperator
{
    return NO;
}

- (BOOL)isUnaryMinusOperator
{
    return NO;
}

- (BOOL)isBitwiseComplementOperator
{
    return NO;
}

- (BOOL)isLogicalNegationOperator
{
    return NO;
}

- (BOOL)isUndef
{
    return NO;
}

- (BOOL)isLine
{
    return [self type] == NUCLexicalElementLineType;
}

- (BOOL)isError
{
    return NO;
}

- (BOOL)isPragma
{
    return [self type] == NUCLexicalElementPragmaType;
}

- (BOOL)isControlNewline
{
    return [self type] == NUCLexicalElementControlLineNewlineType;
}

- (BOOL)isWhitespace
{
    return [self type] == NUCLexicalElementWhiteSpaceCharacterType || [self type] == NUCLexicalElementCommentType;
}

- (BOOL)isNotWhitespace
{
    return ![self isWhitespace];
}

- (BOOL)isMacroInvocation { return NO;}

- (BOOL)isPpTokensWithMacroInvocations { return NO;}

- (BOOL)isPlacemaker { return NO;}

- (BOOL)isMacroArgument { return NO;}

- (BOOL)isConcatenatedToken { return NO;}

- (BOOL)isHash { return NO;}

- (BOOL)isHashHash { return NO;}

- (BOOL)isPeriod { return NO;}

- (BOOL)isQuestionMark { return NO;}

- (BOOL)isColon { return NO;}

- (BOOL)isSemicolon { return NO; }

- (BOOL)isDirectiveName { return NO;}

- (BOOL)isNonDirectiveName { return NO;}

- (BOOL)isLogicalOROperator { return NO;}

- (BOOL)isLogicalANDOperator { return NO;}

- (BOOL)isInclusiveOROperator { return NO;}

- (BOOL)isExclusiveOROperator { return NO;}

- (BOOL)isBitwiseANDOperator { return NO;}

- (BOOL)isInequalityOperator { return NO;}

- (BOOL)isEqualityOperator { return NO;}

- (BOOL)isEqualToOperator { return NO;}

- (BOOL)isNotEqualToOperator { return NO;}

- (BOOL)isRelationalOperator { return NO;}

- (BOOL)isLessThanOperator { return NO;}

- (BOOL)isGreaterThanOperator { return NO;}

- (BOOL)isLessThanOrEqualToOperator { return NO;}

- (BOOL)isGreaterThanOrEqualToOperator { return NO;}

- (BOOL)isShiftOperator { return NO;}

- (BOOL)isLeftShiftOperator { return NO;}

- (BOOL)isRightShiftOperator { return NO;}

- (BOOL)isAdditiveOperator { return NO;}

- (BOOL)isAdditionOperator { return NO;}

- (BOOL)isSubtractionOperator { return NO;}

- (BOOL)isMultiplicativeOperator { return NO;}

- (BOOL)isMultiplicationOperator { return NO;}

- (BOOL)isDivisionOperator { return NO;}

- (BOOL)isRemainderOperator { return NO;}

- (BOOL)isUnaryOperator { return NO;}

- (BOOL)isWhitespacesWithoutNewline { return NO;}

- (BOOL)isNewLine { return NO;}

- (BOOL)isNotNewLine { return NO;}

- (BOOL)isPredefinedMacroVA_ARGS { return NO; }

- (BOOL)isReturn { return NO; }

- (NSString *)preprocessedStringWithPreprocessor:(NUCPreprocessor *)aPreprocessor
{
    NSMutableString *aString = [NSMutableString string];
    
    [self addPreprocessedStringTo:aString with:aPreprocessor];
    
    return aString;
}

- (void)addPreprocessedStringTo:(NSMutableString *)aString with:(NUCPreprocessor *)aPreprocessor
{
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> typeName:%@", [self class], self, [self typeName]];
}

@end
