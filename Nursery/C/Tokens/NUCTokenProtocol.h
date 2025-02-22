//
//  NUCTokenProtocol.h
//  Nursery
//
//  Created by akiha on 2025/02/15.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>


@protocol NUCToken <NSObject>

- (BOOL)isKeyword;
- (BOOL)isIdentifier;
- (BOOL)isConstant;
- (BOOL)isStringLiteral;
- (BOOL)isPunctuator;

- (BOOL)isOpeningBrace;
- (BOOL)isClosingBrace;

- (BOOL)isIntegerConstant;
- (BOOL)isCharacterConstant;
- (BOOL)isPpNumber;
- (BOOL)isUnaryPlusOperator;
- (BOOL)isUnaryMinusOperator;
- (BOOL)isBitwiseComplementOperator;
- (BOOL)isLogicalNegationOperator;
- (BOOL)isUndef;
- (BOOL)isLine;
- (BOOL)isError;
- (BOOL)isPragma;
- (BOOL)isControlNewline;
- (BOOL)isWhitespace;
- (BOOL)isNotWhitespace;
- (BOOL)isMacroInvocation;
- (BOOL)isPpTokensWithMacroInvocations;
- (BOOL)isOpeningParenthesis;
- (BOOL)isPlacemaker;
- (BOOL)isMacroArgument;
- (BOOL)isConcatenatedToken;
- (BOOL)isHash;
- (BOOL)isHashHash;
- (BOOL)isComma;
- (BOOL)isPeriod;
- (BOOL)isQuestionMark;
- (BOOL)isColon;
- (BOOL)isSemicolon;
- (BOOL)isEllipsis;
- (BOOL)isDirectiveName;
- (BOOL)isNonDirectiveName;
- (BOOL)isLogicalOROperator;
- (BOOL)isLogicalANDOperator;
- (BOOL)isInclusiveOROperator;
- (BOOL)isExclusiveOROperator;
- (BOOL)isBitwiseANDOperator;
- (BOOL)isInequalityOperator;
- (BOOL)isEqualityOperator;
- (BOOL)isEqualToOperator;
- (BOOL)isNotEqualToOperator;
- (BOOL)isRelationalOperator;
- (BOOL)isLessThanOperator;
- (BOOL)isGreaterThanOperator;
- (BOOL)isLessThanOrEqualToOperator;
- (BOOL)isGreaterThanOrEqualToOperator;
- (BOOL)isShiftOperator;
- (BOOL)isLeftShiftOperator;
- (BOOL)isRightShiftOperator;
- (BOOL)isAdditiveOperator;
- (BOOL)isAdditionOperator;
- (BOOL)isSubtractionOperator;
- (BOOL)isMultiplicativeOperator;
- (BOOL)isMultiplicationOperator;
- (BOOL)isDivisionOperator;
- (BOOL)isRemainderOperator;
- (BOOL)isUnaryOperator;
- (BOOL)isWhitespacesWithoutNewline;
- (BOOL)isNewLine;
- (BOOL)isNotNewLine;
- (BOOL)isClosingParenthesis;
- (BOOL)isPredefinedMacroVA_ARGS;
- (BOOL)isReturn;

@end
