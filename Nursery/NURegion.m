//
//  NURegion.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/26.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSString.h>
#import <Foundation/NSByteOrder.h>

#import "NURegion.h"

NURegion NUMakeRegion(NUUInt64 aLocation, NUUInt64 aLength)
{
	NURegion aRegion;
	aRegion.location = aLocation;
	aRegion.length = aLength;
	return aRegion;
}

NURegion NURegionSplitWithLength(NURegion aRegion, NUUInt64 aLength, NURegion *aRemainRegion)
{
	NUUInt64 aLengthToTrim = aRegion.length - aLength;
	NURegion aNewRegion = NUMakeRegion(aRegion.location, aRegion.length - aLengthToTrim);
	*aRemainRegion = NUMakeRegion(aRegion.location + aRegion.length - aLengthToTrim, aLengthToTrim);
	return aNewRegion;
}

void NURegionSplitWithRegion(NURegion aRegion, NURegion aRegionToCut, NURegion *aRemainRegion1, NURegion *aRemainRegion2)
{
	*aRemainRegion1 = NUMakeRegion(aRegion.location, aRegionToCut.location - aRegion.location);
	*aRemainRegion2 = NUMakeRegion(NUMaxLocation(aRegionToCut), NUMaxLocation(aRegion) - NUMaxLocation(aRegionToCut));
}

NUUInt64 NUMaxLocation(NURegion aRegion)
{
	return aRegion.location + aRegion.length;
}

BOOL NURegionEquals(NURegion aRegion1, NURegion aRegion2)
{
    return aRegion1.location == aRegion2.location && aRegion1.length == aRegion2.length;
}

BOOL NULocationInRegion(NUUInt64 aLocation, NURegion aRegion)
{
	return aRegion.location <= aLocation && aLocation < aRegion.location + aRegion.length;
}

BOOL NURegionInRegion(NURegion aRegion1, NURegion aRegion2)
{
	return NULocationInRegion(aRegion1.location, aRegion2) && NUMaxLocation(aRegion1) <= NUMaxLocation(aRegion2);
}

BOOL NUIntersectsRegion(NURegion aRegion1, NURegion aRegion2)
{		
	if (aRegion1.location < aRegion2.location)
		return NULocationInRegion(aRegion2.location, aRegion1)
			|| NUMaxLocation(aRegion1) == aRegion2.location;
	else
		return NULocationInRegion(aRegion1.location, aRegion2)
			|| NUMaxLocation(aRegion2) == aRegion1.location;
}

NURegion NUUnionRegion(NURegion aRegion1, NURegion aRegion2)
{
	if (aRegion1.location < aRegion2.location)
		return NUMakeRegion(aRegion1.location, NUMaxLocation(aRegion2) - aRegion1.location);
	else if (aRegion1.location > aRegion2.location)
		return NUMakeRegion(aRegion2.location, NUMaxLocation(aRegion1) - aRegion2.location);
	else
		return NUMakeRegion(aRegion1.location, aRegion1.length < aRegion2.length ? aRegion2.length : aRegion1.length);
}

NURegion NUUnionRegions(NURegion aRegion, NURegion *aRegions, NUUInt64 aCount)
{
	NUUInt64 aMinLocation = aRegion.location;
	NUUInt64 aMaxLocation = NUMaxLocation(aRegion);
	NUUInt32 i = 0;

	for (; i < aCount; i++)
	{
		if (aRegions[i].location < aMinLocation)
			aMinLocation = aRegions[i].location;
		if (NUMaxLocation(aRegions[i]) > aMaxLocation)
			aMaxLocation = NUMaxLocation(aRegions[i]);
	}
	
	return NUMakeRegion(aMinLocation, aMaxLocation - aMinLocation);
}

NUComparisonResult compareRegionLocation(NUUInt8 *aRegion1, NUUInt8 *aRegion2)
{
	if ((*(NURegion *)aRegion1).location < ((*(NURegion *)aRegion2).location))
		return NUOrderedAscending;
	else if (((*(NURegion *)aRegion1).location) > (*(NURegion *)aRegion2).location)
		return NUOrderedDescending;
	else
		return NUOrderedSame;
}

NSString *NUStringFromRegion(NURegion aRegion)
{
	return [NSString stringWithFormat:@"{%llu, %llu}", aRegion.location, aRegion.length];
}

NSRange NURangeFromRegion(NURegion aRegion)
{
    return NSMakeRange((NSUInteger)aRegion.location, (NSUInteger)aRegion.length);
}

NURegion NURegionFromRange(NSRange aRange)
{
    return NUMakeRegion(aRange.location, aRange.length);
}

NURegion NUSwapHostRegionToBig(NURegion aRegion)
{
    aRegion.location = NSSwapHostLongLongToBig(aRegion.location);
    aRegion.length = NSSwapHostLongLongToBig(aRegion.length);
    return aRegion;
}

NURegion NUSwapBigRegionToHost(NURegion aRegion)
{
    aRegion.location = NSSwapBigLongLongToHost(aRegion.location);
    aRegion.length = NSSwapBigLongLongToHost(aRegion.length);
    return aRegion;
}
