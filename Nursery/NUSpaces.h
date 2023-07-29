//
//  NUSpaces.h
//  Nursery
//
//  Created by Akifumi Takata on 10/12/23.
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
	NUPages *pages;
	NUMainBranchNursery *nursery;
    NSRecursiveLock *lock;
    NUU64ODictionary *nodeOOPToTreeDictionary;
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

- (void)willWriteLog;
- (void)didWriteLog;

@end

@interface NUSpaces (RegionSpace)

- (NURegion)freeSpaceBeginningAtLocationGreaterThanOrEqual:(NUUInt64)aLocation;
- (NURegion)freeSpaceBeginningAtLocationLessThanOrEqual:(NUUInt64)aLocation;
- (NUUInt64)lastLocationInUse;
- (NUUInt64)lastLocationInUseOfTrees;
- (NUUInt64)allocateSpace:(NUUInt64)aLength;
- (NUUInt64)allocateSpace:(NUUInt64)aLength aligned:(BOOL)anAlignFlag preventsNodeReleaseAsMuchAsPossible:(BOOL)aPreventsNodeReleaseAsMuchAsPossible;
- (NUUInt64)allocateSpaceFrom:(NULengthTreeLeaf *)aLengthTreeLeaf region:(NURegion)aRegion length:(NUUInt64)aLength aligned:(BOOL)anAlignFlag preventsNodeReleaseAsMuchAsPossible:(BOOL)aPreventsNodeReleaseAsMuchAsPossible;
- (NUUInt64)extendSpaceBy:(NUUInt64)aLength;
- (void)releaseSpace:(NURegion)aRegion;
- (BOOL)minimizeSpaceIfPossible;

- (NUUInt64)pageStatingLocationFor:(NUUInt64)aLocation;

@end

@interface NUSpaces (NodeSpace)

- (NUUInt64)allocateNodePageLocation;
- (void)releaseNodePageAt:(NUUInt64)aNodePage;

- (NUUInt64)allocateVirtualNodePageLocation;
- (void)delayedReleaseNodePageLocation:(NUUInt64)aNodePage;
- (NUUInt64)allocateNodePageLocationWithPreventsNodeReleaseAsMuchAsPossible;
- (void)initNextVirtualPageLocation;
- (NUUInt64)firstVirtualPageLocation;
- (BOOL)nodePageLocationIsVirtual:(NUUInt64)aNodePageLocation;
- (BOOL)nodePageLocationIsNotVirtual:(NUUInt64)aNodePageLocation;
- (NSMutableSet *)nodePageLocationsToBeReleased;

- (void)fixNodePages;
- (void)releaseNodePagesToBeReleased;
- (void)fixVirtualNodePages;

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
