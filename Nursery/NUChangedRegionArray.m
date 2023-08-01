//
//  NUChangedRegionArray.m
//  Nursery
//
//  Created by Akifumi Takata on 11/01/22.
//

#import "NUChangedRegionArray.h"
#import "NURegion.h"


@implementation NUChangedRegionArray

@end

@implementation NUChangedRegionArray (InitializingAndRelease)

- (id)initWithCapacity:(NUUInt32)aCapacity
{
	return [self initWithCapacity:aCapacity comparator:compareRegionLocation];
}

@end

@implementation NUChangedRegionArray (Modifying)

- (void)addRegion:(NURegion)aRegion
{
	NURegion anIntersectingRegionRange = [self intersectingRegionRangeWith:aRegion];
		
	if (anIntersectingRegionRange.length != 0)
	{
		NURegion aUnionRegion = NUUnionRegions(aRegion, (NURegion *)[self at:(NUUInt32)anIntersectingRegionRange.location], anIntersectingRegionRange.length);
		[self replaceRegionRange:anIntersectingRegionRange with:aUnionRegion];
	}
	else
	{
		[self insertRegion:aRegion to:[self indexToInsert:(NUUInt8 *)&aRegion]];
	}
}

- (void)replaceRegionRange:(NURegion)aReplaceRange with:(NURegion)aRegion
{
	if (NURegionInRegion(aReplaceRange, NUMakeRegion(0, [self count])))
	{
		[self replaceRegionAt:(NUUInt32)aReplaceRange.location with:aRegion];
		if (aReplaceRange.length > 1 && aReplaceRange.location + 1 < [self count])
			[self removeAt:(NUUInt32)aReplaceRange.location + 1 count:(NUUInt32)aReplaceRange.length - 1];
	}
}

@end

@implementation NUChangedRegionArray (Querying)

- (NUUInt32)firstIntersectingRegionIndexWith:(NURegion)aRegion
{
	NUInt32 aRegionIndex = [self indexLessThanOrEqualTo:(NUUInt8 *)&aRegion];
	
	if (aRegionIndex == -1) aRegionIndex = 0;
	
	for (; aRegionIndex < [self count]; aRegionIndex++)
		if (NUIntersectsRegion([self regionAt:aRegionIndex], aRegion)) return aRegionIndex;
		
	return NUUInt32Max;
}

- (NURegion)intersectingRegionRangeWith:(NURegion)aRegion
{
	NUUInt32 aFirstIntersectingRegionIndex = [self firstIntersectingRegionIndexWith:aRegion];
	NURegion anIntersectingRegionRange = NUMakeRegion(0, 0);
	
	if (aFirstIntersectingRegionIndex != NUUInt32Max)
	{
		NUUInt32 aRegionIndex = aFirstIntersectingRegionIndex + 1;
		
		for (; aRegionIndex < [self count] && NUIntersectsRegion([self regionAt:aRegionIndex], aRegion); aRegionIndex++)
			;
			
		anIntersectingRegionRange = NUMakeRegion(aFirstIntersectingRegionIndex, aRegionIndex - aFirstIntersectingRegionIndex);
	}
	
	return anIntersectingRegionRange;
}

@end

@implementation NUChangedRegionArray (Testing)

- (BOOL)isFixed
{
	return NO;
}

@end
