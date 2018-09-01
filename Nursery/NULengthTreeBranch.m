//
//  NULengthTreeBranch.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/16.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NULengthTreeBranch.h"
#import "NUObjectTable.h"
#import "NURegionArray.h"
#import "NUIndexArray.h"
#import "NUSpaces.h"


@implementation NULengthTreeBranch

+ (NUUInt64)nodeOOP
{
	return NULengthTreeBranchNodeOOP;
}

- (NUOpaqueArray *)makeKeyArray
{
	return [[[NURegionArray alloc] initWithCapacity:[self keyCapacity] comparator:[tree comparator]] autorelease];
}

//- (void)releaseNodePageAndCache
//{
//    [[tree spaces] removeBranchNeedsVirtualPageCheck:self];
//    [super releaseNodePageAndCache];
//}

@end
