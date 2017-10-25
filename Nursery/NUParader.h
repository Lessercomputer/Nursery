//
//  NUParader.h
//  Nursery
//
//  Created by P,T,A on 2013/01/12.
//
//

#import <Nursery/NUTypes.h>
#import <Nursery/NUThreadedChildminder.h>

extern NSString *NUParaderInvalidNodeLocationException;

@class NUMainBranchNursery;

@interface NUParader : NUThreadedChildminder
{
    NUUInt64 nextLocation;
}

+ (id)paraderWithPlayLot:(NUPlayLot *)aPlayLot;

- (NUMainBranchNursery *)nursery;

- (void)save;
- (void)load;

- (void)paradeObjectAtNextLocationWithBellBall:(NUBellBall)aBellBall  freeRegion:(NURegion)aFreeRegion buffer:(NUUInt8 *)aBuffer bufferSize:(NUUInt64)aBufferSize;
- (void)paradeNodeAtNextLocationWithFreeRegion:(NURegion)aFreeRegion buffer:(NUUInt8 *)aBuffer bufferSize:(NUUInt64)aBufferSize;
- (void)computeMovedNodeReagionInto:(NURegion *)aMovedNodeRegion fromCurrentNodeRegion:(NURegion)aCurrentNodeRegion withFreeRegion:(NURegion)aFreeRegion newFreeRegion1Into:(NURegion *)aNewFreeRegion1 newFreeRegion2Into:(NURegion *)aNewFreeRegion2;

@end
