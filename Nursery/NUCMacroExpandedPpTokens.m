//
//  NUCMacroExpandedPpTokens.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCMacroExpandedPpTokens.h"
#import "NUCControlLineDefine.h"
#import "NUCPreprocessor.h"

#import <Foundation/NSArray.h>

@implementation NUCMacroExpandedPpTokens

- (instancetype)init
{
    return [self initWithDefine:nil];
}

- (instancetype)initWithDefine:(NUCControlLineDefine *)aDefine
{
    if (self = [super initWithType:NUCLexicalElementNone])
    {
        define = aDefine;
        expandedPpTokens = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [expandedPpTokens release];
    
    [super dealloc];
}

- (NUCControlLineDefine *)define
{
    return define;
}

- (void)setDefine:(NUCControlLineDefine *)aDefine
{
    define = aDefine;
}

- (NSMutableArray *)expandedPpTokens
{
    return expandedPpTokens;
}

- (void)add:(NUCDecomposedPreprocessingToken *)aPpToken
{
    [[self expandedPpTokens] addObject:aPpToken];
}

@end
