//
//  NUMainBranchPlayLot.m
//  Nursery
//
//  Created by P,T,A on 2013/10/23.
//
//

#import "NUMainBranchPlayLot.h"
#import "NUGradeKidnapper.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchAliaser.h"

@implementation NUMainBranchPlayLot

- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeKidnapper:(BOOL)aUsesGradeKidnapper
{
    if (self = [super initWithNursery:aNursery grade:aGrade usesGradeKidnapper:aUsesGradeKidnapper])
    {
        farmOutLock = [NSLock new];
    }
    
    return self;
}

- (void)dealloc
{
    [farmOutLock release];
    
    [super dealloc];
}

- (id)retain
{
    return [super retain];
}

@end

@implementation NUMainBranchPlayLot (SaveAndLoad)

- (NUFarmOutStatus)farmOut
{
    NUFarmOutStatus aFarmOutStatus = NUFarmOutStatusFailed;
    
    @try
    {
        @autoreleasepool
        {
            [farmOutLock lock];
            [[self gradeKidnapper] stop];
            [self lock];
            
            if (![[self nursery] open]) return NUFarmOutStatusFailed;
            if (![self gradeIsEqualToNurseryGrade]) return NUFarmOutStatusNurseryGradeUnmatched;
            
            [[self mainBranchNursery] lockForFarmOut];
            
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
                    [[self mainBranchNursery] retainGrade:aNewGrade byPlayLot:self];
                    [self setGrade:aNewGrade];
                    [[self gradeKidnapper] pushRootBell:[[self nurseryRoot] bell]];
                }
            }
            else
            {
                aFarmOutStatus = NUFarmOutStatusNurseryGradeUnmatched;
            }
            
            [[self mainBranchNursery] unlockForFarmOut];
        }
    }
    @finally
    {
        [self unlock];
        [[self gradeKidnapper] startWithoutWait];
        [farmOutLock unlock];
        
        return aFarmOutStatus;
    }
}

@end

@implementation NUMainBranchPlayLot (Private)

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