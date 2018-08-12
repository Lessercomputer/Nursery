//
//  NUSpaces.h
//  Nursery
//
//  Created by Akifumi Takata on 10/12/23.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

#import "NUTypes.h"

@class NSString, NSMutableSet, NSCountedSet, NSMutableArray, NSMutableDictionary, NSFileHandle, NSRecursiveLock;
@class NULocationTree, NULengthTree, NULengthTreeLeaf, NUOpaqueBPlusTreeNode, NUOpaqueBPlusTreeBranch, NUPages, NUMainBranchNursery, NUCharacter, NUU64ODictionary;

extern NSString *NURegionAlreadyReleasedException;
extern NSString *NUSpaceInvalidOperationException;

@interface NUSpaces : NSObject
{
	NULocationTree *locationTree;
	NULengthTree *lengthTree;
	NUUInt64 nextVirtualPageLocation;
	NSMutableSet *pagesToBeReleased;
	NSMutableSet *branchesNeedVirtualPageCheck;
	NSMutableDictionary *virtualToRealNodePageDictionary;
	NUPages *pages;
	NUMainBranchNursery *nursery;
    NSRecursiveLock *lock;
    NUU64ODictionary *nodeOOPToTreeDictionary;
    NSMutableSet *releasedNodePageLocations;
    NUUInt64 inRelese;
    NUUInt64 inAlloc;
    NSCountedSet *releasedRegion;
    NSCountedSet *allocatedRegion;
}
@end

@interface NUSpaces (Initializing)

+ (id)spacesWithNursery:(NUMainBranchNursery *)aNursery;

- (id)initWithNursery:(NUMainBranchNursery *)aNursery;

@end

@interface NUSpaces (Accessing)

- (NUPages *)pages;
- (void)setPages:(NUPages *)aPages;

- (NUMainBranchNursery *)nursery;
- (void)setNursery:(NUMainBranchNursery *)aNursery;

- (NUU64ODictionary *)nodeOOPToTreeDictionary;

- (void)setFileHandle:(NSFileHandle *)aFileHandle;

- (NULocationTree *)locationTree;
- (NULengthTree *)lengthTree;

@end

@interface NUSpaces (SaveAndLoad)

- (void)save;
- (void)load;

@end

@interface NUSpaces (RegionSpace)

- (NURegion)nextParaderTargetFreeSpaceForLocation:(NUUInt64)aLocation;
- (NURegion)freeSpaceContainingSpaceAtLocationGreaterThanOrEqual:(NUUInt64)aLocation;
- (NURegion)freeSpaceContainingSpaceAtLocationLessThanOrEqual:(NUUInt64)aLocation;
- (NUUInt64)allocateSpace:(NUUInt64)aLength;
- (NUUInt64)allocateSpace:(NUUInt64)aLength aligned:(BOOL)anAlignFlag preventsNodeRelease:(BOOL)aPreventsNodeReleaseFlag;
- (NUUInt64)allocateSpaceFrom:(NULengthTreeLeaf *)aLengthTreeLeaf region:(NURegion)aRegion length:(NUUInt64)aLength aligned:(BOOL)anAlignFlag preventsNodeRelease:(BOOL)aPreventsNodeReleaseFlag;
- (NUUInt64)extendSpaceBy:(NUUInt64)aLength;
- (void)releaseSpace:(NURegion)aRegion;
- (void)minimizeSpace;

- (NUUInt64)pageStatingLocationFor:(NUUInt64)aLocation;

@end

@interface NUSpaces (NodeSpace)

- (NUUInt64)allocateNodePageLocation;
- (void)releaseNodePageAt:(NUUInt64)aNodePage;

- (NUUInt64)allocateVirtualNodePageLocation;
- (void)delayedReleaseNodePageLocation:(NUUInt64)aNodePage;
- (NUUInt64)allocateNodePageLocationWithPreventNodeRelease;
- (void)initNextVirtualPageLocation;
- (NUUInt64)firstVirtualPageLocation;
- (BOOL)nodePageLocationIsVirtual:(NUUInt64)aNodePageLocation;
- (BOOL)nodePageLocationIsNotVirtual:(NUUInt64)aNodePageLocation;
- (NSMutableSet *)nodePageLocationsToBeReleased;
- (void)addBranchNeedsVirtualPageCheck:(NUOpaqueBPlusTreeBranch *)aBranch;
- (void)removeBranchNeedsVirtualPageCheck:(NUOpaqueBPlusTreeBranch *)aBranch;

- (void)fixNodePages;
- (void)releaseNodePagesToBeReleased;
- (void)fixVirtualNodePages;
- (void)setNodePageLocation:(NUUInt64)aPageLocation forVirtualNodePageLocation:(NUUInt64)aVirtualNodePageLocation;
- (NUUInt64)nodePageLocationForVirtualNodePageLocation:(NUUInt64)aVirtualNodePageLocation;

- (NUOpaqueBPlusTreeNode *)nodeFor:(NUUInt64)aNodeLocation;

- (BOOL)nodePageIsToBeReleased:(NUUInt64)aNodeLocation;
- (BOOL)nodePageIsNotToBeReleased:(NUUInt64)aNodeLocation;
- (void)removeNodePageLocationToBeReleased:(NUUInt64)aNodeLocation;
- (void)movePageToBeReleasedAtLocation:(NUUInt64)aNodeLocation toLocation:(NUUInt64)aNewLocation;

@end

@interface NUSpaces (Locking)

- (void)lock;
- (void)unlock;

@end

@interface NUSpaces (Private)

- (void)prepareNodeOOPToTreeDictionary;

- (void)setRegion:(NURegion)aRegion;
- (void)removeRegion:(NURegion)aRegion;

@end

@interface NUSpaces (Debug)

- (void)validate;
- (BOOL)validateFreeRegions;

@end
