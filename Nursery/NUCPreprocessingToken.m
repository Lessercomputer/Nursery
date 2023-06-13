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

- (void)dealloc
{
    [macroExpandedPpTokens release];
    
    [super dealloc];
}

- (NSArray *)macroExpandedPpTokens
{
    return macroExpandedPpTokens;
}

- (void)setMacroExpandedPpTokens:(NSArray *)aMacroExpandedPpTokens
{
    [macroExpandedPpTokens release];
    macroExpandedPpTokens = [aMacroExpandedPpTokens retain];
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    
}

@end
