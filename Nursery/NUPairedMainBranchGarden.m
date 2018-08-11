//
//  NUPairedMainBranchGarden.m
//  Nursery
//
//  Created by Akifumi Takata on 2014/03/15.
//
//

#import "NUGarden+Project.h"
#import "NUPairedMainBranchGarden.h"
#import "NUGardenSeeker.h"
#import "NUMainBranchAliaser.h"
#import "NUPairedMainBranchAliaser.h"
#import "NUObjectTable.h"
#import "NUNursery+Project.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUNurseryRoot.h"

@implementation NUPairedMainBranchGarden

- (NUPairedMainBranchAliaser *)pairedMainBranchAliaser
{
    return (NUPairedMainBranchAliaser *)[self aliaser];
}

+ (Class)aliaserClass
{
    return [NUPairedMainBranchAliaser class];
}

@end

@implementation NUPairedMainBranchGarden (Pupil)

- (NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade containsFellowPupils:(BOOL)aContainsFellowPupils maxFellowPupilNotesSizeInBytes:(NUUInt64)aMaxFellowPupilNotesSizeInBytes
{
    [self moveUpTo:aGrade];
    
    return [[self pairedMainBranchAliaser] callForPupilWithOOP:anOOP containsFellowPupils:aContainsFellowPupils maxFellowPupilNotesSizeInBytes:aMaxFellowPupilNotesSizeInBytes];
}

- (NUFarmOutStatus)farmOutPupils:(NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP fixedOOPs:(NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade
{
    if (![self gradeIsEqualToNurseryGrade])
        [self moveUpTo:[[self nursery] latestGrade:self]];
    
    NUFarmOutStatus aFarmOutStatus = NUFarmOutStatusFailed;
    
    *aFixedOOPs = nil;
    
    @try
    {
//        [farmOutLock lock];
        [[self gardenSeeker] stop];
        [self lock];
        
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
            @try
            {
                [[self mainBranchNursery] LockAndStopChildminders];
                
                if ([self gradeIsEqualToNurseryGrade])
                {
                    NUUInt64 aNewGrade = [[self mainBranchNursery] newGrade];
                    NSArray *aPupils = nil;
                    NUUInt64 aFixedRootOOP;

                    [[self pairedMainBranchAliaser] setGradeForSave:aNewGrade];

                    aPupils = [[self pairedMainBranchAliaser] pupilNotesFromData:aPupilData];
                    [[self pairedMainBranchAliaser] setPupils:aPupils];
                    
                    if ([[self mainBranchNursery] rootOOP] == NUNilOOP)
                        [self moveUpTo:aNewGrade];
                    
                    [[self pairedMainBranchAliaser] fixProbationaryOOPsInPupils];

                    [[self pairedMainBranchAliaser] writeEncodedObjectsToPages];
                    *aFixedOOPs = [[self pairedMainBranchAliaser] dataWithProbationaryOOPAndFixedOOP];
                    
                    aFixedRootOOP = [[self pairedMainBranchAliaser] fixedRootOOPForOOP:aRootOOP];
                    
                    if ([[self pairedMainBranchAliaser] rootOOP] != aFixedRootOOP)
                        [[self mainBranchNursery] saveRootOOP:aFixedRootOOP];
                    
                    [[self pairedMainBranchAliaser] setPupils:nil];
                    
                    aFarmOutStatus = [[self mainBranchNursery] save] ? NUFarmOutStatusSucceeded : NUFarmOutStatusFailed;

                    if (aFarmOutStatus == NUFarmOutStatusSucceeded)
                    {
                        [[self mainBranchNursery] retainGrade:aNewGrade byGarden:self];
                        [self setGrade:aNewGrade];
                    }
                    
                    *aLatestGrade = aNewGrade;
                }
                else
                {
                    aFarmOutStatus = NUFarmOutStatusNurseryGradeUnmatched;
                }
            }
            @finally
            {
                [[self mainBranchNursery] unlockAndStartChildminders];
            }
        }
    }
    @finally
    {
        [self unlock];
        
        if (aFarmOutStatus == NUFarmOutStatusSucceeded)
        {
            [[self gardenSeeker] endPreventationOfReleaseOfPastGrades];
            [[self gardenSeeker] pushRootBell:[[self nurseryRoot] bell]];
        }
        
        [[self gardenSeeker] start];
//        [farmOutLock unlock];
    }
    
    return aFarmOutStatus;
}

@end
