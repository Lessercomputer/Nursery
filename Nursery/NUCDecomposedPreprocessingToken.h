//
//  NUCPreprocessingToken.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@interface NUCDecomposedPreprocessingToken : NUCPreprocessingToken
{
    NSString *content;
    NURegion range;
}

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

+ (instancetype)preprocessingTokenWithContent:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

+ (instancetype)preprocessingTokenWithRange:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

+ (instancetype)preprocessingTokenWithContent:(NSString *)aContent region:(NURegion)aRange type:(NUCLexicalElementType)anElementType;

- (instancetype)initWithRange:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

- (instancetype)initWithContentFromString:(NSString *)aString range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange type:(NUCLexicalElementType)anElementType;

- (instancetype)initWithContent:(NSString *)aContent region:(NURegion)aRange type:(NUCLexicalElementType)anElementType;

- (NSString *)content;

- (BOOL)isHash;
- (BOOL)isIdentifier;
- (BOOL)isComma;
- (BOOL)isPeriod;
- (BOOL)isWhitespace;
- (BOOL)isNotWhitespace;
- (BOOL)isWhitespacesWithoutNewline;

@end
