//
//  NUGradeKidnapper.h
//  Nursery
//
//  Created by P,T,A on 2013/08/31.
//
//

#import "NUThreadedChildminder.h"
#import "NUTypes.h"

@class NUPlayLot, NUBell, NUPeephole;

@interface NUGradeKidnapper : NUThreadedChildminder <NSLocking>
{
    NSMutableArray *bells;
    NSRecursiveLock *bellsLock;
    NUPeephole *peephole;
    NSRecursiveLock *lock;
}

+ (id)gradeKidnapperWithPlayLot:(NUPlayLot *)aPlayLot;
+ (id)gradeKidnapperWithPlayLot:(NUPlayLot *)aPlayLot peephole:(NUPeephole *)aPeephole;

- (id)initWithPlayLot:(NUPlayLot *)aPlayLot peephole:(NUPeephole *)aPeephole;

- (void)pushRootBell:(NUBell *)aBell;
- (void)pushBellIfNeeded:(NUBell *)aBell;

- (NSMutableArray *)bells;

- (NUBell *)popBell;
- (void)pushBell:(NUBell *)aBell;

- (NUPeephole *)peephole;
- (NUUInt64)grade;

- (void)stalkObjectFor:(NUBell *)aBell;
- (void)stalkIvarsOfObjectFor:(NUBell *)aBell;

- (void)kidnapGrade;
- (void)kidnapGradeLessThan:(NUUInt64)aGrade;

- (void)bellDidLoadIvars:(NUBell *)aBell;
- (void)objectDidLoadIvars:(id)anObject;

@end
