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

- (BOOL)isWhitespace
{
    return [self type] == NUCLexicalElementWhiteSpaceCharacterType || [self type] == NUCLexicalElementCommentType;
}

- (BOOL)isNotWhitespace
{
    return ![self isWhitespace];
}

- (BOOL)isMacroInvocation
{
    return NO;
}

- (BOOL)isPpTokensWithMacroInvocations
{
    return NO;
}

- (BOOL)isOpeningParenthesis
{
    return NO;
}

- (BOOL)isPlacemaker
{
    return NO;
}

- (BOOL)isMacroArgument
{
    return NO;
}

- (BOOL)isConcatenatedToken
{
    return NO;
}

- (void)addUnexpandedPpTokensTo:(NSMutableArray *)aPpTokens
{
    [aPpTokens addObject:self];
}

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens
{
    [aPpTokens addObject:self];
}

@end
