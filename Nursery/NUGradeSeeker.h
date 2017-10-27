//
//  NUGradeSeeker.h
//  Nursery
//
//  Created by P,T,A on 2013/08/31.
//
//

#import "NUThreadedChildminder.h"
#import "NUTypes.h"

@class NUSandbox, NUBell, NUAperture;

@interface NUGradeSeeker : NUThreadedChildminder <NSLocking>
{
    NSMutableArray *bells;
    NSRecursiveLock *bellsLock;
    NUAperture *aperture;
    NSRecursiveLock *lock;
}

+ (id)gradeSeekerWithSandbox:(NUSandbox *)aSandbox;
+ (id)gradeSeekerWithSandbox:(NUSandbox *)aSandbox aperture:(NUAperture *)aAperture;

- (id)initWithSandbox:(NUSandbox *)aSandbox aperture:(NUAperture *)aAperture;

- (void)pushRootBell:(NUBell *)aBell;
- (void)pushBellIfNeeded:(NUBell *)aBell;

- (NSMutableArray *)bells;

- (NUBell *)popBell;
- (void)pushBell:(NUBell *)aBell;

- (NUAperture *)aperture;
- (NUUInt64)grade;

- (void)seekObjectFor:(NUBell *)aBell;
- (void)seekIvarsOfObjectFor:(NUBell *)aBell;

- (void)collectGrade;
- (void)collectGradeLessThan:(NUUInt64)aGrade;

- (void)bellDidLoadIvars:(NUBell *)aBell;
- (void)objectDidLoadIvars:(id)anObject;

@end
