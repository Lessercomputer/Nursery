//
//  NUNurseryParader.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/12.
//
//

#import "NUTypes.h"
#import "NUThreadedChildminder.h"

extern NSString *NUParaderInvalidNodeLocationException;

@class NUMainBranchNursery;

@interface NUNurseryParader : NUThreadedChildminder
{
    NUUInt64 nextLocation;
}

+ (id)paraderWithGarden:(NUGarden *)aGarden;

- (NUMainBranchNursery *)nursery;

- (void)save;
- (void)load;

- (void)paradeObjectOrNodeNextTo:(NURegion)aFreeRegion buffer:(NUUInt8 *)aBuffer bufferSize:(NUUInt64) aBufferSize;
- (void)paradeObjectWithBellBall:(NUBellBall)aBellBall atNextTo:(NURegion)aFreeRegion buffer:(NUUInt8 *)aBuffer bufferSize:(NUUInt64)aBufferSize;
- (void)paradeNodeAtNextTo:(NURegion)aFreeRegion buffer:(NUUInt8 *)aBuffer bufferSize:(NUUInt64)aBufferSize;
- (void)computeMovedNodeRegionInto:(NURegion *)aMovedNodeRegion fromCurrentNodeRegion:(NURegion)aCurrentNodeRegion withFreeRegion:(NURegion)aFreeRegion newFreeRegion1Into:(NURegion *)aNewFreeRegion1 newFreeRegion2Into:(NURegion *)aNewFreeRegion2;

@end
