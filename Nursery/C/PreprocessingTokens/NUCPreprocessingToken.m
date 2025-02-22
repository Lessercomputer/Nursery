//
//  NUCPreprocessingToken.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//

#import "NUCPreprocessingToken.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>

@implementation NUCPreprocessingToken

- (void)addUnexpandedPpTokensTo:(NSMutableArray *)aPpTokens
{
    [aPpTokens addObject:self];
}

- (void)addExpandedPpTokensTo:(NSMutableArray *)aPpTokens
{
    [aPpTokens addObject:self];
}

@end
