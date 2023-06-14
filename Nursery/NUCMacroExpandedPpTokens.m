//
//  NUCMacroExpandedPpTokens.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/14.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCMacroExpandedPpTokens.h"

#import <Foundation/NSArray.h>

@implementation NUCMacroExpandedPpTokens

+ (instancetype)ppTokens
{
    return [[self new] autorelease];
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

- (void)add:(NUCPreprocessingToken *)aPpToken
{
    [[self ppTokens] addObject:aPpToken];
}

- (NSMutableArray *)ppTokens
{
    if (!ppTokens)
        ppTokens = [NSMutableArray new];
    
    return ppTokens;
}

@end
