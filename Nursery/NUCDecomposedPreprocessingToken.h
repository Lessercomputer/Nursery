//
//  NUCPreprocessingToken.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NSMutableString;
@class NUCPreprocessingTokenStream, NUCIdentifier;

@interface NUCDecomposedPreprocessingToken : NUCPreprocessingToken <NSCopying>
{
    NSString *content;
    NSRange range;
}

+ (BOOL)ellipsisFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCDecomposedPreprocessingToken **)aToken;

+ (instancetype)whitespace;

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

+ (instancetype)preprocessingTokenWithContent:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

- (instancetype)initWithContentFromString:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;


- (NSString *)content;
- (NSRange)range;

- (NSString *)string;
- (void)addStringTo:(NSMutableString *)aString;

- (BOOL)isHash;
- (BOOL)isHashHash;
- (BOOL)isIdentifier;
- (BOOL)isStringLiteral;
- (BOOL)isCharacterConstant;
- (BOOL)isPpNumber;
- (BOOL)isPunctuator;
- (BOOL)isComma;
- (BOOL)isPeriod;
- (BOOL)isQuestionMark;
- (BOOL)isColon;
- (BOOL)isEllipsis;
- (BOOL)isUndef;
- (BOOL)isLine;
- (BOOL)isError;
- (BOOL)isPragma;
- (BOOL)isDirectiveName;
- (BOOL)isNonDirectiveName;
- (BOOL)isControlNewline;
- (BOOL)isLogicalOROperator;
- (BOOL)isLogicalANDOperator;
- (BOOL)isInclusiveOROperator;
- (BOOL)isExclusiveOROperator;
- (BOOL)isBitwiseANDOperator;
- (BOOL)isInequalityOperator;
- (BOOL)isEqualityOperator;
- (BOOL)isRelationalOperator;
- (BOOL)isShiftOperator;
- (BOOL)isAdditiveOperator;
- (BOOL)isMultiplicativeOperator;
- (BOOL)isUnaryOperator;
- (BOOL)isWhitespace;
- (BOOL)isNotWhitespace;
- (BOOL)isWhitespacesWithoutNewline;
- (BOOL)isNewLine;
- (BOOL)isNotNewLine;
- (BOOL)isOpeningParenthesis;
- (BOOL)isClosingParenthesis;

@end
