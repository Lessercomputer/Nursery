//
//  NUPairedMainBranchPlayLot.m
//  Nursery
//
//  Created by P,T,A on 2014/03/15.
//
//

#import "NUPairedMainBranchPlayLot.h"
#import "NUGradeKidnapper.h"
#import "NUMainBranchAliaser.h"
#import "NUPairedMainBranchAliaser.h"
#import "NUObjectTable.h"

@implementation NUPairedMainBranchPlayLot

+ (id)playLotWithNursery:(NUNursery *)aNursery usesGradeKidnapper:(BOOL)aUsesGradeKidnapper
{
    return [[[self alloc] initWithNursery:aNursery usesGradeKidnapper:aUsesGradeKidnapper] autorelease];
}

- (NUPairedMainBranchAliaser *)pairedMainBranchAliaser
{
    return (NUPairedMainBranchAliaser *)[self aliaser];
}

@end

@implementation NUPairedMainBranchPlayLot (Pupil)

- (NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade containsFellowPupils:(BOOL)aContainsFellowPupils
{
    [self moveUpTo:aGrade];
    
    return [[self pairedMainBranchAliaser] callForPupilWithOOP:anOOP containsFellowPupils:aContainsFellowPupils];
}

- (NUFarmOutStatus)farmOutPupils:(NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP fixedOOPs:(NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade
{
    if (![self gradeIsEqualToNurseryGrade])
        [self moveUpTo:[[self nursery] latestGrade:self]];
    
    NUFarmOutStatus aFarmOutStatus = NUFarmOutStatusFailed;
    
    *aFixedOOPs = nil;
    
    @try
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
            NSArray *aPupils = nil;
            NUUInt64 aFixedRootOOP;

            [[self pairedMainBranchAliaser] setGradeForSave:aNewGrade];
            aPupils = [[self pairedMainBranchAliaser] pupilsFromData:aPupilData];
            [[self pairedMainBranchAliaser] setPupils:aPupils];
            
            if ([[self mainBranchNursery] rootOOP] == NUNilOOP)
                [self moveUpTo:aNewGrade];
            
            [[self pairedMainBranchAliaser] fixProbationaryOOPsInPupils];
//#ifdef DEBUG
//            NSLog(@"%@", [[self pairedMainBranchAliaser] descriptionForPupils]);
//#endif
            [[self pairedMainBranchAliaser] encodeProbationaryPupils];
            *aFixedOOPs = [[self pairedMainBranchAliaser] dataWithProbationaryOOPAndFixedOOP];
            
            aFixedRootOOP = [[self pairedMainBranchAliaser] fixedRootOOPForOOP:aRootOOP];
            
            if ([[self pairedMainBranchAliaser] rootOOP] != aFixedRootOOP)
                [[self mainBranchNursery] saveRootOOP:aFixedRootOOP];
            
            aFarmOutStatus = [[self mainBranchNursery] save] ? NUFarmOutStatusSucceeded : NUFarmOutStatusFailed;

            if (aFarmOutStatus == NUFarmOutStatusSucceeded)
            {
                [[self mainBranchNursery] retainGrade:aNewGrade byPlayLot:self];
                [self setGrade:aNewGrade];
                [[self gradeKidnapper] pushRootBell:[[self nurseryRoot] bell]];
            }
            
            *aLatestGrade = aNewGrade;
        }
        else
        {
            aFarmOutStatus = NUFarmOutStatusNurseryGradeUnmatched;
        }
        
        [[self mainBranchNursery] unlockForFarmOut];
    }
    @finally
    {
        [self unlock];
        [[self gradeKidnapper] start];
        [farmOutLock unlock];
        
        return aFarmOutStatus;
    }
}

@end