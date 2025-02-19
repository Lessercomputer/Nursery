//
//  NUCBlockItemList.m
//  Nursery
//
//  Created by akiha on 2025/02/19.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUCBlockItemList.h"
#import "NUCPreprocessingTokenToTokenStream.h"
#import "NUCBlockItem.h"
#import <Foundation/NSArray.h>

@implementation NUCBlockItemList

+ (BOOL)blockItemListFrom:(NUCPreprocessingTokenToTokenStream *)aStream into:(NUCBlockItemList **)aBlockItemList
{
    NUCBlockItemList *aBlockItemListToReturn = [[self new] autorelease];
    NUCBlockItem *aBlockItem = nil;
    
    while ([NUCBlockItem blockItemFrom:aStream into:&aBlockItem])
        [aBlockItemListToReturn add:aBlockItem];
    
    if (aBlockItemList)
        *aBlockItemList = aBlockItemListToReturn;
    return YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_list release];
    [super dealloc];
}

- (void)add:(NUCBlockItem *)aBlockItem
{
    [[self list] addObject:aBlockItem];
}

@end
