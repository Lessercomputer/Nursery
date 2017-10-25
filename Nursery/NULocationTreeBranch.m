//
//  NULocationTreeBranch.m
//  Nursery
//
//  Created by P,T,A on 10/10/17.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NULocationTreeBranch.h"
#import "NUObjectTable.h"
#import "NURegionArray.h"
#import "NUIndexArray.h"
#import "NUSpaces.h"


@implementation NULocationTreeBranch

+ (NUUInt64)nodeOOP
{
	return NULocationTreeBranchNodeOOP;
}

- (void)releaseNodePageAndCache
{
	[[tree spaces] removeBranchNeedsVirtualPageCheck:self];
	[super releaseNodePageAndCache];
}

@end
