//
//  NUCPreprocessingToken.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//

#import "NUCPreprocessingToken.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>

@implementation NUCPreprocessingToken

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

- (BOOL)isNegationOperator
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

- (BOOL)isOpeningParenthesis { return NO;}

- (BOOL)isPlacemaker { return NO;}

- (BOOL)isMacroArgument { return NO;}

- (BOOL)isConcatenatedToken { return NO;}

- (BOOL)isHash { return NO;}

- (BOOL)isHashHash { return NO;}

- (BOOL)isComma { return NO;}

- (BOOL)isPeriod { return NO;}

- (BOOL)isQuestionMark { return NO;}

- (BOOL)isColon { return NO;}

- (BOOL)isEllipsis { return NO;}

- (BOOL)isDirectiveName { return NO;}

- (BOOL)isNonDirectiveName { return NO;}

- (BOOL)isLogicalOROperator { return NO;}

- (BOOL)isLogicalANDOperator { return NO;}

- (BOOL)isInclusiveOROperator { return NO;}

- (BOOL)isExclusiveOROperator { return NO;}

- (BOOL)isBitwiseANDOperator { return NO;}

- (BOOL)isInequalityOperator { return NO;}

- (BOOL)isEqualityOperator { return NO;}

- (BOOL)isRelationalOperator { return NO;}

- (BOOL)isShiftOperator { return NO;}

- (BOOL)isAdditiveOperator { return NO;}

- (BOOL)isMultiplicativeOperator { return NO;}

- (BOOL)isUnaryOperator { return NO;}

- (BOOL)isWhitespacesWithoutNewline { return NO;}

- (BOOL)isNewLine { return NO;}

- (BOOL)isNotNewLine { return NO;}

- (BOOL)isClosingParenthesis { return NO;}

- (BOOL)isPredefinedMacroVA_ARGS { return NO; }

- (void)addUnexpandedPpTokensTo:(NSMutableArray *)aPpTokens
{
    [aPpTokens addObject:self];
}

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens
{
    [aPpTokens addObject:self];
}

@end
