//
//  NUGardenSeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/08/31.
//
//

#import <Foundation/NSArray.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSIndexSet.h>

#import "NUGardenSeeker.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUNurseryRoot.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUSpaces.h"
#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUBellBall.h"
#import "NUMainBranchAperture.h"
#import "NUBranchAperture.h"
#import "NUMainBranchGardenSeeker.h"
#import "NUBranchGardenSeeker.h"
#import "NUU64ODictionary.h"
#import "NUQueue.h"

@implementation NUGardenSeeker

+ (id)gardenSeekerWithGarden:(NUGarden *)aGarden
{
    return [[[self alloc] initWithGarden:aGarden aperture:[[[aGarden class] apertureClass] apertureWithNursery:[aGarden nursery] garden:aGarden]] autorelease];
}

+ (id)gardenSeekerWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)aAperture
{
    return [[[self alloc] initWithGarden:aGarden aperture:aAperture] autorelease];
}

- (id)initWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)anAperture
{
    if (self = [super initWithGarden:aGarden])
    {
        aperture = [anAperture retain];
        bells = [NUQueue new];
        _gradesToPreventRelease = [NSMutableIndexSet new];
        lock = [NSRecursiveLock new];
    }
    
    return self;
}

- (void)dealloc
{
    [aperture release];
    [bells release];
    [_gradesToPreventRelease release];
    [lock release];
    
    [super dealloc];
}

- (void)start
{
    [self setIsLoaded:YES];
    [super start];
}

- (void)preventReleaseOfGrade:(NUUInt64)aGrade
{
    [self lock];
    
    [[self gradesToPreventRelease] addIndex:(NSUInteger)aGrade];
    
    [self unlock];
}

- (void)endPreventationOfReleaseOfPastGrades
{
    [self lock];
    
    [[self gradesToPreventRelease] removeAllIndexes];
    
    [self unlock];
}

- (void)lock
{
    [lock lock];
}

- (void)unlock
{
    [lock unlock];
}

- (void)pushRootBell:(NUBell *)aBell
{
    [[self garden] lock];
    
    [self lock];
    
    [[self bells] removeAll];
    [self pushBell:aBell];
    
    NUUInt64 aGrade;
    
    if ([[self gradesToPreventRelease] count])
        aGrade = [[self gradesToPreventRelease] firstIndex];
    else
        aGrade = [[self garden] grade];
    
    [self setGrade:aGrade];
    
    phase = NUGardenSeekerSeekPhase;
    
    [self unlock];
    
    [[self garden] unlock];
}

- (void)pushBellIfNeeded:(NUBell *)aBell
{
    if (aBell && [aBell gradeForGardenSeeker] < [self grade])
        [self pushBell:aBell];
}

- (NUQueue *)bells
{
    return bells;
}

- (NUBell *)popBell
{
    NUBell *aBell = nil;
    
    [self lock];
    
    aBell = [[self bells] pop];
    
    [self unlock];
    
    return aBell;
}

- (void)pushBell:(NUBell *)aBell
{
    [self lock];
    
    [[self bells] push:aBell];
    
    [self unlock];
}

- (NUAperture *)aperture
{
    return aperture;
}

- (NUUInt64)grade
{
    return grade;
}

- (void)setGrade:(NUUInt64)aGrade
{
#ifdef DEBUG
    NSLog(@"%@ currentGrade:%@, aNewGrade:%@", self, @(grade), @(aGrade));
#endif
    
    grade = aGrade;
}

- (BOOL)processOneUnit
{
    BOOL aProcessed = NO;
    NUBell *aBell;
    
    [[self garden] lock];
    if ([[self garden] isForMainBranch])
        [(NUMainBranchNursery *)[[self garden] nursery] lock];
    
    switch (phase)
    {
        case NUGardenSeekerSeekPhase:
            aBell = [self popBell];
            
            if (aBell)
                [self seekObjectFor:aBell];
            else
                phase = NUGardenSeekerCollectPhase;
            
            aProcessed = YES;
            break;
        case NUGardenSeekerCollectPhase:
            [self collectGrade];
            phase = NUGardenSeekerNonePhase;
#ifdef DEBUG
            NSLog(@"%@:didFinishCollection", self);
#endif
            aProcessed = YES;
            break;
        case NUGardenSeekerNonePhase:
            break;
    }

    if ([[self garden] isForMainBranch])
        [(NUMainBranchNursery *)[[self garden] nursery] unlock];
    [[self garden] unlock];
    
    return aProcessed;
}

- (void)seekObjectFor:(NUBell *)aBell
{    
    if ([aBell gradeForGardenSeeker] == [self grade]) return;
    
    [aBell setGradeForGardenSeeker:[self grade]];
    [self seekIvarsOfObjectFor:aBell];
}

- (void)seekIvarsOfObjectFor:(NUBell *)aBell
{
}

- (void)collectGrade
{
    @try {
        [[self garden] lock];
        
        NUU64ODictionary *aCopyOfBells = [[self garden] copyBells];
        NSMutableArray *aBells = [NSMutableArray array];
        
        [aCopyOfBells enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, NUBell *aBell, BOOL *stop)
        {
            NUUInt64 aGradeForSeekerOfBell = [aBell gradeForGardenSeeker];
            
            if (aGradeForSeekerOfBell && aGradeForSeekerOfBell < [self grade])
                [[self garden] invalidateBell:aBell];
            else
                [aBells addObject:aBell];
        }];
        
        [aCopyOfBells release];

        [[self garden] collectGradeLessThan:[self grade]];
    }
    @finally
    {
        [[self garden] unlock];
    }
}

- (void)bellDidLoadIvars:(NUBell *)aBell
{
    [[self garden] lock];
    
    if ([aBell gradeForGardenSeeker] == [self grade])
    {
        [aBell setGradeForGardenSeeker:NUNilGrade];
        [self pushBellIfNeeded:aBell];
    }
    
    [[self garden] unlock];
}

- (void)objectDidLoadIvars:(id)anObject
{
    [[self garden] lock];
    
    [self bellDidLoadIvars:[[self garden] bellForObject:anObject]];
    
    [[self garden] unlock];
}

@end
