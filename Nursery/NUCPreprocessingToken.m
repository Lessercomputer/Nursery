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

- (NUCPreprocessingToken *)macroExpandedPpTokens
{
    return macroExpandedPpTokens;
}

- (void)setMacroExpandedPpTokens:(NUCPreprocessingToken *)aMacroExpandedPpTokens
{
    [aMacroExpandedPpTokens retain];
    [macroExpandedPpTokens release];
    macroExpandedPpTokens = aMacroExpandedPpTokens;
}

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor
{
    
}

@end
