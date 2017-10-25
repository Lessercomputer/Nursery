//
//  NUReversedObjectTable.m
//  Nursery
//
//  Created by P,T,A on 2013/01/12.
//
//

#import "NUReversedObjectTable.h"
#import "NUIndexArray.h"
#import "NUReversedObjectTableBranch.h"
#import "NUReversedObjectTableLeaf.h"

const NUUInt64 NUReversedObjectTableRootLocationOffset	= 45;

@implementation NUReversedObjectTable

- (id)initWithRootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces
{
	if (self = [super initWithKeyLength:sizeof(NUUInt64) leafValueLength:sizeof(NUBellBall) rootLocation:aRootLocation on:aSpaces])
    {
        lock = [NSRecursiveLock new];
    }
	
	return self;
}

- (void)dealloc
{
    [lock release];
    [super dealloc];
}

- (Class)branchNodeClass
{
	return [NUReversedObjectTableBranch class];
}

- (Class)leafNodeClass
{
	return [NUReversedObjectTableLeaf class];
}

+ (NUUInt64)rootLocationOffset
{
	return NUReversedObjectTableRootLocationOffset;
}

- (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator
{
	return [NUIndexArray comparator];
}

- (NUBellBall)bellBallForObjectLocation:(NUUInt64)anObjectLocation
{
    NUUInt8 *aValue = [self valueFor:(NUUInt8 *)&anObjectLocation];
    NUBellBall aBellBall = NUNotFoundBellBall;
    
    if (aValue) aBellBall = *(NUBellBall *)aValue;
    
    return aBellBall;
}

- (void)setBellBall:(NUBellBall)aBellBall forObjectLocation:(NUUInt64)anObjectLocation
{
    [self setOpaqueValue:(NUUInt8 *)&aBellBall forKey:(NUUInt8 *)&anObjectLocation];
}

- (void)removeBellBallForObjectLocation:(NUUInt64)anObjectLocation
{
    [self removeValueFor:(NUUInt8 *)&anObjectLocation];
}

- (NUBellBall)bellBallForObjectLocationGreaterThanOrEqualTo:(NUUInt64)aLocation
{
    @try {
        [lock lock];
        
        NUUInt32 aKeyIndex;
        NUReversedObjectTableLeaf *aLeaf = (NUReversedObjectTableLeaf *)[self leafNodeContainingKeyGreaterThenOrEqualTo:(NUUInt8 *)&aLocation keyIndex:&aKeyIndex];
        
        if (aLeaf) return *(NUBellBall *)[aLeaf valueAt:aKeyIndex];
        else return NUNotFoundBellBall;
    }
    @finally {
        [lock unlock];
    }
}

@end
