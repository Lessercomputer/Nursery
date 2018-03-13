//
//  NUSpaces.m
//  Nursery
//
//  Created by Akifumi Takata on 10/12/23.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUSpaces.h"
#import "NUOpaqueBTreeBranch.h"
#import "NULocationTree.h"
#import "NULocationTreeLeaf.h"
#import "NULengthTree.h"
#import "NULengthTreeLeaf.h"
#import "NURegion.h"
#import "NUPages.h"
#import "NUCharacter.h"
#import "NUMainBranchNursery.h"
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
	[super init];
	
    lock = [NSRecursiveLock new];
	[self setPages:[NUPages pages]];
	[self setNursery:aNursery];
	nextVirtualPageLocation = (NUUInt64)[[self pages] pageSize] * (NUUInt64Max / [[self pages] pageSize] - 1);
	lengthTree = [[NULengthTree alloc] initWithRootLocation:0 on:self];
	locationTree = [[NULocationTree alloc] initWithRootLocation:0 on:self];
	pagesToRelease = [[NSMutableSet set] retain];
	branchesNeedVirtualPageCheck = [NSMutableSet new];
	virtualToRealNodePageDictionary = [NSMutableDictionary new];

	return self;
}

- (void)dealloc
{
	[locationTree release];
	[lengthTree release];
	[self setNursery:nil];
	[self setPages:nil];
	[pagesToRelease release];
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
    NUUInt32 aKeyIndex;
    NULocationTreeLeaf *aLeaf = [locationTree getNodeContainingSpaceAtLocationGreaterThanOrEqual:aLocation keyIndex:&aKeyIndex];
    
    if (!aLeaf) return NUMakeRegion(NUNotFound64, 0);
    
    return [aLeaf regionAt:aKeyIndex];
}

- (NURegion)freeSpaceContainingSpaceAtLocationLessThanOrEqual:(NUUInt64)aLocation
{
    NUUInt32 aKeyIndex;
    NULocationTreeLeaf *aLeaf = [locationTree getNodeContainingSpaceAtLocationLessThanOrEqual:aLocation keyIndex:&aKeyIndex];
    
    if (!aLeaf) return NUMakeRegion(NUNotFound64, 0);
    
    return [aLeaf regionAt:aKeyIndex];
}

- (NUUInt64)allocateSpace:(NUUInt64)aLength
{
	return [self allocateSpace:aLength aligned:NO preventsNodeRelease:NO];
}

- (NUUInt64)allocateSpace:(NUUInt64)aLength aligned:(BOOL)anAlignFlag preventsNodeRelease:(BOOL)aPreventsNodeReleaseFlag
{
	NUUInt32 aKeyIndex;
	NULengthTreeLeaf *aNode = [lengthTree getNodeContainingSpaceOfLengthGreaterThanOrEqual:aLength keyIndex:&aKeyIndex];
	
	while (aNode)
	{
		for (; aKeyIndex < [aNode keyCount]; aKeyIndex++)
		{
			NURegion aRegion = *(NURegion *)[aNode keyAt:aKeyIndex];
			NUUInt64 anAllocatedLocation = [self allocateSpaceFrom:aNode region:aRegion length:aLength aligned:anAlignFlag preventsNodeRelease:aPreventsNodeReleaseFlag];
			if (anAllocatedLocation != NUUInt64Max)
            {
#ifdef DEBUG
                if (anAlignFlag && (anAllocatedLocation % aLength != 0))
                    NSLog(@"anAllocatedLocation is invalid.");
#endif
                return anAllocatedLocation;
            }
		}
		
		aKeyIndex = 0;
		aNode = (NULengthTreeLeaf *)[aNode rightNode];
	}
	
	return [self extendSpaceBy:aLength];
}

- (NUUInt64)allocateSpaceFrom:(NULengthTreeLeaf *)aLengthTreeLeaf region:(NURegion)aRegion length:(NUUInt64)aLength aligned:(BOOL)anAlignFlag preventsNodeRelease:(BOOL)aPreventsNodeReleaseFlag
{
	NUUInt32 aKeyIndex;
	NULocationTreeLeaf *aLocationTreeLeaf = [locationTree getNodeContainingSpaceAtLocationLessThanOrEqual:aRegion.location keyIndex:&aKeyIndex];
	
	if (![aLengthTreeLeaf canPreventNodeReleseWhenValueRemoved]
			|| ![aLocationTreeLeaf canPreventNodeReleseWhenValueRemoved])
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
			[self setRegion:aRemainRegion1];
			
			if (aRemainRegion2.length) [self setRegion:aRemainRegion2];
			
			return aRegionToCut.location;
		}
	}
	else
	{
		NURegion aRemainSpace;
		NURegion aNewSpace = NURegionSplitWithLength(aRegion, aLength, &aRemainSpace);
		
		[self removeRegion:aRegion];
		
		if (aRemainSpace.length) [self setRegion:aRemainSpace];
		
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

		[self setRegion:aFreeRegion];
	}
	
	return aNextPageLocation;
}

- (void)releaseSpace:(NURegion)aRegion
{
#ifdef DEBUG
    NSLog(@"#releaseSpace:%@", NUStringFromRegion(aRegion));
#endif
    
	NUUInt32 aKeyIndex;
	NULocationTreeLeaf *aNode = [locationTree getNodeContainingSpaceAtLocationLessThanOrEqual:aRegion.location keyIndex:&aKeyIndex];
	NURegion aLeftRegion = NUMakeRegion(0, 0), aRightRegion = NUMakeRegion(0, 0);
	
	if (aNode)
	{
		aLeftRegion = [aNode regionAt:aKeyIndex];
		
		if (NULocationInRegion(aRegion.location, aLeftRegion))
			[[NSException exceptionWithName:NURegionAlreadyReleasedException reason:nil userInfo:nil] raise];
				
		if (aKeyIndex < [aNode keyCount] - 1) aRightRegion = [aNode regionAt:aKeyIndex + 1];
		else if ([aNode rightNode]) aRightRegion = [(NULocationTreeLeaf *)[aNode rightNode] regionAt:0];
	}
	else if (![[locationTree mostLeftNode] isEmpty])
    {
#ifdef DEBUG
        NSLog(@"#releaseSpace ![[locationTree mostLeftNode] isEmpty]");
#endif
		aRightRegion = [(NULocationTreeLeaf *)[locationTree mostLeftNode] regionAt:0];
        
/*#ifdef DEBUG
        NSLog(@"#releaseSpace ![[locationTree mostRightNode] isEmpty]");
#endif
		aRightRegion = [(NULocationTreeLeaf *)[locationTree mostRightNode] regionAt:0];*/
    }
	
	if (aRightRegion.length != 0 && NULocationInRegion(aRightRegion.location, aRegion))
		[[NSException exceptionWithName:NURegionAlreadyReleasedException reason:nil userInfo:nil] raise];
	
	if (NUMaxLocation(aLeftRegion) == aRegion.location)
	{
#ifdef DEBUG
        NSLog(@"#releaseSpace removeLeftRegion:%@", NUStringFromRegion(aLeftRegion));
#endif
        
		[self removeRegion:aLeftRegion];
		aRegion = NUMakeRegion(aLeftRegion.location, aLeftRegion.length + aRegion.length);
	}
	
	if (aRightRegion.length != 0 && NUMaxLocation(aRegion) == aRightRegion.location)
	{
#ifdef DEBUG
        NSLog(@"#releaseSpace removeRightRegion:%@", NUStringFromRegion(aRightRegion));
#endif

		[self removeRegion:aRightRegion];
		aRegion = NUMakeRegion(aRegion.location, aRegion.length + aRightRegion.length);
	}
	
#ifdef DEBUG
    NSLog(@"#releaseSpace setRegion:%@", NUStringFromRegion(aRegion));
#endif
    
	[self setRegion:aRegion];
}

- (void)moveFreeSpaceAtLocation:(NUUInt64)aSourceLocation toLocation:(NUUInt64)aDestinationLocation
{
    if (aSourceLocation >= aDestinationLocation)
        [[NSException exceptionWithName:NUSpaceInvalidOperationException reason:NUSpaceInvalidOperationException userInfo:nil] raise];
    
    NURegion aFreeRegion = [locationTree regionFor:aSourceLocation];
    
    if (aFreeRegion.location == NUNotFound64)
        [[NSException exceptionWithName:NUSpaceInvalidOperationException reason:NUSpaceInvalidOperationException userInfo:nil] raise];
    
    NURegion aMovedFreeRegion = NUMakeRegion(aDestinationLocation, aFreeRegion.length);
    NURegion aFreeRegionToMerge = [locationTree regionFor:NUMaxLocation(aMovedFreeRegion)];
    
    [self removeRegion:aFreeRegion];
    
    if (aFreeRegionToMerge.location == NUNotFound64)
        [self setRegion:aMovedFreeRegion];
    else
    {
        [self removeRegion:aFreeRegionToMerge];
        NURegion aMergedFreeRegion = NUUnionRegion(aMovedFreeRegion, aFreeRegionToMerge);
        [self setRegion:aMergedFreeRegion];
    }
}

- (void)minimizeSpace
{
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
            [self setRegion:aNewFreeRegion];
    }
}

- (NUUInt64)pageStatingLocationFor:(NUUInt64)aLocation
{
    return [[self pages] pageStatingLocationFor:aLocation];
}

@end

@implementation NUSpaces (NodeSpace)

- (NUUInt64)allocateNodePage
{
	return [self allocateSpace:[[self pages] pageSize] aligned:YES preventsNodeRelease:NO];
}

- (void)releaseNodePage:(NUUInt64)aNodePage
{
	[self releaseSpace:NUMakeRegion(aNodePage, [[self pages] pageSize])];
}

- (NUUInt64)allocateVirtualNodePage
{
	NUUInt64 aNewVirtualNodePage = nextVirtualPageLocation;
	nextVirtualPageLocation -= [pages pageSize];
	return aNewVirtualNodePage;
}

- (void)delayedReleaseNodePage:(NUUInt64)aNodePage
{
	if ([self nodePageLocationIsNotVirtual:aNodePage])
		[pagesToRelease addObject:[NSNumber numberWithUnsignedLongLong:aNodePage]];
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

- (NSMutableSet *)pagesToRelease
{
	return pagesToRelease;
}

- (void)addBranchNeedsVirtualPageCheck:(NUOpaqueBTreeBranch *)aBranch
{
    if (aBranch)
        [branchesNeedVirtualPageCheck addObject:aBranch];
}

- (void)removeBranchNeedsVirtualPageCheck:(NUOpaqueBTreeBranch *)aBranch
{
	[branchesNeedVirtualPageCheck removeObject:aBranch];
}

- (void)fixNodePages
{
	[self releasePagesToRelease];
	[self fixVirtualNodePages];
}

- (void)releasePagesToRelease
{
	NUUInt64 aVirtualPageLocation = [self firstVirtualPageLocation];
	
	while ([pagesToRelease count])
	{
		NSNumber *aPageNumber = [pagesToRelease anyObject];
		
		if (aVirtualPageLocation > nextVirtualPageLocation)
		{
			NUOpaqueBTreeNode *aNode = [locationTree nodeFor:aVirtualPageLocation];
			if (!aNode) aNode = [lengthTree nodeFor:aVirtualPageLocation];
			
			if (aNode)
				[aNode changeNodePageWith:[aPageNumber unsignedLongLongValue]];
			else
				[self releaseNodePage:[aPageNumber unsignedLongLongValue]];
			
			aVirtualPageLocation -= [[self pages] pageSize];
		}
		else
			[self releaseNodePage:[aPageNumber unsignedLongLongValue]];
		
		[pagesToRelease removeObject:aPageNumber];
	}
}

- (void)fixVirtualNodePages
{
	NUUInt64 aVirtualPageLocation = [self firstVirtualPageLocation];
    NUUInt64 aPageSize = [[self pages] pageSize];
	
	for (; aVirtualPageLocation >= nextVirtualPageLocation + aPageSize; aVirtualPageLocation -= aPageSize)
	{
		NUOpaqueBTreeNode *aNode = [locationTree nodeFor:aVirtualPageLocation];
		if (!aNode) aNode = [lengthTree nodeFor:aVirtualPageLocation];
		
		if (aNode) [aNode changeNodePageWith:[self allocateNodePageWithPreventNodeRelease]];
	}
	
	NSEnumerator *anEnumerator = [branchesNeedVirtualPageCheck objectEnumerator];
	NUOpaqueBTreeBranch *aBranch = nil;
	while (aBranch = [anEnumerator nextObject])
		[aBranch fixVirtualNodes];
	
	[self initNextVirtualPageLocation];
	[branchesNeedVirtualPageCheck removeAllObjects];
	[virtualToRealNodePageDictionary removeAllObjects];
}

- (void)setNodePageLocation:(NUUInt64)aPageLocation forVirtualNodePageLocation:(NUUInt64)aVirtualNodePageLocation
{
	[virtualToRealNodePageDictionary
		setObject:[NSNumber numberWithUnsignedLongLong:aPageLocation]
		forKey:[NSNumber numberWithUnsignedLongLong:aVirtualNodePageLocation]];
}

- (NUUInt64)nodePageLocationForVirtualNodePageLocation:(NUUInt64)aVirtualNodePageLocation
{
	return [[virtualToRealNodePageDictionary
				objectForKey:[NSNumber numberWithUnsignedLongLong:aVirtualNodePageLocation]] unsignedLongLongValue];
}

- (NUOpaqueBTreeNode *)nodeFor:(NUUInt64)aNodeLocation
{
    NUUInt64 aNodeOOP = [[self pages] readUInt64At:aNodeLocation];    
    return [[[self nodeOOPToTreeDictionary] objectForKey:aNodeOOP] nodeFor:aNodeLocation];
}

- (BOOL)nodeIsUsedFor:(NUUInt64)aNodeLocation
{
    return ![[self pagesToRelease] containsObject:@(aNodeLocation)];
}

- (void)movePageToReleaseAtLocation:(NUUInt64)aNodeLocation toLocation:(NUUInt64)aNewLocation
{
#ifdef DEBUG
    NSLog(@"movePageToReleaseAtLocation:%llu toLocation:%llu", aNodeLocation, aNewLocation);
#endif
    
    [[self pagesToRelease] removeObject:@(aNodeLocation)];
    [[self pagesToRelease] addObject:@(aNewLocation)];
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
	[lengthTree setRegion:aRegion];
	[locationTree setRegion:aRegion];
    
#ifdef DEBUG
    [self validateFreeRegions];
#endif
}

- (void)removeRegion:(NURegion)aRegion
{
	[lengthTree removeRegion:aRegion];
	[locationTree removeRegionFor:aRegion.location];
}

@end

@implementation NUSpaces (Debug)

- (void)validateAllNodeLocations
{
    [locationTree validateAllNodeLocations];
    [lengthTree validateAllNodeLocations];
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
