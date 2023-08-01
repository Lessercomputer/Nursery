//
//  NUCPreprocessingToken.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

#import <Foundation/NSArray.h>

@implementation NUCPreprocessingToken

- (BOOL)isMacroInvocation
{
    return NO;
}

- (BOOL)isPpTokensWithMacroInvocations
{
    return NO;
}

@end
