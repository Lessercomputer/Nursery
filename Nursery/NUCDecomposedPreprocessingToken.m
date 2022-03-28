//
//  NUCPreprocessingToken.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCDecomposedPreprocessingToken.h"

#import <Foundation/NSString.h>

@implementation NUCDecomposedPreprocessingToken

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

- (BOOL)isHash
{
    return [self type] == NUCLexicalElementPunctuatorType
                && [[self content] isEqualToString:NUCHash];
}

- (BOOL)isIdentifier
{
    return [self type] == NUCLexicalElementIdentifierType;
}

- (BOOL)isStringLiteral
{
    return [self type] == NUCLexicalElementStringLiteralType;
}

- (BOOL)isCharacterConstant
{
    return [self type] == NUCLexicalElementCharacterConstantType;
}

- (BOOL)isPpNumber
{
    return [self type] == NUCLexicalElementPpNumberType;
}

- (BOOL)isPunctuator
{
    return [self type] == NUCLexicalElementPunctuatorType;
}

- (BOOL)isComma
{
    return [self isPunctuator]
                && [[self content] isEqualToString:NUCCommaPunctuator];
}

- (BOOL)isPeriod
{
    return [self isPunctuator]
                && [[self content] isEqualToString:NUCPeriod];
}

- (BOOL)isQuestionMark
{
    return [self isPunctuator]
                && [[self content] isEqualToString:NUCQuestionMarkPunctuator];
}

- (BOOL)isColon
{
    return [self isPunctuator]
                && [[self content] isEqualToString:NUCColonPunctuator];
}

- (BOOL)isEllipsis
{
    return [self isPunctuator] && [[self content] isEqualToString:NUCEllipsis];
}

- (BOOL)isUndef
{
    return [self type] == NUCLexicalElementUndefType;
}

- (BOOL)isLine
{
    return [self type] == NUCLexicalElementLineType;
}

- (BOOL)isError
{
    return [self type] == NUCLexicalElementErrorType;
}

- (BOOL)isPragma
{
    return [self type] == NUCLexicalElementPragmaType;
}

- (BOOL)isControlNewline
{
    return [self type] == NUCLexicalElementControlLineNewlineType;
}

- (BOOL)isLogicalOROperator
{
    return [self isPunctuator]
                && [[self content] isEqualToString:NUCLogicalOROperator];
}

- (BOOL)isLogicalANDOperator
{
    return [self isPunctuator]
                && [[self content] isEqualToString:NUCLogicalANDOperator];
}

- (BOOL)isInclusiveOROperator
{
    return [self isPunctuator] && [[self content] isEqualToString:NUCInclusiveOROperator];
}

- (BOOL)isExclusiveOROperator
{
    return [self isPunctuator] && [[self content] isEqualToString:NUCExclusiveOROperator];
}

- (BOOL)isBitwiseANDOperator
{
    return [self isPunctuator] && [[self content] isEqualToString:NUCBitwiseANDOperator];
}

- (BOOL)isInequalityOperator
{
    return [self isPunctuator] && [[self content] isEqualToString:NUCInequalityOperator];
}

- (BOOL)isEqualityOperator
{
    return [self isPunctuator] && [[self content] isEqualToString:NUCEqualityOperator];
}

- (BOOL)isRelationalOperator
{
    return [self isPunctuator] && ([[self content] isEqualToString:NUCLessThanOperator] || [[self content] isEqualToString:NUCLessThanOrEqualToOperator] || [[self content] isEqualToString:NUCGreaterThanOperator] || [[self content] isEqualToString:NUCGreaterThanOrEqualToOperator]);
}

- (BOOL)isShiftOperator;
{
    return [self isPunctuator] && ([[self content] isEqualToString:NUCLeftShiftOperator] || [[self content] isEqualToString:NUCRightShiftOperator]);
}

- (BOOL)isAdditiveOperator
{
    return [self isPunctuator] && ([[self content] isEqualToString:NUCAdditionOperator] || [[self content] isEqualToString:NUCSubtractionOperator]);
}

- (BOOL)isMultiplicativeOperator
{
    return [self isPunctuator] && ([[self content] isEqualToString:NUCMultiplicationOperator] || [[self content] isEqualToString:NUCDivisionOperator] || [[self content] isEqualToString:NUCRemainderOperator]);
}

- (BOOL)isUnaryOperator
{
    return [self isPunctuator] && ([[self content] isEqualToString:NUCUnaryPlusOperator] || [[self content] isEqualToString:NUCUnaryMinusOperator] || [[self content] isEqualToString:NUCBitwiseComplementOperator] || [[self content] isEqualToString:NUCLogicalNegationOperator]);
}

- (BOOL)isWhitespace
{
    return [self type] == NUCLexicalElementWhiteSpaceCharacterType || [self type] == NUCLexicalElementNewlineType || [self type] == NUCLexicalElementCommentType;
}

- (BOOL)isNotWhitespace
{
    return ![self isWhitespace];
}

- (BOOL)isWhitespacesWithoutNewline
{
    return [self type] == NUCLexicalElementWhiteSpaceCharacterType || [self type] == NUCLexicalElementCommentType;
}

- (NSString *)description
{
    return content;
    //    return [NSString stringWithFormat:@"<%@: %p> content:%@, type:%lu", [self class], self, [self content], type];
}

@end
