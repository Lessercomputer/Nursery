//
//  NURegionTree.m
//  Nursery
//
//  Created by P,T,A on 10/09/26.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NURegionTree.h"
#import "NUOpaqueBTreeNode.h"
#import "NURegion.h"
#import "NUPages.h"
#import "NUSpaces.h"


@implementation NURegionTree

- (NUUInt64)allocateNodePage
{
	return [[self spaces] allocateVirtualNodePage];
}

- (void)releaseNodePage:(NUUInt64)aNodePage
{
	[[self spaces] delayedReleaseNodePage:aNodePage];
}

- (void)branch:(NUOpaqueBTreeBranch *)aBranch didInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	NUUInt64 *aNodes = (NUUInt64 *)aNodeLocations;
	int i = 0;
	for (; i < aCount; i++)
		if ([[self spaces] nodePageLocationIsVirtual:aNodes[i]])
			[[self spaces] addBranchNeedsVirtualPageCheck:aBranch];
}

@end
