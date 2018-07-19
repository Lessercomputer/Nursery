//
//  NUGardenSeeker.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/08/31.
//
//

#import <Foundation/NSLock.h>

#import "NUThreadedChildminder.h"
#import "NUTypes.h"

@class NSRecursiveLock;
@class NUGarden, NUBell, NUAperture, NUQueue;

@interface NUGardenSeeker : NUThreadedChildminder <NSLocking>
{
    NUQueue *bells;
    NSRecursiveLock *bellsLock;
    NUAperture *aperture;
    NSRecursiveLock *lock;
}

+ (id)gardenSeekerWithGarden:(NUGarden *)aGarden;
+ (id)gardenSeekerWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)aAperture;

- (id)initWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)aAperture;

- (void)pushRootBell:(NUBell *)aBell;
- (void)pushBellIfNeeded:(NUBell *)aBell;

- (NUQueue *)bells;

- (NUBell *)popBell;
- (void)pushBell:(NUBell *)aBell;

- (NUAperture *)aperture;
- (NUUInt64)grade;

- (void)seekObjectFor:(NUBell *)aBell;
- (void)seekIvarsOfObjectFor:(NUBell *)aBell;

- (void)collectGrade;

- (void)bellDidLoadIvars:(NUBell *)aBell;
- (void)objectDidLoadIvars:(id)anObject;

@end
