//
//  NUCPreprocessingTokenToTokenStream.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import "NUCTokenStream.h"

@class NSArray;

@interface NUCPreprocessingTokenToTokenStream : NUCTokenStream

- (instancetype)initWithPreprocessingTokens:(NSArray *)aPreprocessingTokens;

@property (nonatomic, retain) NSArray *preprocessingTokens;

@end

