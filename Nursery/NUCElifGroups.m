//
//  NUCElifGroups.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCElifGroups.h"
#import "NUCPreprocessingTokenStream.h"
#import "NUCElifGroup.h"

#import <Foundation/NSArray.h>

@implementation NUCElifGroups

+ (BOOL)elifGroupsFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCElifGroups **)aToken
{
    NUCElifGroups *anElifGroups = [NUCElifGroups elifGroups];
    NUCElifGroup *anElifGroup = nil;
    
    while ([NUCElifGroup elifGroupFrom:aStream into:&anElifGroup])
        [anElifGroups add:anElifGroup];

    if (aToken && [anElifGroups count])
        *aToken = anElifGroups;
    
    return [anElifGroups count] ? YES : NO;
}

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
