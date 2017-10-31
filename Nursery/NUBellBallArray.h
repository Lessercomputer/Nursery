//
//  NUBellBallArray.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/08/17.
//
//

#import <Nursery/Nursery.h>

@interface NUBellBallArray : NUOpaqueArray

+ (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator;

- (id)initWithCapacity:(NUUInt32)aCapacity comparator:(NUInt (*)(NUUInt8 *, NUUInt8 *))aComparator;

- (void)insertBellBall:(NUBellBall)aBellBall to:(NUUInt32)anIndex;
- (NUBellBall)bellBallAt:(NUUInt32)anIndex;
- (void)replaceBellBallAt:(NUUInt32)anIndex with:(NUBellBall)aBellBall;

@end
