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

@class NSRecursiveLock, NSMutableIndexSet;
@class NUGarden, NUBell, NUAperture, NUQueue;

typedef enum : NUUInt64 {
    NUGardenSeekerNonePhase,
    NUGardenSeekerSeekPhase,
    NUGardenSeekerCollectPhase
} NUGardenSeekerPhase;

@interface NUGardenSeeker : NUThreadedChildminder <NSLocking>
{
    NUGardenSeekerPhase phase;
    NUQueue *bells;
    NUAperture *aperture;
    NUUInt64 grade;
    NSRecursiveLock *lock;
}

+ (id)gardenSeekerWithGarden:(NUGarden *)aGarden;
+ (id)gardenSeekerWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)aAperture;

- (id)initWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)aAperture;

@property (nonatomic, retain) NSMutableIndexSet *gradesToPreventRelease;

- (void)preventReleaseOfGrade:(NUUInt64)aGrade;
- (void)endPreventationOfReleaseOfPastGrades;

- (void)pushRootBell:(NUBell *)aBell;
- (void)pushBellIfNeeded:(NUBell *)aBell;

- (NUQueue *)bells;

- (NUBell *)popBell;
- (void)pushBell:(NUBell *)aBell;

- (NUAperture *)aperture;
- (NUUInt64)grade;
- (void)setGrade:(NUUInt64)aGrade;

- (void)seekObjectFor:(NUBell *)aBell;
- (void)seekIvarsOfObjectFor:(NUBell *)aBell;

- (void)collectGrade;

- (void)bellDidLoadIvars:(NUBell *)aBell;
- (void)objectDidLoadIvars:(id)anObject;

@end
