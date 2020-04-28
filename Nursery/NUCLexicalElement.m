//
//  NUCLexicalElements.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/18.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import "NUCLexicalElement.h"

#import <Foundation/NSCharacterSet.h>

NSString * const NUCLF = @"\n";
NSString * const NUCCRLF = @"\r\n";
NSString * const NUCCR = @"\r";
NSString * const NUCBackslash = @"\\";
NSString * const NUCLessThanSign = @"<";
NSString * const NUCGreaterThanSign = @">";
NSString * const NUCDoubleQuotationMark = @"\"";

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

static NSCharacterSet *NUCHCharCharacterSet;
static NSCharacterSet *NUCQCharCharacterSet;

@implementation NUCLexicalElement

+ (void)initialize
{
    if (self == [NUCLexicalElement class])
    {
        NUCHCharCharacterSet = [[[NSCharacterSet characterSetWithCharactersInString:@"\r\n>"] invertedSet] copy];
        NUCQCharCharacterSet = [[[NSCharacterSet characterSetWithCharactersInString:@"\r\n'"] invertedSet] copy];
    }
}

+ (instancetype)lexicalElementWithContent:(NSString *)aContent type:(NUCLexicalElementType)anElementType
{
    return [[[self alloc] initWithContent:aContent type:anElementType] autorelease];
}

+ (NSCharacterSet *)NUCHCharCharacterSet
{
    return NUCHCharCharacterSet;
}

+ (NSCharacterSet *)NUCQCharCharacterSet
{
    return NUCQCharCharacterSet;
}

- (instancetype)initWithContent:(NSString *)aContent type:(NUCLexicalElementType)anElementType
{
    if (self = [super init])
    {
        content = [aContent copy];
        type = anElementType;
    }
    
    return self;
}

- (void)dealloc
{
    [content release];
    content = nil;
    
    [super dealloc];
}

- (NSString *)content
{
    return content;
}

@end

@implementation NUCHeaderName

+ (instancetype)lexicalElementWithContent:(NSString *)aContent isHChar:(BOOL)anIsHChar
{
    return [[[self alloc] initWithContent:aContent isHChar:anIsHChar] autorelease];
}

- (instancetype)initWithContent:(NSString *)aContent isHChar:(BOOL)anIsHChar
{
    if (self = [super initWithContent:aContent type:NUCLexicalElementHeaderNameType])
    {
        isHChar = anIsHChar;
    }
    
    return self;
}

- (BOOL)isHChar
{
    return isHChar;
}

- (BOOL)isQChar
{
    return !isHChar;
}

@end
