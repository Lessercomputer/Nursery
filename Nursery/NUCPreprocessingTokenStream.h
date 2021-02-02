//
//  NUCPreprocessingTokenStream.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/01/29.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NUCPreprocessingToken;
@class NSArray;

@interface NUCPreprocessingTokenStream : NSObject
{
    NSArray *preprocessingTokens;
    NSUInteger position;
    NSUInteger storedPosition;
}

+ (instancetype)preprecessingTokenStreamWithPreprocessingTokens:(NSArray *)aPreprocessingTokens;

- (instancetype)initWithPreprocessingTokens:(NSArray *)aPreprocessingTokens;

- (NUCPreprocessingToken *)next;
- (NSUInteger)position;
- (void)storePosition;
- (void)restorePosition;
- (BOOL)hasNext;
- (NSArray *)preprocessingTokens;

@end
