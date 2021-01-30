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

@implementation NUCPreprocessingToken

+ (void)initialize
{
    if (self == [NUCPreprocessingToken class])
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

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self preprocessingTokenWithContent:[aString substringWithRange:aRange] range:aRange type:anElementType];
}

+ (instancetype)preprocessingTokenWithRange:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self preprocessingTokenWithContent:nil range:aRange type:anElementType];
}

+ (instancetype)preprocessingTokenWithContent:(NSString *)aContent range:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self preprocessingTokenWithContent:aContent region:NURegionFromRange(aRange) type:anElementType];
}

+ (instancetype)preprocessingTokenWithContent:(NSString *)aContent region:(NURegion)aRange type:(NUCLexicalElementType)anElementType
{
    return [[[self alloc] initWithContent:aContent region:aRange type:anElementType] autorelease];
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

- (instancetype)initWithRange:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self initWithContent:nil range:aRange type:anElementType];
}

- (instancetype)initWithContentFromString:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self initWithContent:[aString substringWithRange:aRange] range:aRange type:anElementType];
}

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange type:(NUCLexicalElementType)anElementType
{
    return [self initWithContent:aContent region:NURegionFromRange(aRange) type:anElementType];
}

- (instancetype)initWithContent:(NSString *)aContent region:(NURegion)aRange type:(NUCLexicalElementType)anElementType
{
    if (self = [super init])
    {
        content = [aContent copy];
        type = anElementType;
        range = aRange;
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

- (NSString *)description
{
    return content;
//    return [NSString stringWithFormat:@"<%@: %p> content:%@, type:%lu", [self class], self, [self content], type];
}

@end

@implementation NUCHeaderName

+ (instancetype)preprocessingTokenWithRange:(NSRange)aRange isHChar:(BOOL)anIsHChar;
{
    return [self preprocessingTokenWithContent:nil range:aRange isHChar:anIsHChar];
}

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange isHChar:(BOOL)anIsHChar
{
    return [self preprocessingTokenWithContent:[aString substringWithRange:aRange] range:aRange isHChar:anIsHChar];
}

+ (instancetype)preprocessingTokenWithContent:(NSString *)aContent range:(NSRange)aRange isHChar:(BOOL)anIsHChar
{
    return [[[self alloc] initWithContent:aContent range:aRange isHChar:anIsHChar] autorelease];
}

- (instancetype)initWithRange:(NSRange)aRange isHChar:(BOOL)anIsHChar;
{
    return [self initWithContent:nil range:aRange isHChar:anIsHChar];
}

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange isHChar:(BOOL)anIsHChar
{
    if (self = [super initWithContent:aContent region:NURegionFromRange(aRange) type:NUCLexicalElementHeaderNameType])
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

@implementation NUCPreprocessingDirective

+ (instancetype)preprocessingDirective
{
    return [[self new] autorelease];
}

@end

@implementation NUCGroup

+ (instancetype)group
{
    return [[[self alloc] initWithType:NUCLexicalElementGroupType] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        groupParts = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [groupParts release];
    
    [super dealloc];
}

- (NSMutableArray *)groupParts
{
    return groupParts;
}

- (NSUInteger)count
{
    return [[self groupParts] count];
}

- (void)add:(NUCPreprocessingDirective *)aGroupPart
{
    [[self groupParts] addObject:aGroupPart];
}

@end

@implementation NUCIfGroup

+ (instancetype)ifGroupWithType:(NUCLexicalElementType)aType hash:(NUCPreprocessingToken *)aHash expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    return [[[self alloc] initWithType:aType hash:aHash expressionOrIdentifier:anExpressionOrIdentifier newline:aNewline group:aGroup] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCPreprocessingToken *)aHash expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup
{
    if (self = [super initWithType:aType])
    {
        hash = [aHash retain];
        expressionOrIdentifier = [anExpressionOrIdentifier retain];
        newline = [aNewline retain];
        group = [aGroup retain];
    }
    
    return self;
}

- (void)dealloc
{
    [hash release];
    [expressionOrIdentifier release];
    [newline release];
    [group release];
    
    [super dealloc];
}

- (BOOL)isIf
{
    return [self type] == NUCLexicalElementIfType;
}

- (BOOL)isIfdef
{
    return [self type] == NUCLexicalElementIfdefType;
}

- (BOOL)isIfndef
{
    return [self type] == NUCLexicalElementIfndefType;
}

- (NUCPreprocessingToken *)hash
{
    return hash;
}

- (NUCLexicalElement *)expression
{
    return [self isIf] ? expressionOrIdentifier : nil;
}

- (NUCLexicalElement *)identifier
{
    return ![self isIf] ? expressionOrIdentifier : nil;
}

- (NUCPreprocessingDirective *)newline
{
    return newline;
}

- (NUCGroup *)group
{
    return group;
}

@end

@implementation NUCElifGroups

//+ (instancetype)elifGroups;

@end

@implementation NUCElifGroup

//+ (instancetype)elifGroup;

@end

@implementation NUCElseGroup

//+ (instancetype)elseGroup;

@end

@implementation NUCIfSection

+ (instancetype)ifSectionWithIfGroup:(NUCIfGroup *)anIfGroup elifGroups:(NUCElifGroups *)anElifGroups elseGroup:(NUCElseGroup *)anElseGroup endifLine:(NUCEndifLine *)anEndifLine
{
    return [[[self alloc] initWithIfGroup:anIfGroup elifGroups:anElifGroups elseGroup:anElseGroup endifLine:anEndifLine] autorelease];
}

- (instancetype)initWithIfGroup:(NUCIfGroup *)anIfGroup elifGroups:(NUCElifGroups *)anElifGroups elseGroup:(NUCElseGroup *)anElseGroup endifLine:(NUCEndifLine *)anEndifLine
{
    if (self = [super initWithType:NUCLexicalElementIfSectionType])
    {
        ifGroup = [anIfGroup retain];
        elifGroups = [anElifGroups retain];
        elseGroup = [anElseGroup retain];
        endifLine = [anEndifLine retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ifGroup release];
    [elifGroups release];
    [elseGroup release];
    [endifLine release];
    
    [super dealloc];
}

- (NUCIfGroup *)ifGroup
{
    return ifGroup;
}

- (NUCElifGroups *)elifGroups
{
    return elifGroups;
}

- (NUCElseGroup *)elseGroup
{
    return elseGroup;
}

- (NUCEndifLine *)endifLine
{
    return endifLine;
}

@end
