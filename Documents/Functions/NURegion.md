# NURegion Functions

`NURegion NUMakeRegion(NUUInt64 aLocation, NUUInt64 aLength);`  
Creates and returns a region with the specified value.

`NURegion NURegionSplitWithLength(NURegion aRegion, NUUInt64 aLength, NURegion *aRemainRegion);`  
Creates and returns a region of the specified length from the specified region.  
Also returns the remaining region into aRemainRegion.

`void NURegionSplitWithRegion(NURegion aRegion, NURegion aRegionToCut, NURegion *aRemainRegion1, NURegion *aRemainRegion2);`  
Removes the range specified by aRegionToCut from aRegion and returns the remaining regions.

`NUUInt64 NUMaxLocation(NURegion aRegion);`  
Returns the position immediately after the specified value.

`BOOL NURegionEquals(NURegion aRegion1, NURegion aRegion2);`  
Returns whether the specified value is equal or not.

`BOOL NULocationInRegion(NUUInt64 aLocation, NURegion aRegion);`  
Returns whether the specified location is in the range of the region.

`BOOL NURegionInRegion(NURegion aRegion1, NURegion aRegion2);`  
Returns whether aRegion1 is in the range of aRegion2.

`BOOL NUIntersectsRegion(NURegion aRegion1, NURegion aRegion2);`  
Returns whether or not the specified value intersects.

`NURegion NUUnionRegion(NURegion aRegion1, NURegion aRegion2);`  
Returns the combined region of both specified regions.

`NURegion NUUnionRegions(NURegion aRegion, NURegion *aRegions, NUUInt64 aCount);`  
Combines and returns the elements in aRegion and array aRegions.

`NUComparisonResult compareRegionLocation(NUUInt8 *aRegion1, NUUInt8 *aRegion2);`  
Compares the two regions at the specified address and returns the result.

`NSString *NUStringFromRegion(NURegion aRegion);`  
Creates and returns a string from the specified value.

`NSRange NURangeFromRegion(NURegion aRegion);`  
Creates and returns an NSRange from the specified value.

`NURegion NUSwapHostRegionToBig(NURegion aRegion);`  
Converts from the specified host endian value to big endian value and returns it.

`NURegion NUSwapBigRegionToHost(NURegion aRegion);`  
Converts from the specified big endian value to the host endian value and returns it.

