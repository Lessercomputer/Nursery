//
//  NUCElifGroups.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCElifGroups.h"

#import <Foundation/NSArray.h>

@implementation NUCElifGroups

+ (instancetype)elifGroups
{
    return [[[self alloc] initWithType:NUCLexicalElementElifGroups] autorelease];
}

- (instancetype)initWithType:(NUCLexicalElementType)aType
{
    if (self = [super initWithType:aType])
    {
        groups = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [groups release];
    
    [super dealloc];
}

- (void)add:(NUCElifGroup *)anElifGroup
{
    [[self groups] addObject:anElifGroup];
}

- (NSMutableArray *)groups
{
    return groups;
}

- (NSUInteger)count
{
    return [[self groups] count];
}

@end
