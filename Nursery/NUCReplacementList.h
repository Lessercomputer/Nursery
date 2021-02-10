//
//  NUCReplacementList.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/10.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPpTokens;

@interface NUCReplacementList : NUCPreprocessingDirective
{
    NUCPpTokens *ppTokens;
}

+ (instancetype)replacementListWithPpTokens:(NUCPpTokens *)aPpTokens;

- (instancetype)initWithPpTokens:(NUCPpTokens *)aPpTokens;

@end

