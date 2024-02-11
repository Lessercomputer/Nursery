//
//  NUCPreprocessingTokenToTokenConverter.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/02/11.
//

#import <Foundation/NSObject.h>
#import "NUCLexicalElement.h"

@class NSArray;

@interface NUCPreprocessingTokenToTokenConverter : NSObject

- (instancetype)initWithPreprocessingTokens:(NSArray *)aPreprocessingTokens;

@property (nonatomic, retain) NSArray *preprocessingTokens;
@property (nonatomic) NSUInteger position;

- (id <NUCToken>)next;

@end

