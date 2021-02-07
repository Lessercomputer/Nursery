//
//  NUCGroup.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCGroup.h"

#import <Foundation/NSArray.h>

@implementation NUCGroup

+ (instancetype)group
{
    return [[[self alloc] initWithType:NUCLexicalElementGroupType] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        groupParts = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [groupParts release];
    
    [super dealloc];
}

- (NSMutableArray *)groupParts
{
    return groupParts;
}

- (NSUInteger)count
{
    return [[self groupParts] count];
}

- (void)add:(NUCPreprocessingToken *)aGroupPart
{
    [[self groupParts] addObject:aGroupPart];
}

@end
