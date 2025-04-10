//
//  NUCTranslationMap.m
//  Nursery
//
//  Created by akiha on 2025/04/10.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCTranslationOrderMap.h"
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSNull.h>

@implementation NUCTranslationOrderMap

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mappingDictionary = [NSMutableDictionary new];
    }
    return self;
}

- (void)dealloc
{
    [_mappingDictionary release];
    
    [super dealloc];
}

- (void)add:(id)aNode parent:(id)aParent depth:(NUUInt64)aDepth
{
    if (aDepth > [self depth])
        _depth = aDepth;
    
    NSMutableDictionary *aDictionary = [[self mappingDictionary] objectForKey:@(aDepth)];
    if (!aDictionary)
    {
        aDictionary = [NSMutableDictionary dictionary];
        [[self mappingDictionary] setObject:aDictionary forKey:@(aDepth)];
    }
    
    if (!aParent)
        aParent = [NSNull null];
    
    NSMutableArray *aSiblings = [aDictionary objectForKey:aParent];
    if (!aSiblings)
    {
        aSiblings = [NSMutableArray array];
        [aDictionary setObject:aSiblings forKey:[NSValue valueWithNonretainedObject:aParent]];
    }
    
    [aSiblings addObject:aNode];
}

- (NSMutableArray *)siblingsFor:(id)aParent depth:(NUUInt64)aDepth
{
    NSMutableDictionary *aDictionary = [[self mappingDictionary] objectForKey:@(aDepth)];
    if (!aDictionary)
        return nil;
    
    NSMutableArray *aSiblings = [aDictionary objectForKey:aParent];
    return aSiblings;
}

- (NSMutableArray *)mappingArray
{
    NSMutableArray *anArray = [NSMutableArray array];
    
    for (NSUInteger i = 0; i <= [self depth]; i++)
    {
        [anArray addObject:[[self mappingDictionary] objectForKey:@(i)]];
    }
    
    return anArray;
}

@end
