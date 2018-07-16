//
//  NUObjectTable.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/25.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUObjectTable.h"
#import "NUPages.h"
#import "NUObjectTableBranch.h"
#import "NUObjectTableLeaf.h"
#import "NUIndexArray.h"
#import "NUBellBall.h"
#import "NUBellBallArray.h"
#import "NUSpaces.h"
#import "NURegion.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUMainBranchAliaser.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"


const NUUInt64 NUNilOOP                             = 0;
const NUUInt64 NUCharacterOOP                       = 1;
const NUUInt64 NSStringOOP                          = 2;
const NUUInt64 NUNSStringOOP                        = 3;
const NUUInt64 NSArrayOOP                           = 4;
const NUUInt64 NUNSArrayOOP                         = 5;
const NUUInt64 NSMutableArrayOOP                    = 6;
const NUUInt64 NUNSMutableArrayOOP                  = 7;
const NUUInt64 NUIvarOOP                            = 8;
const NUUInt64 NSDictionaryOOP                      = 9;
const NUUInt64 NUNSDictionaryOOP                    = 10;
const NUUInt64 NSMutableDictionaryOOP               = 11;
const NUUInt64 NUNSMutableDictionaryOOP             = 12;
const NUUInt64 NSObjectOOP                          = 13;
const NUUInt64 NUNurseryRootOOP                     = 14;
const NUUInt64 NUCharacterDictionaryOOP             = 15;
const NUUInt64 NUMutableDictionaryOOP               = 16;
const NUUInt64 NSSetOOP                             = 17;
const NUUInt64 NUNSSetOOP                           = 18;
const NUUInt64 NSMutableSetOOP                      = 19;
const NUUInt64 NUNSMutableSetOOP                    = 20;

const NUUInt64 NUObjectTableLeafNodeOOP             = 2001;
const NUUInt64 NUObjectTableBranchNodeOOP           = 2002;
const NUUInt64 NUReversedObjectTableLeafNodeOOP     = 2003;
const NUUInt64 NUReversedObjectTableBranchNodeOOP   = 2004;
const NUUInt64 NULocationTreeLeafNodeOOP            = 2005;
const NUUInt64 NULocationTreeBranchNodeOOP          = 2006;
const NUUInt64 NULengthTreeLeafNodeOOP              = 2007;
const NUUInt64 NULengthTreeBranchNodeOOP            = 2008;
const NUUInt64 NUFreeRegionNodeOOP                  = 2009;
const NUUInt64 NUFreeRegionNodeListOOP              = 2010;

const NUUInt64 NUFirstUserObjectOOP                 = 3000;
const NUUInt64 NUDefaultFirstProbationayOOP         = UINT64_MAX - 1;
const NUUInt64 NUDefaultMaximumProbationaryOOPCount = 100000000;
const NUUInt64 NUDefaultLastProbationaryOOP         = UINT64_MAX - 1 - 100000000 - 1;

const NUUInt64 NUObjectTableRootLocationOffset	= 37;
const NUUInt64 NUNextOOPOffset					= 53;

const NUUInt8 NUGCMarkNone  = 0;
const NUUInt8 NUGCMarkWhite	= 1;
const NUUInt8 NUGCMarkGray	= 2;
const NUUInt8 NUGCMarkBlack	= 3;
const NUUInt8 NUGCMarkWithoutColorBitsMask = 252;
const NUUInt8 NUGCMarkColorBitsMask	= 3;


@implementation NUObjectTable

- (id)initWithRootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces
{
    if (self = [super initWithKeyLength:sizeof(NUBellBall) leafValueLength:sizeof(NUUInt64) + sizeof(NUUInt8) rootLocation:aRootLocation on:aSpaces])
    {
        nextOOP = NUFirstUserObjectOOP;
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
	return [NUObjectTableBranch class];
}

- (Class)leafNodeClass
{
	return [NUObjectTableLeaf class];
}

+ (NUUInt64)rootLocationOffset
{
	return NUObjectTableRootLocationOffset;
}

- (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator
{
	return [NUBellBallArray comparator];
}

- (NUBellBall)firstBellBall
{
	[lock lock];
	
	NUObjectTableLeaf *aLeafNode = (NUObjectTableLeaf *)[self mostLeftNode];
	NUBellBall aFirstBellBall = NUNotFoundBellBall;
	if (![aLeafNode isEmpty]) aFirstBellBall = *(NUBellBall *)[aLeafNode firstkey];
	
	[lock unlock];
	
	return aFirstBellBall;
}

- (NUUInt64)firstGrayOOPGradeLessThanOrEqualTo:(NUUInt64)aGrade
{
    [lock lock];
    
    NUUInt64 anOOP = NUNotFound64;
	NUObjectTableLeaf *aLeafNode = (NUObjectTableLeaf *)[self mostLeftNode];
    
    while (aLeafNode)
    {
        NUUInt32 aKeyIndex;

        for (aKeyIndex = 0; aKeyIndex < [aLeafNode keyCount]; aKeyIndex++)
        {
            NUUInt8 aGCMark = [aLeafNode gcMarkAt:aKeyIndex];
            
            if ((aGCMark & NUGCMarkColorBitsMask) == NUGCMarkGray)
                break;
        }
        
        if (aKeyIndex < [aLeafNode keyCount])
        {
            anOOP = ((NUBellBall *)[aLeafNode keyAt:aKeyIndex])->oop;
            break;
        }
        else
            aLeafNode = (NUObjectTableLeaf *)[aLeafNode rightNode];
    }
    
    [lock unlock];
    
    return anOOP;
}

- (NUBellBall)bellBallLessThanOrEqualTo:(NUBellBall)aBellBall
{
    @try {
        [lock lock];
        
        NUBellBall aFoundBellBall = NUNotFoundBellBall;
        NUUInt32 aKeyIndex = 0;
        NUObjectTableLeaf *aLeaf = [self leafNodeContainingBellBallLessThanOrEqualTo:aBellBall keyIndex:&aKeyIndex];
        
        if (aLeaf)
            aFoundBellBall = *(NUBellBall *)[aLeaf keyAt:aKeyIndex];
        
        return aFoundBellBall;
    }
    @finally {
        [lock unlock];
    }
}

- (NUBellBall)bellBallGreaterThanBellBall:(NUBellBall)aBellBall
{	
	[lock lock];
	    
    NUBellBall aKeyGreaterThanBellBall = NUNotFoundBellBall;
	NUBellBall aKey = NUNotFoundBellBall;
	NUUInt32 aKeyIndex = 0;
	NUObjectTableLeaf *aLeaf = [self leafNodeContainingBellBallLessThanOrEqualTo:aBellBall keyIndex:&aKeyIndex];
	if (!aLeaf) aLeaf = (NUObjectTableLeaf *)[self mostLeftNode];
	
	while (aLeaf && aKeyIndex < [aLeaf keyCount])
	{
		aKey = *(NUBellBall *)[aLeaf keyAt:aKeyIndex];
		NSComparisonResult aComparisonResult = (NSComparisonResult)[self comparator]((NUUInt8 *)&aKey, (NUUInt8 *)&aBellBall);
		if (aComparisonResult == NSOrderedDescending)
        {
            aKeyGreaterThanBellBall = aKey;
            break;
        }
		aKeyIndex++;
		if (aKeyIndex == [aLeaf keyCount])
		{
			aLeaf = (NUObjectTableLeaf *)[aLeaf rightNode];
			aKeyIndex = 0;
		}
	}
	
	[lock unlock];
	
	return aKeyGreaterThanBellBall;
}

- (NUUInt64)grayOOPGreaterThanOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade
{
    [lock lock];
    
    NUUInt32 aKeyIndex;
    NUBellBall aKeyBellBall = NUMakeBellBall(anOOP, aGrade);
    NUBellBall aBellBall = NUNotFoundBellBall;
    NUObjectTableLeaf *aLeaf = [self leafNodeContainingBellBallLessThanOrEqualTo:aKeyBellBall keyIndex:&aKeyIndex];
    
    while (aLeaf && aKeyIndex < [aLeaf keyCount])
    {
        aBellBall = *(NUBellBall *)[aLeaf keyAt:aKeyIndex];
        
        if (aBellBall.oop > anOOP && aBellBall.grade <= aGrade)
        {
            NUUInt8 aGCMark = [aLeaf gcMarkAt:aKeyIndex];
            
            if ((aGCMark & NUGCMarkColorBitsMask) == NUGCMarkGray)
                break;
        }
        
        aKeyIndex++;
        if (aKeyIndex == [aLeaf keyCount])
        {
            aLeaf = (NUObjectTableLeaf *)[aLeaf rightNode];
            aKeyIndex = 0;
        }
    }
    
    [lock unlock];
    
    return aLeaf ? aBellBall.oop : NUNotFound64;
}

- (NUObjectTableLeaf *)leafNodeContainingBellBall:(NUBellBall)aBellBall keyIndex:(NUUInt32 *)aKeyIndex
{
	return (NUObjectTableLeaf *)[self leafNodeContainingKey:(NUUInt8 *)&aBellBall keyIndex:aKeyIndex];
}

- (NUObjectTableLeaf *)leafNodeContainingBellBallLessThanOrEqualTo:(NUBellBall)aBellBall keyIndex:(NUUInt32 *)aKeyIndex
{
    return (NUObjectTableLeaf *)[self leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)&aBellBall keyIndex:aKeyIndex];
}

- (NUBellBall)allocateBellBallWithGrade:(NUUInt64)aGrade
{
    @try {
        [lock lock];
        
        NUBellBall aNewBellBall = NUMakeBellBall(nextOOP, aGrade);

        [self setObjectLocation:0 for:aNewBellBall];
        nextOOP++;

        return aNewBellBall;
    }
    @finally {
        [lock unlock];
    }
}

- (NUUInt64)objectLocationForOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade gradeInto:(NUUInt64 *)aFoundGrade
{
    @try {
        [lock lock];
#ifdef DEBUG
        if (anOOP == 19)
            NSLog(@"anOOP == 19");
#endif
        NUUInt64 anObjectLocation = NUNotFound64;
        NUBellBall aBellBall = NUMakeBellBall(anOOP, aGrade);
        NUUInt32 aKeyIndex;
        NUObjectTableLeaf *aLeaf = (NUObjectTableLeaf *)[self leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)&aBellBall keyIndex:&aKeyIndex];
        
        if (aLeaf)
        {
            NUBellBall *aBellBall = (NUBellBall *)[aLeaf keyAt:aKeyIndex];
            if (aBellBall->oop == anOOP)
            {
                anObjectLocation = *(NUUInt64 *)[aLeaf valueAt:aKeyIndex];
                *aFoundGrade = aBellBall->grade;
            }
        }
        
        return anObjectLocation;
    }
    @finally {
        [lock unlock];
    }
}

- (NUUInt64)objectLocationFor:(NUBellBall)aBellBall
{
    [lock lock];
    
	NUUInt8 *value = [self valueFor:(NUUInt8 *)&aBellBall];
    NUUInt64 objectLocation = NUNotFound64;
	
	if (value) objectLocation = *(NUUInt64 *)value;
    
    [lock unlock];
    
    return objectLocation;
}

- (void)setObjectLocation:(NUUInt64)aLocation for:(NUBellBall)aBellBall
{
    [lock lock];
    
	[self setOpaqueValue:(NUUInt8 *)&aLocation forKey:(NUUInt8 *)&aBellBall];
    
    [lock unlock];
}

- (void)removeObjectFor:(NUBellBall)aBellBall
{	
    [lock lock];
        
	NURegion aRegion = NUMakeRegion([self objectLocationFor:aBellBall]
										, [(NUMainBranchAliaser *)[[[self nursery] gardenForSeeker] aliaser]  sizeOfObjectForBellBall:aBellBall]);

#ifdef DEBUG
    NSLog(@"NUObjectTable #removeObjectFor:%@; aRegion:%@", NUStringFromBellBall(aBellBall), NUStringFromRegion(aRegion));
    if (aBellBall.oop == 1)
        NSLog(@"aBellBall.oop == 1");
#endif
    
	[[self spaces] releaseSpace:aRegion];
	[self removeValueFor:(NUUInt8 *)&aBellBall];
    
    [lock unlock];
}

- (NUUInt8)newGCMark
{
	return NUGCMarkWhite;
}

- (NUUInt8)gcMarkFor:(NUBellBall)aBellBall
{
	[lock lock];
	
	NUUInt32 anOOPIndex;
	NUObjectTableLeaf *aLeaf = [self leafNodeContainingBellBall:aBellBall keyIndex:&anOOPIndex];
	NUUInt8 aGCMark = NUGCMarkWhite;
	if (aLeaf) aGCMark = [aLeaf gcMarkAt:anOOPIndex];
	
	[lock unlock];
	
	return aGCMark;
}

- (void)setGCMark:(NUUInt8)aMark for:(NUBellBall)aBellBall
{
	[lock lock];
	
	NUUInt32 anOOPIndex;
	NUObjectTableLeaf *aLeaf = [self leafNodeContainingBellBall:aBellBall keyIndex:&anOOPIndex];
	if (aLeaf) [aLeaf setGCMark:aMark at:anOOPIndex];
	
	[lock unlock];
}

- (void)load
{
	if (rootLocation == 0)
		nextOOP = [[self pages] readUInt64At:NUNextOOPOffset];
    
	[super load];
}

- (void)save
{
	[[self pages] writeUInt64:nextOOP at:NUNextOOPOffset of:0];
	[super save];
}

@end
