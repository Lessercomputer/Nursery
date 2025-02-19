//
//  NUCPreprocessingTokenToTokenStream.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import <Foundation/NSObject.h>
#import "NUCTokenProtocol.h"

@class NSArray;

@interface NUCPreprocessingTokenToTokenStream : NSObject

- (instancetype)initWithPreprocessingTokens:(NSArray *)aPreprocessingTokens;

@property (nonatomic, retain) NSArray *preprocessingTokens;
@property (nonatomic) NSUInteger position;

- (id <NUCToken>)next;

@end

