//
//  NUCPreprocessingToken.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
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
- (NSString *)stringForSubstitution;
- (void)addStringTo:(NSMutableString *)aString;
- (void)addStringForConcatinationTo:(NSMutableString *)aString;

@end
