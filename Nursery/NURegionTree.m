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

- (void)branch:(NUOpaqueBPlusTreeBranch *)aBranch didInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
    [self lock];
    [[self spaces] lock];
    
	NUUInt64 *aNodes = (NUUInt64 *)aNodeLocations;
	int i = 0;
	for (; i < aCount; i++)
		if ([[self spaces] nodePageLocationIsVirtual:aNodes[i]])
			[[self spaces] addBranchNeedsVirtualPageCheck:aBranch];
    
    [[self spaces] unlock];
    [self unlock];
}

@end
