//
//  NUGradeSeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/08/31.
//
//

#import <Foundation/NSArray.h>
#import <Foundation/NSThread.h>

#import "NUGradeSeeker.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUNurseryRoot.h"
#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUBellBall.h"
#import "NUMainBranchAperture.h"
#import "NUBranchAperture.h"
#import "NUMainBranchGradeSeeker.h"
#import "NUBranchGradeSeeker.h"
#import "NUU64ODictionary.h"
#import "NUQueue.h"

@implementation NUGradeSeeker

+ (id)gradeSeekerWithGarden:(NUGarden *)aGarden
{
    return [[[self alloc] initWithGarden:aGarden aperture:[[[aGarden class] apertureClass] apertureWithNursery:[aGarden nursery] garden:aGarden]] autorelease];
}

+ (id)gradeSeekerWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)aAperture
{
    return [[[self alloc] initWithGarden:aGarden aperture:aAperture] autorelease];
}

- (id)initWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)anAperture
{
    if (self = [super initWithGarden:aGarden])
    {
        aperture = [anAperture retain];
        bellsLock = [NSRecursiveLock new];
        bells = [NUQueue new];
        lock = [NSRecursiveLock new];
    }
    
    return self;
}

- (void)dealloc
{
    [aperture release];
    [bellsLock release];
    [bells release];
    [lock release];
    
    [super dealloc];
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
    [bellsLock lock];
    
    [[self bells] removeAll];
    [self pushBell:aBell];
    
    [bellsLock unlock];
}

- (void)pushBellIfNeeded:(NUBell *)aBell
{
    if (aBell && [aBell gradeForGradeSeeker] < [self grade])
        [self pushBell:aBell];
}

- (NUQueue *)bells
{
    return bells;
}

- (NUBell *)popBell
{
    NUBell *aBell = nil;
    
    [bellsLock lock];
    
    aBell = [[self bells] pop];
    
    [bellsLock unlock];
    
    return aBell;
}

- (void)pushBell:(NUBell *)aBell
{
    [bellsLock lock];
    
    [[self bells] push:aBell];
    
    [bellsLock unlock];
}

- (NUAperture *)aperture
{
    return aperture;
}

- (NUUInt64)grade
{
    return [[self garden] grade];
}

- (void)process
{
    NUUInt64 aNumberOfTimesToCollect = 3;
    NUUInt64 aNumberOfTimesCollected = 0;
    NSTimeInterval aSleepTimeInterval = 0.2;
    
    while (![self shouldStop])
    {
        @autoreleasepool
        {
            [self lock];
            
            NUBell *aBell = [self popBell];
            
            if (aBell)
                [self seekObjectFor:aBell];
            else
            {
                BOOL aGradeLessThanCurrentFound = [self collectGrade];
                aNumberOfTimesCollected++;
                
                if (!aGradeLessThanCurrentFound || aNumberOfTimesCollected == aNumberOfTimesToCollect)
                    [self setShouldStop:YES];
                else
                    [NSThread sleepForTimeInterval:aSleepTimeInterval];
            }
            
            [self unlock];
        }
    }
}

- (void)seekObjectFor:(NUBell *)aBell
{    
    if ([aBell gradeForGradeSeeker] == [self grade]) return;
    
    [aBell setGradeForGradeSeeker:[self grade]];
    
    //if (![aBell isLoaded]) return;
    
    [self seekIvarsOfObjectFor:aBell];
}

- (void)seekIvarsOfObjectFor:(NUBell *)aBell
{
    
}

- (BOOL)collectGrade
{
    __block BOOL aGradeLessThanCurrentFound = NO;
    
    @try {
        [[self garden] lock];
        
        [[self garden] invalidateBellsWithNotReferencedObject];
        [[self garden] invalidateNotReferencedBells];
        
        [[[self garden] bells] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, NUBell *aBell, BOOL *stop) {
            if ([aBell gradeForGradeSeeker] < [self grade])
            {
                aGradeLessThanCurrentFound = YES;
                *stop = YES;
            }
        }];
        
        if (!aGradeLessThanCurrentFound)
            [self collectGradeLessThan:[self grade]];
        else
        {
#ifdef DEBUG
            NSMutableArray *aBells = [self selectBellWithGradeLessThanCurrent];
            NSLog(@"aBells: %@", aBells);
#endif
        }
    }
    @finally {
        [[self garden] unlock];
    }
    
    return aGradeLessThanCurrentFound;
}

- (NSMutableArray *)selectBellWithGradeLessThanCurrent
{
    @try {
        [[self garden] lock];
        
        NSMutableArray *aBells = [NSMutableArray array];
        
        [[[self garden] bells] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, NUBell *aBell, BOOL *stop) {
            if ([aBell gradeForGradeSeeker] < [self grade])
                [aBells addObject:aBell];
        }];
        
        return aBells;
    }
    @finally {
        [[self garden] unlock];
    }
}

- (void)collectGradeLessThan:(NUUInt64)aGrade
{
#ifdef DEBUG
    NSLog(@"<%@:%p> #collectGradeLessThan:%llu", [self class], self, aGrade);
#endif
    
    [[self garden] collectGradeLessThan:aGrade];
}

- (void)bellDidLoadIvars:(NUBell *)aBell
{
    if ([aBell gradeForGradeSeeker] == [self grade])
    {
        [aBell setGradeForGradeSeeker:NUNilGrade];
        [self pushBellIfNeeded:aBell];
    }
}

- (void)objectDidLoadIvars:(id)anObject
{
    [self bellDidLoadIvars:[[self garden] bellForObject:anObject]];
}

@end
