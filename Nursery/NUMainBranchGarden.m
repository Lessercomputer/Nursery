//
//  NUMainBranchGarden.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/23.
//
//

#import <Foundation/NSArray.h>

#import "NUMainBranchGarden.h"
#import "NUGarden+Project.h"
#import "NUGardenSeeker.h"
#import "NUNursery+Project.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUAliaser+Project.h"
#import "NUMainBranchAliaser.h"
#import "NUNurseryRoot.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUMainBranchGardenSeeker.h"
#import "NUMainBranchAperture.h"
#import "NUObjectTable.h"

@implementation NUMainBranchGarden

- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGardenSeeker:(BOOL)aUsesGardenSeeker retainNursery:(BOOL)aRetainFlag
{
    if (self = [super initWithNursery:aNursery grade:aGrade usesGardenSeeker:aUsesGardenSeeker retainNursery:aRetainFlag])
    {
        farmOutLock = [NSLock new];
    }
    
    return self;
}

+ (Class)aliaserClass
{
    return [NUMainBranchAliaser class];
}

+ (Class)gardenSeekerClass
{
    return [NUMainBranchGardenSeeker class];
}

+ (Class)apertureClass
{
    return [NUMainBranchAperture class];
}

- (void)dealloc
{
    [farmOutLock release];
    farmOutLock = nil;
    
    [super dealloc];
}

@end

@implementation NUMainBranchGarden (Bell)

- (BOOL)bellGradeIsUnmatched:(NUBell *)aBell
{
    NUBellBall aGraterBellBall = [[[self mainBranchNursery] objectTable] bellBallGreaterThanBellBall:aBell.ball];
    
    if (NUBellBallEquals(aGraterBellBall, NUNotFoundBellBall))
        return NO;
    
    return aGraterBellBall.oop == aBell.OOP && aGraterBellBall.grade <= [self grade] ? YES : NO;
}

@end

@implementation NUMainBranchGarden (SaveAndLoad)

- (NUFarmOutStatus)farmOut
{
    NUFarmOutStatus aFarmOutStatus = NUFarmOutStatusFailed;
    
    @try
    {
        @autoreleasepool
        {
            [farmOutLock lock];
            [[self gardenSeeker] stop];
            [self lock];
            [[self mainBranchNursery] LockAndStopChildminders];
            
            if (![[self nursery] open])
            {
                aFarmOutStatus = NUFarmOutStatusFailed;
            }
            else if (![self gradeIsEqualToNurseryGrade])
            {
                aFarmOutStatus = NUFarmOutStatusNurseryGradeUnmatched;
            }
            else
            {
                if ([self gradeIsEqualToNurseryGrade])
                {
                    NUUInt64 aNewGrade = [[self mainBranchNursery] newGrade];
                    
                    [[self mainBranchAliaser] setGradeForSave:aNewGrade];
                    
                    if (![self contains:[self nurseryRoot]])
                        [[self aliaser] setRoots:[NSMutableArray arrayWithObject:[self nurseryRoot]]];
                    
                    [[self aliaser] encodeObjects];
                    [self setNurseryRootOOP];
                    aFarmOutStatus = [[self mainBranchNursery] save] ? NUFarmOutStatusSucceeded : NUFarmOutStatusFailed;
                    
                    if (aFarmOutStatus == NUFarmOutStatusSucceeded)
                    {
                        [[self mainBranchNursery] retainGrade:aNewGrade byGarden:self];
                        [[self mainBranchNursery] releaseGradeLessThan:aNewGrade byGarden:self];
                        [self setGrade:aNewGrade];
                        [[self gardenSeeker] pushRootBell:[[self nurseryRoot] bell]];
                    }
                }
                else
                {
                    aFarmOutStatus = NUFarmOutStatusNurseryGradeUnmatched;
                }
            }
        }
    }
    @finally
    {
        if (aFarmOutStatus == NUFarmOutStatusSucceeded)
            [[self gardenSeeker] endPreventationOfReleaseOfPastGrades];
        
        [[self mainBranchNursery] unlockAndStartChildminders];
        [self unlock];
        [[self gardenSeeker] start];
        [farmOutLock unlock];
    }
    
    return aFarmOutStatus;
}

@end

@implementation NUMainBranchGarden (Private)

- (NUMainBranchNursery *)mainBranchNursery
{
    return (NUMainBranchNursery *)[self nursery];
}

- (NUMainBranchAliaser *)mainBranchAliaser
{
    return (NUMainBranchAliaser *)[self aliaser];
}

- (void)setNurseryRootOOP
{
	[[self mainBranchNursery] saveRootOOP:[[self bellForObject:[self nurseryRoot]] OOP]];
}

@end
