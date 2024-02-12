//
//  NUCPreprocessingTokenStream.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/01/29.
//

#import <Foundation/NSObject.h>

@class NUCDecomposedPreprocessingToken;
@class NSArray;

@interface NUCPreprocessingTokenStream : NSObject
{
    NSArray *preprocessingTokens;
    NSUInteger position;
}

+ (instancetype)preprecessingTokenStreamWithPreprocessingTokens:(NSArray *)aPreprocessingTokens;

- (instancetype)initWithPreprocessingTokens:(NSArray *)aPreprocessingTokens;

- (NUCDecomposedPreprocessingToken *)next;
- (NUCDecomposedPreprocessingToken *)previous;
- (NSUInteger)position;
- (void)setPosition:(NSUInteger)aPosition;
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
