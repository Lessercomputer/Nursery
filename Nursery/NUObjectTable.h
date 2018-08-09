//
//  NUObjectTable.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/25.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUOpaqueBPlusTree.h"

@class NUGarden, NUObjectTableLeaf;

extern const NUUInt64 NUNilOOP;
extern const NUUInt64 NUCharacterOOP;
extern const NUUInt64 NSStringOOP;
extern const NUUInt64 NUNSStringOOP;
extern const NUUInt64 NSArrayOOP;
extern const NUUInt64 NUNSArrayOOP;
extern const NUUInt64 NSMutableArrayOOP;
extern const NUUInt64 NUNSMutableArrayOOP;
extern const NUUInt64 NUIvarOOP;
extern const NUUInt64 NSDictionaryOOP;
extern const NUUInt64 NUNSDictionaryOOP;
extern const NUUInt64 NSMutableDictionaryOOP;
extern const NUUInt64 NUNSMutableDictionaryOOP;
extern const NUUInt64 NSObjectOOP;
extern const NUUInt64 NUCharacterDictionaryOOP;
extern const NUUInt64 NUNurseryRootOOP;
extern const NUUInt64 NUCharacterDictionaryOOP;
extern const NUUInt64 NUMutableDictionaryOOP;
extern const NUUInt64 NSSetOOP;
extern const NUUInt64 NUNSSetOOP;
extern const NUUInt64 NSMutableSetOOP;
extern const NUUInt64 NUNSMutableSetOOP;

extern const NUUInt64 NUObjectTableLeafNodeOOP;
extern const NUUInt64 NUObjectTableBranchNodeOOP;
extern const NUUInt64 NUReversedObjectTableLeafNodeOOP;
extern const NUUInt64 NUReversedObjectTableBranchNodeOOP;
extern const NUUInt64 NULocationTreeLeafNodeOOP;
extern const NUUInt64 NULocationTreeBranchNodeOOP;
extern const NUUInt64 NULengthTreeLeafNodeOOP;
extern const NUUInt64 NULengthTreeBranchNodeOOP;
extern const NUUInt64 NUFreeRegionNodeOOP;
extern const NUUInt64 NUFreeRegionNodeListOOP;
extern const NUUInt64 NUFirstUserObjectOOP;
extern const NUUInt64 NUDefaultFirstProbationayOOP;
extern const NUUInt64 NUDefaultMaximumProbationaryOOPCount;
extern const NUUInt64 NUDefaultLastProbationaryOOP;

extern const NUUInt8 NUGCMarkNone;
extern const NUUInt8 NUGCMarkWhite;
extern const NUUInt8 NUGCMarkGray;
extern const NUUInt8 NUGCMarkBlack;
extern const NUUInt8 NUGCMarkWithoutColorBitsMask;
extern const NUUInt8 NUGCMarkColorBitsMask;

@interface NUObjectTable : NUOpaqueBPlusTree
{
	NUUInt64 nextOOP;
}

- (id)initWithRootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces;

- (NUBellBall)firstBellBall;
- (NUUInt64)firstGrayOOPGradeLessThanOrEqualTo:(NUUInt64)aGrade;
- (NUBellBall)bellBallLessThanOrEqualTo:(NUBellBall)aBellBall;;
- (NUBellBall)bellBallGreaterThanBellBall:(NUBellBall)aBellBall;
- (NUUInt64)grayOOPGreaterThanOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade;

- (NUObjectTableLeaf *)leafNodeContainingBellBall:(NUBellBall)aBellBall keyIndex:(NUUInt32 *)aKeyIndex;
- (NUObjectTableLeaf *)leafNodeContainingBellBallLessThanOrEqualTo:(NUBellBall)aBellBall keyIndex:(NUUInt32 *)aKeyIndex;

- (NUBellBall)allocateBellBallWithGrade:(NUUInt64)aGrade;

- (NUUInt64)objectLocationForOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade gradeInto:(NUUInt64 *)aFoundGrade;

- (NUUInt64)objectLocationFor:(NUBellBall)aBellBall;
- (void)setObjectLocation:(NUUInt64)aLocation for:(NUBellBall)aBellBall;
- (void)removeObjectFor:(NUBellBall)aBellBall;

- (NUUInt8)newGCMark;
- (NUUInt8)gcMarkFor:(NUBellBall)aBellBall;
- (void)setGCMark:(NUUInt8)aMark for:(NUBellBall)aBellBall;

@end
