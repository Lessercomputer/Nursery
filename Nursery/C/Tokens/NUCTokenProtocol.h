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

- (BOOL)isOpeningParenthesis;
- (BOOL)isClosingParenthesis;
- (BOOL)isComma;
- (BOOL)isEllipsis;
- (BOOL)isOpeningBrace;
- (BOOL)isClosingBrace;

@end
