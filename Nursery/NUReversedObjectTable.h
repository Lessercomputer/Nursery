//
//  NUReversedObjectTable.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/12.
//
//

#import "NUOpaqueBTree.h"

@class NSRecursiveLock;

@interface NUReversedObjectTable : NUOpaqueBTree
{
    NSRecursiveLock *lock;
}

- (id)initWithRootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces;

- (NUBellBall)bellBallForObjectLocation:(NUUInt64)anObjectLocation;
- (void)setBellBall:(NUBellBall)aBellBall forObjectLocation:(NUUInt64)anObjectLocation;
- (void)removeBellBallForObjectLocation:(NUUInt64)anObjectLocation;

- (NUBellBall)bellBallForObjectLocationGreaterThanOrEqualTo:(NUUInt64)aLocation;

@end
