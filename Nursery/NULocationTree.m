//
//  NULocationTree.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/16.
//

#import "NULocationTree.h"
#import "NULocationTreeBranch.h"
#import "NULocationTreeLeaf.h"
#import "NURegion.h"

const NUUInt64 NULocationTreeRootLocationOffset = 29;

@implementation NULocationTree

- (id)initWithRootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces
{
	return [super initWithKeyLength:sizeof(NUUInt64) leafValueLength:sizeof(NUUInt64) rootLocation:aRootLocation on:aSpaces];
}

- (NULocationTreeLeaf *)getNodeContainingSpaceBeginningAtLocation:(NUUInt64)aLocation keyIndex:(NUUInt32 *)aKeyIndex
{
    return (NULocationTreeLeaf *)[self leafNodeContainingKey:(NUUInt8 *)&aLocation keyIndex:aKeyIndex];
}

- (NULocationTreeLeaf *)getNodeContainingSpaceBeginningAtLocationGreaterThanOrEqual:(NUUInt64)aLocation keyIndex:(NUUInt32 *)aKeyIndex
{
    return (NULocationTreeLeaf *)[self leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)&aLocation keyIndex:aKeyIndex];
}

- (NULocationTreeLeaf *)getNodeContainingSpaceBeginningAtLocationLessThanOrEqual:(NUUInt64)aLocation keyIndex:(NUUInt32 *)aKeyIndex
{
	return (NULocationTreeLeaf *)[self leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)&aLocation keyIndex:aKeyIndex];
}

- (NURegion)regionFor:(NUUInt64)aLocation
{
    NURegion aRegion;
    
    [self lock];
    
    NUUInt64 *aLengthPointer = (NUUInt64 *)[self valueFor:(NUUInt8 *)&aLocation];
    
    aRegion = aLengthPointer ? NUMakeRegion(aLocation, *aLengthPointer) : NUMakeRegion(NUNotFound64, 0);
    
    [self unlock];
    
    return aRegion;
}

- (void)setRegion:(NURegion)aRegion
{
	[self setOpaqueValue:(NUUInt8 *)&aRegion.length forKey:(NUUInt8 *)&aRegion.location];
}

- (void)removeRegionFor:(NUUInt64)aLocation
{
	[self removeValueFor:(NUUInt8 *)&aLocation];
}

- (Class)branchNodeClass
{
	return [NULocationTreeBranch class];
}

- (Class)leafNodeClass
{
	return [NULocationTreeLeaf class];
}

+ (NUUInt64)rootLocationOffset
{
	return NULocationTreeRootLocationOffset;
}

- (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator
{
	return compareRegionLocation;
}

- (NURegion)scanSpaceContainningLocation:(NUUInt64)aLocation
{
    __block NURegion aFoundRegion = NUMakeRegion(NUNotFound64, 0);
    
    [self enumerateKeysAndObjectsWithOptions:0 usingBlock:^(NUUInt8 *aKey, NUUInt8 *aValue, BOOL *aStop)
    {
        NURegion aRegionInTree = NUMakeRegion(*(NUUInt64 *)aKey, *(NUUInt64 *)aValue);
        
        if (NULocationInRegion(aLocation, aRegionInTree))
        {
            aFoundRegion = aRegionInTree;
            *aStop = YES;
        }
    }];
    
    return aFoundRegion;
}

@end
