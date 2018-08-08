//
//  NUSpaces.m
//  Nursery
//
//  Created by Akifumi Takata on 10/12/23.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSLock.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSException.h>

#import "NUSpaces.h"
#import "NUOpaqueBPlusTreeBranch.h"
#import "NULocationTree.h"
#import "NULocationTreeLeaf.h"
#import "NULengthTree.h"
#import "NULengthTreeLeaf.h"
#import "NURegion.h"
#import "NUPages.h"
#import "NUCharacter.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUObjectTable.h"
#import "NUReversedObjectTable.h"
#import "NUBell.h"
#import "NUU64ODictionary.h"

NSString *NURegionAlreadyReleasedException = @"NURegionAlreadyReleasedException";
NSString *NUSpaceInvalidOperationException = @"NUSpaceInvalidOperationException";

@implementation NUSpaces
@end

@implementation NUSpaces (Initializing)

+ (id)spacesWithNursery:(NUMainBranchNursery *)aNursery
{
	return [[[self alloc] initWithNursery:aNursery] autorelease];
}

- (id)initWithNursery:(NUMainBranchNursery *)aNursery
{
	if (self = [super init])
    {
        lock = [NSRecursiveLock new];
        [self setPages:[NUPages pagesWithSpaces:self]];
        [self setNursery:aNursery];
        nextVirtualPageLocation = (NUUInt64)[[self pages] pageSize] * (NUUInt64Max / [[self pages] pageSize] - 1);
        lengthTree = [[NULengthTree alloc] initWithRootLocation:0 on:self];
        locationTree = [[NULocationTree alloc] initWithRootLocation:0 on:self];
        pagesToBeReleased = [[NSMutableSet set] retain];
        branchesNeedVirtualPageCheck = [NSMutableSet new];
        virtualToRealNodePageDictionary = [NSMutableDictionary new];
    }
    
	return self;
}

- (void)dealloc
{
	[locationTree release];
	[lengthTree release];
	[self setNursery:nil];
	[self setPages:nil];
	[pagesToBeReleased release];
	[branchesNeedVirtualPageCheck release];
	[virtualToRealNodePageDictionary release];
    [nodeOOPToTreeDictionary release];
    [lock release];

	[super dealloc];
}

@end

@implementation NUSpaces (Accessing)

- (NUPages *)pages
{
	return pages;
}

- (void)setPages:(NUPages *)aPages
{
	[pages release];
	pages = [aPages retain];
}

- (NUMainBranchNursery *)nursery
{
	return nursery;
}

- (void)setNursery:(NUMainBranchNursery *)aNursery
{
	nursery = aNursery;
}

- (NUU64ODictionary *)nodeOOPToTreeDictionary
{
    return nodeOOPToTreeDictionary;
}

- (void)setFileHandle:(NSFileHandle *)aFileHandle
{
	[pages setFileHandle:aFileHandle];
}

- (NULocationTree *)locationTree
{
    return locationTree;
}

- (NULengthTree *)lengthTree
{
    return lengthTree;
}

@end

@implementation NUSpaces (SaveAndLoad)

- (void)save
{
	[self fixNodePages];
	[locationTree save];
	[lengthTree save];
	[[self pages] writeUInt64:[[self pages] nextPageLocation] at:NUNextPageLocationOffset];
	[[self pages] save];
}

- (void)load
{
	[[self pages] setSavedNextPageLocation:[[self pages] readUInt64At:NUNextPageLocationOffset]];
	[locationTree load];
	[lengthTree load];
}

@end

@implementation NUSpaces (RegionSpace)

- (NURegion)nextParaderTargetFreeSpaceForLocation:(NUUInt64)aLocation
{
    return [self freeSpaceContainingSpaceAtLocationGreaterThanOrEqual:aLocation];
}

- (NURegion)freeSpaceContainingSpaceAtLocationGreaterThanOrEqual:(NUUInt64)aLocation
{
    [self lock];
    
    NURegion aRegion;
    NUUInt32 aKeyIndex;
    NULocationTreeLeaf *aLeaf = [locationTree getNodeContainingSpaceAtLocationGreaterThanOrEqual:aLocation keyIndex:&aKeyIndex];
    
    if (!aLeaf) aRegion = NUMakeRegion(NUNotFound64, 0);
    else aRegion = [aLeaf regionAt:aKeyIndex];
    
    [self unlock];
    
    return aRegion;
}

- (NURegion)freeSpaceContainingSpaceAtLocationLessThanOrEqual:(NUUInt64)aLocation
{
    [self lock];
    
    NURegion aRegion;
    NUUInt32 aKeyIndex;
    NULocationTreeLeaf *aLeaf = [locationTree getNodeContainingSpaceAtLocationLessThanOrEqual:aLocation keyIndex:&aKeyIndex];
    
    if (!aLeaf) aRegion = NUMakeRegion(NUNotFound64, 0);
    else aRegion = [aLeaf regionAt:aKeyIndex];
    
    [self unlock];
    
    return aRegion;
}

- (NUUInt64)allocateSpace:(NUUInt64)aLength
{
	return [self allocateSpace:aLength aligned:NO preventsNodeRelease:NO];
}

- (NUUInt64)allocateSpace:(NUUInt64)aLength aligned:(BOOL)anAlignFlag preventsNodeRelease:(BOOL)aPreventsNodeReleaseFlag
{
    [self lock];
    
    NUUInt64 anAllocatedLocation = NUUInt64Max;
	NUUInt32 aKeyIndex;
	NULengthTreeLeaf *aNode = [lengthTree getNodeContainingSpaceOfLengthGreaterThanOrEqual:aLength keyIndex:&aKeyIndex];
	
	while (aNode && anAllocatedLocation == NUUInt64Max)
	{
		for (; aKeyIndex < [aNode keyCount] && anAllocatedLocation == NUUInt64Max; aKeyIndex++)
		{
			NURegion aRegion = *(NURegion *)[aNode keyAt:aKeyIndex];
            anAllocatedLocation = [self allocateSpaceFrom:aNode region:aRegion length:aLength aligned:anAlignFlag preventsNodeRelease:aPreventsNodeReleaseFlag];
            
			if (anAlignFlag && anAllocatedLocation != NUUInt64Max && (anAllocatedLocation % aLength != 0))
                @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil];
		}
		
		aKeyIndex = 0;
		aNode = (NULengthTreeLeaf *)[aNode rightNode];
	}
    
    if (anAllocatedLocation == NUUInt64Max)
        anAllocatedLocation = [self extendSpaceBy:aLength];
    
    [self unlock];
    
    return anAllocatedLocation;
}

- (NUUInt64)allocateSpaceFrom:(NULengthTreeLeaf *)aLengthTreeLeaf region:(NURegion)aRegion length:(NUUInt64)aLength aligned:(BOOL)anAlignFlag preventsNodeRelease:(BOOL)aPreventsNodeReleaseFlag
{
	NUUInt32 aKeyIndex;
	NULocationTreeLeaf *aLocationTreeLeaf = [locationTree getNodeContainingSpaceAtLocationLessThanOrEqual:aRegion.location keyIndex:&aKeyIndex];
	
	if (![aLengthTreeLeaf canPreventNodeReleseWhenValueRemovedOrAdded]
			|| ![aLocationTreeLeaf canPreventNodeReleseWhenValueRemovedOrAdded])
		return NUUInt64Max;
		
	if (anAlignFlag && aRegion.location % aLength != 0)
	{
		NUUInt64 aLocation = aLength * (aRegion.location / aLength + 1);
		NURegion aRegionToCut = NUMakeRegion(aLocation, aLength);
		
		if (NURegionInRegion(aRegionToCut, aRegion))
		{
			NURegion aRemainRegion1, aRemainRegion2;
			NURegionSplitWithRegion(aRegion, aRegionToCut, &aRemainRegion1, &aRemainRegion2);
            
			[self removeRegion:aRegion];
            [self releaseSpace:aRemainRegion1];
            
            if (aRemainRegion2.length) [self releaseSpace:aRemainRegion2];
			
			return aRegionToCut.location;
		}
	}
	else
	{
		NURegion aRemainSpace;
		NURegion aNewSpace = NURegionSplitWithLength(aRegion, aLength, &aRemainSpace);
        
		[self removeRegion:aRegion];
		
        if (aRemainSpace.length) [self releaseSpace:aRemainSpace];
		
		return aNewSpace.location;
	}

	return NUUInt64Max;
}

- (NUUInt64)extendSpaceBy:(NUUInt64)aLength
{
	NUUInt64 aPageCountToExtend = aLength / [[self pages] pageSize];
	NUUInt64 anOddLength = aLength % [[self pages] pageSize];
	NUUInt64 aNextPageLocation;
	
	if (anOddLength) aPageCountToExtend++;
		
	aNextPageLocation = [[self pages] appendPagesBy:aPageCountToExtend];
	
	if (anOddLength)
	{
		NURegion aFreeRegion = NUMakeRegion(
			[[self pages] nextPageLocation] - [[self pages] pageSize] + anOddLength,
			[[self pages] pageSize] - anOddLength);

        [self releaseSpace:aFreeRegion];
	}
	
	return aNextPageLocation;
}

- (void)releaseSpace:(NURegion)aRegion
{
    [self lock];
    
	NUUInt32 aKeyIndex;
	NULocationTreeLeaf *aNode = [locationTree getNodeContainingSpaceAtLocationLessThanOrEqual:aRegion.location keyIndex:&aKeyIndex];
	NURegion aLeftRegion = NUMakeRegion(0, 0), aRightRegion = NUMakeRegion(0, 0);
	
	if (aNode)
	{
		aLeftRegion = [aNode regionAt:aKeyIndex];
		
        if (NUIntersectsRegion(aLeftRegion, aRegion) && NUMaxLocation(aLeftRegion) != aRegion.location)
			[[NSException exceptionWithName:NURegionAlreadyReleasedException reason:nil userInfo:nil] raise];
				
		if (aKeyIndex < [aNode keyCount] - 1) aRightRegion = [aNode regionAt:aKeyIndex + 1];
		else if ([aNode rightNode]) aRightRegion = [(NULocationTreeLeaf *)[aNode rightNode] regionAt:0];
	}
	else if (![[locationTree mostLeftNode] isEmpty])
    {
		aRightRegion = [(NULocationTreeLeaf *)[locationTree mostLeftNode] regionAt:0];
    }
	
	if (aRightRegion.length != 0 && NUIntersectsRegion(aRegion, aRightRegion) && NUMaxLocation(aRegion) != aRightRegion.location)
		[[NSException exceptionWithName:NURegionAlreadyReleasedException reason:nil userInfo:nil] raise];
	
	if (NUMaxLocation(aLeftRegion) == aRegion.location)
	{
		[self removeRegion:aLeftRegion];
		aRegion = NUMakeRegion(aLeftRegion.location, aLeftRegion.length + aRegion.length);
	}
	
	if (aRightRegion.length != 0 && NUMaxLocation(aRegion) == aRightRegion.location)
	{
		[self removeRegion:aRightRegion];
		aRegion = NUMakeRegion(aRegion.location, aRegion.length + aRightRegion.length);
	}
    
	[self setRegion:aRegion];
    
    [self unlock];
}

- (void)minimizeSpace
{
    [self lock];
    
    NURegion aLastFreeRegion = [self freeSpaceContainingSpaceAtLocationLessThanOrEqual:[[self pages] nextPageLocation]];
    
    if (aLastFreeRegion.location != NUNotFound64 && NUMaxLocation(aLastFreeRegion) == [[self pages] nextPageLocation])
    {
        NUUInt64 aMinimumNextPageLocation = aLastFreeRegion.location;
        NURegion aNewFreeRegion = NUMakeRegion(NUNotFound64, 0);
        
        if (aLastFreeRegion.location % [[self pages] pageSize])
        {
            aMinimumNextPageLocation = [[self pages] pageSize] * (aLastFreeRegion.location / [[self pages] pageSize]  + 1);
            aNewFreeRegion = NUMakeRegion(aLastFreeRegion.location, aMinimumNextPageLocation - aLastFreeRegion.location);
        }
        
        [[self pages] setNextPageLocation:aMinimumNextPageLocation];
        [self removeRegion:aLastFreeRegion];
        
        if (aNewFreeRegion.location != NUNotFound64)
            [self releaseSpace:aNewFreeRegion];
    }
    
    [self unlock];
}

- (NUUInt64)pageStatingLocationFor:(NUUInt64)aLocation
{
    return [[self pages] pageStatingLocationFor:aLocation];
}

@end

@implementation NUSpaces (NodeSpace)

- (NUUInt64)allocateNodePageLocation
{
	return [self allocateSpace:[[self pages] pageSize] aligned:YES preventsNodeRelease:NO];
}

- (void)releaseNodePageAt:(NUUInt64)aNodePageLocation
{
    [self lock];
    
	[self releaseSpace:NUMakeRegion(aNodePageLocation, [[self pages] pageSize])];
    [self removeNodePageLocationToBeReleased:aNodePageLocation];
    
    [self unlock];
}

- (NUUInt64)allocateVirtualNodePageLocation
{
    [self lock];
    
	NUUInt64 aNewVirtualNodePage = nextVirtualPageLocation;
	nextVirtualPageLocation -= [pages pageSize];
    
    [self unlock];
    
	return aNewVirtualNodePage;
}

- (void)delayedReleaseNodePageLocation:(NUUInt64)aNodePage
{
    [self lock];
    
	if ([self nodePageLocationIsNotVirtual:aNodePage])
		[[self nodePageLocationsToBeReleased] addObject:[NSNumber numberWithUnsignedLongLong:aNodePage]];
    
    [self unlock];
}

- (NUUInt64)allocateNodePageWithPreventNodeRelease
{
	return [self allocateSpace:[[self pages] pageSize] aligned:YES preventsNodeRelease:YES];
}

- (void)initNextVirtualPageLocation
{
	nextVirtualPageLocation = [self firstVirtualPageLocation];
}

- (NUUInt64)firstVirtualPageLocation
{
	return (NUUInt64Max / [pages pageSize] - 1) * [pages pageSize];
}

- (BOOL)nodePageLocationIsVirtual:(NUUInt64)aNodePageLocation
{
	return aNodePageLocation >= nextVirtualPageLocation + [[self pages] pageSize];
}

- (BOOL)nodePageLocationIsNotVirtual:(NUUInt64)aNodePageLocation
{
    return ![self nodePageLocationIsVirtual:aNodePageLocation];
}

- (NSMutableSet *)nodePageLocationsToBeReleased
{
	return pagesToBeReleased;
}

- (void)addBranchNeedsVirtualPageCheck:(NUOpaqueBPlusTreeBranch *)aBranch
{
    [self lock];
    
    if (aBranch)
        [branchesNeedVirtualPageCheck addObject:aBranch];
    
    [self unlock];
}

- (void)removeBranchNeedsVirtualPageCheck:(NUOpaqueBPlusTreeBranch *)aBranch
{
    [self lock];
    
	[branchesNeedVirtualPageCheck removeObject:aBranch];
    
    [self unlock];
}

- (void)fixNodePages
{
    [self lock];
    
	[self releaseNodePagesToBeReleased];
	[self fixVirtualNodePages];
    
    [self unlock];
}

- (void)releaseNodePagesToBeReleased
{
    [self lock];
    
	NUUInt64 aVirtualPageLocation = [self firstVirtualPageLocation];
	
	while ([[self nodePageLocationsToBeReleased] count])
	{
		NSNumber *aPageLocation = [[self nodePageLocationsToBeReleased] anyObject];
		
		if (aVirtualPageLocation > nextVirtualPageLocation)
		{
			NUOpaqueBPlusTreeNode *aNode = [locationTree nodeFor:aVirtualPageLocation];
			if (!aNode) aNode = [lengthTree nodeFor:aVirtualPageLocation];
			
			if (aNode)
				[aNode changeNodePageWith:[aPageLocation unsignedLongLongValue]];
			else
				[self releaseNodePageAt:[aPageLocation unsignedLongLongValue]];
			
			aVirtualPageLocation -= [[self pages] pageSize];
		}
		else
			[self releaseNodePageAt:[aPageLocation unsignedLongLongValue]];		
	}
    
    [self unlock];
}

- (void)fixVirtualNodePages
{
    [self lock];
    
	NUUInt64 aVirtualPageLocation = [self firstVirtualPageLocation];
    NUUInt64 aPageSize = [[self pages] pageSize];
	
	for (; aVirtualPageLocation >= nextVirtualPageLocation + aPageSize; aVirtualPageLocation -= aPageSize)
	{
		NUOpaqueBPlusTreeNode *aNode = [locationTree nodeFor:aVirtualPageLocation];
		if (!aNode) aNode = [lengthTree nodeFor:aVirtualPageLocation];
		
		if (aNode) [aNode changeNodePageWith:[self allocateNodePageWithPreventNodeRelease]];
	}
	
	NSEnumerator *anEnumerator = [branchesNeedVirtualPageCheck objectEnumerator];
	NUOpaqueBPlusTreeBranch *aBranch = nil;
	while (aBranch = [anEnumerator nextObject])
		[aBranch fixVirtualNodes];
	
	[self initNextVirtualPageLocation];
	[branchesNeedVirtualPageCheck removeAllObjects];
	[virtualToRealNodePageDictionary removeAllObjects];
    
    [self unlock];
}

- (void)setNodePageLocation:(NUUInt64)aPageLocation forVirtualNodePageLocation:(NUUInt64)aVirtualNodePageLocation
{
    [self lock];
    
	[virtualToRealNodePageDictionary
		setObject:[NSNumber numberWithUnsignedLongLong:aPageLocation]
		forKey:[NSNumber numberWithUnsignedLongLong:aVirtualNodePageLocation]];
    
    [self unlock];
}

- (NUUInt64)nodePageLocationForVirtualNodePageLocation:(NUUInt64)aVirtualNodePageLocation
{
    [self lock];
    
    NUUInt64 aNodePageLocation =  [[virtualToRealNodePageDictionary
				objectForKey:[NSNumber numberWithUnsignedLongLong:aVirtualNodePageLocation]] unsignedLongLongValue];
    
    [self unlock];
    
    return aNodePageLocation;
}

- (NUOpaqueBPlusTreeNode *)nodeFor:(NUUInt64)aNodeLocation
{
    [self lock];
    
    NUUInt64 aNodeOOP = [[self pages] readUInt64At:aNodeLocation];    
    NUOpaqueBPlusTreeNode *aNode = [[[self nodeOOPToTreeDictionary] objectForKey:aNodeOOP] nodeFor:aNodeLocation];
    
    [self unlock];
    
    return aNode;
}

- (BOOL)nodePageIsToBeReleased:(NUUInt64)aNodeLocation
{
    BOOL aNodePageIsReleased;
    
    [self lock];
    
    aNodePageIsReleased = [[self nodePageLocationsToBeReleased] containsObject:@(aNodeLocation)];
    
    [self unlock];
    
    return aNodePageIsReleased;
}

- (BOOL)nodePageIsNotToBeReleased:(NUUInt64)aNodeLocation
{
    return ![self nodePageIsToBeReleased:aNodeLocation];
}

- (void)removeNodePageLocationToBeReleased:(NUUInt64)aNodeLocation
{
    [self lock];
    
    [[self nodePageLocationsToBeReleased] removeObject:@(aNodeLocation)];
    
    [self unlock];
}

- (void)movePageToBeReleasedAtLocation:(NUUInt64)aNodeLocation toLocation:(NUUInt64)aNewLocation
{
    [self lock];
    
    [[self nodePageLocationsToBeReleased] removeObject:@(aNodeLocation)];
    [[self nodePageLocationsToBeReleased] addObject:@(aNewLocation)];
    
    [self unlock];
}

@end

@implementation NUSpaces (Locking)

- (void)lock
{
    [lock lock];
}

- (void)unlock
{
    [lock unlock];
}

@end

@implementation NUSpaces (Private)

- (void)prepareNodeOOPToTreeDictionary
{
    nodeOOPToTreeDictionary = [NUU64ODictionary new];
    [nodeOOPToTreeDictionary setObject:[nursery objectTable] forKey:[[[nursery objectTable] leafNodeClass] nodeOOP]];
    [nodeOOPToTreeDictionary setObject:[nursery objectTable] forKey:[[[nursery objectTable] branchNodeClass] nodeOOP]];
    [nodeOOPToTreeDictionary setObject:[nursery reversedObjectTable] forKey:[[[nursery reversedObjectTable] leafNodeClass] nodeOOP]];
    [nodeOOPToTreeDictionary setObject:[nursery reversedObjectTable] forKey:[[[nursery reversedObjectTable] branchNodeClass] nodeOOP]];
    [nodeOOPToTreeDictionary setObject:locationTree forKey:[[locationTree leafNodeClass] nodeOOP]];
    [nodeOOPToTreeDictionary setObject:locationTree forKey:[[locationTree branchNodeClass] nodeOOP]];
    [nodeOOPToTreeDictionary setObject:lengthTree forKey:[[lengthTree leafNodeClass] nodeOOP]];
    [nodeOOPToTreeDictionary setObject:lengthTree forKey:[[lengthTree branchNodeClass] nodeOOP]];
}

- (void)setRegion:(NURegion)aRegion
{
    [self lock];
    
	[lengthTree setRegion:aRegion];
	[locationTree setRegion:aRegion];
    
#ifdef DEBUG
    [self validateFreeRegions];
#endif
    
    [self unlock];
}

- (void)removeRegion:(NURegion)aRegion
{
    [self lock];
    
	[lengthTree removeRegion:aRegion];
	[locationTree removeRegionFor:aRegion.location];
    
    [self unlock];
}

@end

@implementation NUSpaces (Debug)

- (void)validate
{
    [self lock];
    
    [locationTree validate];
    [lengthTree validate];
    [self validateFreeRegions];
    
    [self unlock];
}

- (BOOL)validateFreeRegions
{
    NULocationTreeLeaf *aLeaf = (NULocationTreeLeaf *)[locationTree mostLeftNode];
    NUUInt32 aKeyIndex = NUNotFound32;
    
    while ((aLeaf = (NULocationTreeLeaf *)[locationTree getNextKeyIndex:&aKeyIndex node:aLeaf]))
    {
        NURegion aRegion = [aLeaf regionAt:aKeyIndex];
        
        aLeaf =(NULocationTreeLeaf *)[locationTree getNextKeyIndex:&aKeyIndex node:aLeaf];
        
        if (aLeaf)
        {
            NURegion aNextRegion = [aLeaf regionAt:aKeyIndex];

            if (NUIntersectsRegion(aRegion, aNextRegion))
            {
#ifdef DEBUG
                NSLog(@"NUIntersectsRegion(%@, %@) == YES", NUStringFromRegion(aRegion), NUStringFromRegion(aNextRegion));
#endif
                return NO;
            }
            else
                aKeyIndex--;
        }
    }
    
    return YES;
}

@end
