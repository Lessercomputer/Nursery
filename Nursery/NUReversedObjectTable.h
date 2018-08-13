//
//  NUReversedObjectTable.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/12.
//
//

#import "NUOpaqueBPlusTree.h"

@class NSCountedSet;

@interface NUReversedObjectTable : NUOpaqueBPlusTree
{
    NSCountedSet *removedObjectLocations;
    NSCountedSet *setKeyAndValues;
}

- (id)initWithRootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces;

- (NUBellBall)bellBallForObjectLocation:(NUUInt64)anObjectLocation;
- (void)setBellBall:(NUBellBall)aBellBall forObjectLocation:(NUUInt64)anObjectLocation;
- (void)removeBellBallForObjectLocation:(NUUInt64)anObjectLocation;

- (NUBellBall)bellBallForObjectLocationGreaterThanOrEqualTo:(NUUInt64)aLocation;

- (NUBellBall)scanBellBallForObjectLocation:(NUUInt64)anObjectLocation;

@end
