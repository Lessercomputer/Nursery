//
//  NUCPpTokens.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCDecomposedPreprocessingToken;

@interface NUCPpTokens : NUCPreprocessingDirective
{
    NSMutableArray *ppTokens;
}

+ (instancetype)ppTokens;

- (void)add:(NUCDecomposedPreprocessingToken *)aPpToken;

- (NSMutableArray *)ppTokens;
- (NSUInteger)count;

@end

