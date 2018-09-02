//
//  NURegionTree.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/26.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NURegionTree.h"
#import "NUOpaqueBPlusTreeNode.h"
#import "NURegion.h"
#import "NUPages.h"
#import "NUSpaces.h"


@implementation NURegionTree

- (NUUInt64)allocateNodePageLocation
{
	return [[self spaces] allocateVirtualNodePageLocation];
}

- (void)releaseNodePageLocation:(NUUInt64)aNodePage
{
	[[self spaces] delayedReleaseNodePageLocation:aNodePage];
}

@end
