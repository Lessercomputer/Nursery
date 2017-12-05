//
//  NUPairedMainBranchSandbox.m
//  Nursery
//
//  Created by Akifumi Takata on 2014/03/15.
//
//

#import "NUPairedMainBranchSandbox.h"
#import "NUGradeSeeker.h"
#import "NUMainBranchAliaser.h"
#import "NUPairedMainBranchAliaser.h"
#import "NUObjectTable.h"
#import "NUMainBranchNursery.h"
#import "NUNurseryRoot.h"

@implementation NUPairedMainBranchSandbox

+ (id)sandboxWithNursery:(NUNursery *)aNursery usesGradeSeeker:(BOOL)aUsesGradeSeeker
{
    return [[[self alloc] initWithNursery:aNursery usesGradeSeeker:aUsesGradeSeeker] autorelease];
}

- (NUPairedMainBranchAliaser *)pairedMainBranchAliaser
{
    return (NUPairedMainBranchAliaser *)[self aliaser];
}

@end

@implementation NUPairedMainBranchSandbox (Pupil)

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
        [[self gradeSeeker] stop];
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
//            NSData *aCopiedPupilData = [NSData dataWithData:aPupilData];
//            aPupilData = [[aPupilData mutableCopy] autorelease];
//            NSLog(@"In NUPairedMainBranchSandbox farmOutPupils:, aPupilData length:%lu", [aPupilData length]);
//            void *anEncodedPupilBytes = malloc([aPupilData length]);
//            [aPupilData getBytes:anEncodedPupilBytes length:[aPupilData length]];
//            NSData *aCopiedPupilData = [[NSData alloc] initWithBytesNoCopy:anEncodedPupilBytes length:[aPupilData length] freeWhenDone:YES];
//            NSLog(@"In NUPairedMainBranchSandbox farmOutPupils:, aCopiedPupilData length:%lu", [aCopiedPupilData length]);
//            [aPupilData writeToFile:[@"~/Desktop/NUPairedMainBranchSandbox_encodedObjects" stringByExpandingTildeInPath] atomically:YES];
//            aPupils = [[self pairedMainBranchAliaser] pupilsFromData:aCopiedPupilData];
            aPupils = [[self pairedMainBranchAliaser] pupilsFromData:aPupilData];
            [[self pairedMainBranchAliaser] setPupils:aPupils];
//            [aCopiedPupilData release];
            
            if ([[self mainBranchNursery] rootOOP] == NUNilOOP)
                [self moveUpTo:aNewGrade];
            
            [[self pairedMainBranchAliaser] fixProbationaryOOPsInPupils];
//#ifdef DEBUG
//            NSLog(@"%@", [[self pairedMainBranchAliaser] descriptionForPupils]);
//#endif
            [[self pairedMainBranchAliaser] writeEncodedObjectsToPages];
            *aFixedOOPs = [[self pairedMainBranchAliaser] dataWithProbationaryOOPAndFixedOOP];
            
            aFixedRootOOP = [[self pairedMainBranchAliaser] fixedRootOOPForOOP:aRootOOP];
            
            if ([[self pairedMainBranchAliaser] rootOOP] != aFixedRootOOP)
                [[self mainBranchNursery] saveRootOOP:aFixedRootOOP];
            
            [[self pairedMainBranchAliaser] setPupils:nil];
            
            aFarmOutStatus = [[self mainBranchNursery] save] ? NUFarmOutStatusSucceeded : NUFarmOutStatusFailed;

            if (aFarmOutStatus == NUFarmOutStatusSucceeded)
            {
                [[self mainBranchNursery] retainGrade:aNewGrade bySandbox:self];
                [self setGrade:aNewGrade];
                [[self gradeSeeker] pushRootBell:[[self nurseryRoot] bell]];
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
        [[self gradeSeeker] start];
        [farmOutLock unlock];
        
        return aFarmOutStatus;
    }
}

@end
