//
//  NUNurseryParader.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/12.
//
//

#import "NUTypes.h"
#import "NUChildminder.h"

extern NSString *NUParaderInvalidNodeLocationException;

@class NSMutableArray;

@class NUMainBranchNursery, NUOpaqueBPlusTreeNode;

@interface NUNurseryParader : NUChildminder
{
    NUUInt64 nextLocation;
    NUUInt64 grade;
}

+ (id)paraderWithGarden:(NUGarden *)aGarden;

- (NUUInt64)grade;
- (void)setGrade:(NUUInt64)aGrade;
- (NUMainBranchNursery *)nursery;

- (void)save;
- (void)load;

- (void)paradeObjectOrNodeNextTo:(NURegion)aFreeRegion;
- (void)paradeObjectWithBellBall:(NUBellBall)aBellBall at:(NUUInt64)anObjectLocation nextTo:(NURegion)aFreeRegion;
- (void)paradeNodeAt:(NUUInt64)aNodeLocation nextTo:(NURegion)aFreeRegion;

@end
