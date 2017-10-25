//
//  NUGradeKidnapper.m
//  Nursery
//
//  Created by P,T,A on 2013/08/31.
//
//

#import "NUGradeKidnapper.h"
#import "NUPlayLot.h"
#import "NUNurseryRoot.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUMainBranchPeephole.h"
#import "NUBranchPeephole.h"
#import "NUMainBranchGradeKidnapper.h"
#import "NUBranchGradeKidnapper.h"

@implementation NUGradeKidnapper

+ (id)gradeKidnapperWithPlayLot:(NUPlayLot *)aPlayLot
{
    Class aPeepholeClass = [aPlayLot isForMainBranch] ? [NUMainBranchPeephole class] : [NUBranchPeephole class];
    Class aKidnapperClass = [aPlayLot isForMainBranch] ? [NUMainBranchGradeKidnapper class] : [NUBranchGradeKidnapper class];
    return [[[aKidnapperClass alloc] initWithPlayLot:aPlayLot peephole:[aPeepholeClass peepholeWithNursery:[aPlayLot nursery] playLot:aPlayLot]] autorelease];
}

+ (id)gradeKidnapperWithPlayLot:(NUPlayLot *)aPlayLot peephole:(NUPeephole *)aPeephole
{
    return [[[self alloc] initWithPlayLot:aPlayLot peephole:aPeephole] autorelease];
}

- (id)initWithPlayLot:(NUPlayLot *)aPlayLot peephole:(NUPeephole *)aPeephole
{
    if (self = [super initWithPlayLot:aPlayLot])
    {
        peephole = [aPeephole retain];
        bellsLock = [NSRecursiveLock new];
        bells = [NSMutableArray new];
        lock = [NSRecursiveLock new];
    }
    
    return self;
}

- (void)dealloc
{
    [peephole release];
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
    if (aBell && [aBell gradeForKidnapper] < [self grade])
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

- (NUPeephole *)peephole
{
    return peephole;
}

- (NUUInt64)grade
{
    return [[self playLot] grade];
}

- (void)process
{
    while (![self shouldStop])
    {
        [self lock];
        
        NUBell *aBell = [self popBell];
        
        if (aBell)
            [self stalkObjectFor:aBell];
        else
        {
            [self kidnapGrade];
            [self setShouldStop:YES];
        }
        
        [self unlock];
    }
}

- (void)stalkObjectFor:(NUBell *)aBell
{    
    if ([aBell gradeForKidnapper] == [self grade]) return;
    
    [aBell setGradeForKidnapper:[self grade]];
    
    //if (![aBell isLoaded]) return;
    
    [self stalkIvarsOfObjectFor:aBell];
}

- (void)stalkIvarsOfObjectFor:(NUBell *)aBell
{
    
}

- (void)kidnapGrade
{
    __block BOOL aGradeLessThanCurrentFound = NO;
    
    @try {
        [[self playLot] lock];
        
        [[self playLot] invalidateBellsWithNotReferencedObject];
        [[self playLot] invalidateNotReferencedBells];
        
        [[[self playLot] bellSet] enumerateObjectsUsingBlock:^(NUBell *aBell, BOOL *stop) {
            if ([aBell gradeForKidnapper] < [self grade])
            {
                aGradeLessThanCurrentFound = YES;
                *stop = YES;
            }
        }];
        
        if (!aGradeLessThanCurrentFound)
            [self kidnapGradeLessThan:[self grade]];
        else
        {
#ifdef DEBUG
            NSMutableArray *aBells = [self collectBellWithGradeLessThanCurrent];
            NSLog(@"aBells: %@", aBells);
#endif
        }
    }
    @finally {
        [[self playLot] unlock];
    }
}

- (NSMutableArray *)collectBellWithGradeLessThanCurrent
{
    @try {
        [[self playLot] lock];
        
        NSMutableArray *aBells = [NSMutableArray array];
        
        [[[self playLot] bellSet] enumerateObjectsUsingBlock:^(NUBell *aBell, BOOL *stop) {
            if ([aBell gradeForKidnapper] < [self grade])
                [aBells addObject:aBell];
        }];
        
        return aBells;
    }
    @finally {
        [[self playLot] unlock];
    }
}

- (void)kidnapGradeLessThan:(NUUInt64)aGrade
{
#ifdef DEBUG
    NSLog(@"<%@:%p> #kidnapGradeLessThan:%llu", [self class], self, aGrade);
#endif
    
    [[self playLot] kidnapGradeLessThan:aGrade];
}

- (void)bellDidLoadIvars:(NUBell *)aBell
{
    if ([aBell gradeForKidnapper] == [self grade])
    {
        [aBell setGradeForKidnapper:NUNilGrade];
        [self pushBellIfNeeded:aBell];
    }
}

- (void)objectDidLoadIvars:(id)anObject
{
    [self bellDidLoadIvars:[[self playLot] bellForObject:anObject]];
}

@end
