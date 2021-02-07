//
//  NUCPpTokens.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"


@interface NUCPpTokens : NUCPreprocessingToken
{
    NSMutableArray *ppTokens;
}

+ (instancetype)ppTokens;

- (void)add:(NUCPreprocessingToken *)aPpToken;

- (NSMutableArray *)ppTokens;
- (NSUInteger)count;

@end

