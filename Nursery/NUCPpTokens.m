//
//  NUCPpTokens.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPpTokens.h"
#import "NUCDecomposedPreprocessingToken.h"

#import <Foundation/NSArray.h>

@implementation NUCPpTokens

+ (instancetype)ppTokens
{
    return [[[self alloc] initWithType:NUCLexicalElementPpTokensType] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        ppTokens = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

- (void)add:(NUCDecomposedPreprocessingToken *)aPpToken
{
    [[self ppTokens] addObject:aPpToken];
}

- (NSMutableArray *)ppTokens
{
    return ppTokens;
}

- (NSUInteger)count
{
    return [[self ppTokens] count];
}

@end
