//
//  NUCPreprocessingTokenStream.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/01/29.
//

#import "NUCTokenStream.h"

@class NUCDecomposedPreprocessingToken;
@class NSArray;

@interface NUCPreprocessingTokenStream : NUCTokenStream
{
    NSArray *preprocessingTokens;
}

+ (instancetype)preprecessingTokenStreamWithPreprocessingTokens:(NSArray *)aPreprocessingTokens;

- (instancetype)initWithPreprocessingTokens:(NSArray *)aPreprocessingTokens;

- (NUCDecomposedPreprocessingToken *)next;
- (NUCDecomposedPreprocessingToken *)previous;

- (BOOL)hasNext;
- (BOOL)hasPrevious;

- (NSArray *)preprocessingTokens;

- (BOOL)skipWhitespaces;
- (BOOL)skipWhitespacesWithoutNewline;

- (NSArray *)scanWhiteSpaces;

- (NUCDecomposedPreprocessingToken *)peekNext;
- (NUCDecomposedPreprocessingToken *)peekPrevious;

- (BOOL)nextIsWhitespaces;
- (BOOL)nextIsWhitespacesWithoutNewline;

@end
