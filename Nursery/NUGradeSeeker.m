//
//  NUGradeSeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/08/31.
//
//

#import <Foundation/NSArray.h>

#import "NUGradeSeeker.h"
#import "NUGarden.h"
#import "NUNurseryRoot.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUMainBranchAperture.h"
#import "NUBranchAperture.h"
#import "NUMainBranchGradeSeeker.h"
#import "NUBranchGradeSeeker.h"
#import "NUU64ODictionary.h"

@implementation NUGradeSeeker

+ (id)gradeSeekerWithGarden:(NUGarden *)aGarden
{
    Class aApertureClass = [aGarden isForMainBranch] ? [NUMainBranchAperture class] : [NUBranchAperture class];
    Class aSeekerClass = [aGarden isForMainBranch] ? [NUMainBranchGradeSeeker class] : [NUBranchGradeSeeker class];
    return [[[aSeekerClass alloc] initWithGarden:aGarden aperture:[aApertureClass apertureWithNursery:[aGarden nursery] garden:aGarden]] autorelease];
}

+ (id)gradeSeekerWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)aAperture
{
    return [[[self alloc] initWithGarden:aGarden aperture:aAperture] autorelease];
}

- (id)initWithGarden:(NUGarden *)aGarden aperture:(NUAperture *)aAperture
{
    if (self = [super initWithGarden:aGarden])
    {
        aperture = [aAperture retain];
        bellsLock = [NSRecursiveLock new];
        bells = [NSMutableArray new];
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
    
    [[self bells] removeAllObjects];
    [self pushBell:aBell];
    
    [bellsLock unlock];
}

- (void)pushBellIfNeeded:(NUBell *)aBell
{
    if (aBell && [aBell gradeForSeeker] < [self grade])
        [self pushBell:aBell];
}

- (NSMutableArray *)bells
{
    return bells;
}

- (NUBell *)popBell
{
    NUBell *aBell = nil;
    
    [bellsLock lock];
    
    if ([[self bells] count])
    {
        aBell = [[self bells] lastObject];
        [[self bells] removeLastObject];
    }
    
    [bellsLock unlock];
    
    return aBell;
}

- (void)pushBell:(NUBell *)aBell
{
    [bellsLock lock];
    
    [[self bells] addObject:aBell];
    
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
    while (![self shouldStop])
    {
        [self lock];
        
        NUBell *aBell = [self popBell];
        
        if (aBell)
            [self seekObjectFor:aBell];
        else
        {
            [self collectGrade];
            [self setShouldStop:YES];
        }
        
        [self unlock];
    }
}

- (void)seekObjectFor:(NUBell *)aBell
{    
    if ([aBell gradeForSeeker] == [self grade]) return;
    
    [aBell setGradeForSeeker:[self grade]];
    
    //if (![aBell isLoaded]) return;
    
    [self seekIvarsOfObjectFor:aBell];
}

- (void)seekIvarsOfObjectFor:(NUBell *)aBell
{
    
}

- (void)collectGrade
{
    __block BOOL aGradeLessThanCurrentFound = NO;
    
    @try {
        [[self garden] lock];
        
        [[self garden] invalidateBellsWithNotReferencedObject];
        [[self garden] invalidateNotReferencedBells];
        
        [[[self garden] bells] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, NUBell *aBell, BOOL *stop) {
            if ([aBell gradeForSeeker] < [self grade])
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
            NSMutableArray *aBells = [self collectBellWithGradeLessThanCurrent];
            NSLog(@"aBells: %@", aBells);
#endif
        }
    }
    @finally {
        [[self garden] unlock];
    }
}

- (NSMutableArray *)collectBellWithGradeLessThanCurrent
{
    @try {
        [[self garden] lock];
        
        NSMutableArray *aBells = [NSMutableArray array];
        
        [[[self garden] bells] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, NUBell *aBell, BOOL *stop) {
            if ([aBell gradeForSeeker] < [self grade])
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
    if ([aBell gradeForSeeker] == [self grade])
    {
        [aBell setGradeForSeeker:NUNilGrade];
        [self pushBellIfNeeded:aBell];
    }
}

- (void)objectDidLoadIvars:(id)anObject
{
    [self bellDidLoadIvars:[[self garden] bellForObject:anObject]];
}

@end
