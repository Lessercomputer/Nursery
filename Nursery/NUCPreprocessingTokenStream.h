//
//  NUCPreprocessingTokenStream.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/01/29.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
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
- (NSUInteger)position;
- (void)setPosition:(NSUInteger)aPosition;
- (BOOL)hasNext;
- (NSArray *)preprocessingTokens;
- (BOOL)skipWhitespaces;
- (BOOL)skipWhitespacesWithoutNewline;
- (NUCDecomposedPreprocessingToken *)peekNext;
- (NUCDecomposedPreprocessingToken *)peekPrevious;
- (BOOL)nextIsWhitespaces;
- (BOOL)nextIsWhitespacesWithoutNewline;

@end
