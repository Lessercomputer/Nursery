//
//  NULengthTree.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/16.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NULengthTree.h"
#import "NUObjectTable.h"
#import "NULengthTreeLeaf.h"
#import "NULengthTreeBranch.h"
#import "NUPage.h"
#import "NUPages.h"
#import "NURegion.h"

const NUUInt64 NULengthTreeRootLocationOffset = 21;

static NUComparisonResult compareRegion(NUUInt8 *aRegion1Pointer, NUUInt8 *aRegion2Pointer)
{
	NURegion aRegion1 = *(NURegion *)aRegion1Pointer, aRegion2 = *(NURegion *)aRegion2Pointer;
	
	if (aRegion1.length < aRegion2.length)
		return NUOrderedAscending;
	else if (aRegion1.length > aRegion2.length)
		return NUOrderedDescending;
	else
	{
		if (aRegion1.location < aRegion2.location)
			return NUOrderedAscending;
		else if (aRegion1.location > aRegion2.location)
			return NUOrderedDescending;
		else
			return NUOrderedSame;
	}
}

@implementation NULengthTree

- (id)initWithRootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces
{
	return [super initWithKeyLength:sizeof(NURegion) leafValueLength:0 rootLocation:aRootLocation on:aSpaces];
}

- (NULengthTreeLeaf *)getNodeContainingSpaceOfLengthGreaterThanOrEqual:(NUUInt64)aLength keyIndex:(NUUInt32 *)aKeyIndex
{
	NURegion aRegion = NUMakeRegion(0, aLength);
	return (NULengthTreeLeaf *)[self leafNodeContainingKeyGreaterThenOrEqualTo:(NUUInt8 *)&aRegion keyIndex:aKeyIndex];
}

- (void)setRegion:(NURegion)aRegion
{
	[self setOpaqueValue:NULL forKey:(NUUInt8 *)&aRegion];
}

- (void)removeRegion:(NURegion)aRegion
{
	[self removeValueFor:(NUUInt8 *)&aRegion];
}

- (Class)branchNodeClass
{
	return [NULengthTreeBranch class];
}

- (Class)leafNodeClass
{
	return [NULengthTreeLeaf class];
}

+ (NUUInt64)rootLocationOffset
{
	return NULengthTreeRootLocationOffset;
}

- (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator
{
	return compareRegion;
}

@end
