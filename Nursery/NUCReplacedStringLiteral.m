//
//  NUCReplacedStringLiteral.m
//  Nursery
//
//  Created by aki on 2023/07/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCReplacedStringLiteral.h"
#import <Foundation/NSArray.h>

@implementation NUCReplacedStringLiteral

+ (instancetype)replacedStringLiteral
{
    return [self replacedStringLiteralWithPpTokens:nil];
}

+ (instancetype)replacedStringLiteralWithPpTokens:(NSMutableArray *)aPpTokens
{
    return [[[self alloc] initWithPpTokens:aPpTokens] autorelease];
}

- (instancetype)initWithPpTokens:(NSMutableArray *)aPpTokens
{
    if (self = [super initWithType:NUCLexicalElementNone])
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

-(NSMutableArray *)ppTokens
{
    if (!ppTokens)
        ppTokens = [NSMutableArray new];
    
    return ppTokens;
}

@end
