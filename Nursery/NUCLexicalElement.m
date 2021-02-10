//
//  NUCLexicalElements.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import "NUCLexicalElement.h"

#import <Foundation/NSCharacterSet.h>

NSString * const NUCBasicSourceCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!\"#%&'()*+,-./:;<=>?[\\]^_{|}~";
NSString * const NUCBasicSourceCharactersExceptSingleQuoteAndBackslash = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!\"#%&()*+,-./:;<=>?[]^_{|}~";
//NSString * const NUCSourceCharactersExceptDoubleQuoteAndBackslashAndNewline = nil;
NSString * const NUCLF = @"\n";
NSString * const NUCCRLF = @"\r\n";
NSString * const NUCCR = @"\r";
NSString * const NUCBackslash = @"\\";
NSString * const NUCLessThanSign = @"<";
NSString * const NUCGreaterThanSign = @">";
NSString * const NUCDoubleQuotationMark = @"\"";
NSString * const NUCHash = @"#";
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
NSString * const NUCPlusSign = @"+";
NSString * const NUCMinusSign = @"-";
NSString * const NUCOctalDigitZero = @"0";
NSString * const NUCOctalDigits = @"01234567";
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
        NUCQCharCharacterSet = [[[NSCharacterSet characterSetWithCharactersInString:@"\r\n'"] invertedSet] copy];
        NUCNonzeroDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCNonzeroDigits] copy];
        NUCNondigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] copy];
        NUCDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCDigits] copy];
        NUCOctalDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCOctalDigits] copy];
        NUCHexadecimalDigitCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCHexadecimalDigits] copy];
        NUCNewlineCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:NUCCRLF] copy];
        
        NUCPunctuators = [[NSArray arrayWithObjects:@"[", @"]", @"(", @")", @"{", @"}", @".", @"->",
                           @"++", @"--", @"&&", @"*=", @"+=", @"-=", @"~", @"!",
                           @"/=", @"%=", @"<<=", @">>=", @"<:", @":>", @"<<", @">>", @"==", @"!=", @"^=", @"||", @"&=", @"|=",
                           @"?", @":", @";", @"...",
                           @"=", @"*", @"/", @"%", @"+", @"-", @"<=", @">=", @"&", @"^", @"|",
                           @",", @"##", @"#",
                           @"<%", @"%>", @"<", @">", @"%:%:", @"%:", nil] copy];
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

@end
