//
//  NUGradeSeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/08/31.
//
//

#import "NUGradeSeeker.h"
#import "NUSandbox.h"
#import "NUNurseryRoot.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUMainBranchAperture.h"
#import "NUBranchAperture.h"
#import "NUMainBranchGradeSeeker.h"
#import "NUBranchGradeSeeker.h"
#import "NUU64ODictionary.h"

@implementation NUGradeSeeker

+ (id)gradeSeekerWithSandbox:(NUSandbox *)aSandbox
{
    Class aApertureClass = [aSandbox isForMainBranch] ? [NUMainBranchAperture class] : [NUBranchAperture class];
    Class aSeekerClass = [aSandbox isForMainBranch] ? [NUMainBranchGradeSeeker class] : [NUBranchGradeSeeker class];
    return [[[aSeekerClass alloc] initWithSandbox:aSandbox aperture:[aApertureClass apertureWithNursery:[aSandbox nursery] sandbox:aSandbox]] autorelease];
}

+ (id)gradeSeekerWithSandbox:(NUSandbox *)aSandbox aperture:(NUAperture *)aAperture
{
    return [[[self alloc] initWithSandbox:aSandbox aperture:aAperture] autorelease];
}

- (id)initWithSandbox:(NUSandbox *)aSandbox aperture:(NUAperture *)aAperture
{
    if (self = [super initWithSandbox:aSandbox])
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
    return [[self sandbox] grade];
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
        [[self sandbox] lock];
        
        [[self sandbox] invalidateBellsWithNotReferencedObject];
        [[self sandbox] invalidateNotReferencedBells];
        
        [[[self sandbox] bells] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, NUBell *aBell, BOOL *stop) {
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
        [[self sandbox] unlock];
    }
}

- (NSMutableArray *)collectBellWithGradeLessThanCurrent
{
    @try {
        [[self sandbox] lock];
        
        NSMutableArray *aBells = [NSMutableArray array];
        
        [[[self sandbox] bells] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, NUBell *aBell, BOOL *stop) {
            if ([aBell gradeForSeeker] < [self grade])
                [aBells addObject:aBell];
        }];
        
        return aBells;
    }
    @finally {
        [[self sandbox] unlock];
    }
}

- (void)collectGradeLessThan:(NUUInt64)aGrade
{
#ifdef DEBUG
    NSLog(@"<%@:%p> #collectGradeLessThan:%llu", [self class], self, aGrade);
#endif
    
    [[self sandbox] collectGradeLessThan:aGrade];
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
    [self bellDidLoadIvars:[[self sandbox] bellForObject:anObject]];
}

@end
