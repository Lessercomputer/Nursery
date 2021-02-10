//
//  NUCReplacementList.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/10.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCReplacementList.h"

@implementation NUCReplacementList

+ (instancetype)replacementListWithPpTokens:(NUCPpTokens *)aPpTokens
{
    return [[[self alloc] initWithPpTokens:aPpTokens] autorelease];
}

- (instancetype)initWithPpTokens:(NUCPpTokens *)aPpTokens
{
    if (self = [super initWithType:NUCLexicalElementReplacementListType])
    {
        ppTokens = [aPpTokens retain];
    }
    
    return self;
}

- (void)dealloc
{
    [ppTokens release];
    
    [super dealloc];
}

@end
