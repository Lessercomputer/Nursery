//
//  NUReversedObjectTable.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/12.
//
//

#import <Foundation/NSLock.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSValue.h>
#import <Foundation/NSString.h>

#import "NUReversedObjectTable.h"
#import "NUIndexArray.h"
#import "NUReversedObjectTableBranch.h"
#import "NUReversedObjectTableLeaf.h"
#import "NUBellBall.h"

const NUUInt64 NUReversedObjectTableRootLocationOffset	= 45;

@implementation NUReversedObjectTable

- (id)initWithRootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces
{
	if (self = [super initWithKeyLength:sizeof(NUUInt64) leafValueLength:sizeof(NUBellBall) rootLocation:aRootLocation on:aSpaces])
    {
    }
	
	return self;
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
    NUBellBall aBellBall;
    
    @try {
        [self lock];
        
        NUUInt32 aKeyIndex;
        NUReversedObjectTableLeaf *aLeaf = (NUReversedObjectTableLeaf *)[self leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)&aLocation keyIndex:&aKeyIndex];
        
        if (aLeaf)
            aBellBall = *(NUBellBall *)[aLeaf valueAt:aKeyIndex];
        else
            aBellBall = NUNotFoundBellBall;
    }
    @finally {
        [self unlock];
    }
    
    return aBellBall;
}

- (NUBellBall)scanBellBallForObjectLocation:(NUUInt64)anObjectLocation
{
    NUBellBall aBellBall = NUNotFoundBellBall;
    
    [self lock];
    
    NUOpaqueBPlusTreeLeaf *aLeaf = [self mostLeftNode];
    
    while (aLeaf && NUBellBallEquals(aBellBall, NUNotFoundBellBall))
    {
        for (NUUInt32 i = 0; i < [aLeaf valueCount] && NUBellBallEquals(aBellBall, NUNotFoundBellBall); i++)
        {
            if ([aLeaf keyAt:i isEqual:(NUUInt8 *)&anObjectLocation])
                aBellBall = *(NUBellBall *)[aLeaf valueAt:i];
        }
        
        if (NUBellBallEquals(aBellBall, NUNotFoundBellBall))
            aLeaf = (NUOpaqueBPlusTreeLeaf *)[aLeaf rightNode];
    }
    
    [self unlock];
    
    return aBellBall;
}

- (NUUInt64)lastLocation
{
    return *(NUUInt64 *)[self lastKey];
}

@end
