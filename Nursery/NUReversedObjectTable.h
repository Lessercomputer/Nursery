//
//  NUReversedObjectTable.h
//  Nursery
//
//  Created by P,T,A on 2013/01/12.
//
//

#import <Nursery/NUOpaqueBTree.h>

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
