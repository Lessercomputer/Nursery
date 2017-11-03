//
//  NULocationTree.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/16.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NURegionTree.h"

@class NULengthTree, NULocationTreeLeaf;

@interface NULocationTree : NURegionTree
{
	NULengthTree *lengthTree;
}

- (id)initWithRootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces;

- (NULocationTreeLeaf *)getNodeContainingSpaceAtLocation:(NUUInt64)aLocation keyIndex:(NUUInt32 *)aKeyIndex;
- (NULocationTreeLeaf *)getNodeContainingSpaceAtLocationGraterThanOrEqual:(NUUInt64)aLocation keyIndex:(NUUInt32 *)aKeyIndex;
- (NULocationTreeLeaf *)getNodeContainingSpaceAtLocationLessThanOrEqual:(NUUInt64)aLocation keyIndex:(NUUInt32 *)aKeyIndex;

- (NURegion)regionFor:(NUUInt64)aLocation;
- (void)setRegion:(NURegion)aRegion;
- (void)removeRegionFor:(NUUInt64)aLocation;

@end
