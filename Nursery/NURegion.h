//
//  NURegion.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/26.
//

#import <objc/objc.h>
#import <Foundation/NSRange.h>

#import <Nursery/NUTypes.h>

@class NSString;

NURegion NUMakeRegion(NUUInt64 aLocation, NUUInt64 aLength);
NURegion NURegionSplitWithLength(NURegion aRegion, NUUInt64 aLength, NURegion *aRemainRegion);
void NURegionSplitWithRegion(NURegion aRegion, NURegion aRegionToCut, NURegion *aRemainRegion1, NURegion *aRemainRegion2);
NUUInt64 NUMaxLocation(NURegion aRegion);
BOOL NURegionEquals(NURegion aRegion1, NURegion aRegion2);
BOOL NULocationInRegion(NUUInt64 aLocation, NURegion aRegion);
BOOL NURegionInRegion(NURegion aRegion1, NURegion aRegion2);
BOOL NUIntersectsRegion(NURegion aRegion1, NURegion aRegion2);
NURegion NUUnionRegion(NURegion aRegion1, NURegion aRegion2);
NURegion NUUnionRegions(NURegion aRegion, NURegion *aRegions, NUUInt64 aCount);
NUComparisonResult compareRegionLocation(NUUInt8 *aRegion1, NUUInt8 *aRegion2);
NSString *NUStringFromRegion(NURegion aRegion);
NSRange NURangeFromRegion(NURegion aRegion);
NURegion NUSwapHostRegionToBig(NURegion aRegion);
NURegion NUSwapBigRegionToHost(NURegion aRegion);
