//
//  NUBranchGarden.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/23.
//
//

#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSByteOrder.h>

#import "NUGarden+Project.h"
#import "NUBranchGarden.h"
#import "NUBranchGradeSeeker.h"
#import "NUAliaser+Project.h"
#import "NUBranchAliaser.h"
#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUBellBall.h"
#import "NUNurseryRoot.h"
#import "NUBranchNursery.h"
#import "NUBranchNursery+Project.h"
#import "NUPupilNoteCache.h"
#import "NUU64ODictionary.h"
#import "NUNurseryNetClient.h"
#import "NUBranchAperture.h"

@implementation NUBranchGarden

- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag
{
    if (self = [super initWithNursery:aNursery grade:aGrade usesGradeSeeker:aUsesGradeSeeker retainNursery:aRetainFlag])
    {
        nextProbationaryOOP = NUNotFound64 - 1;
    }
    
    return self;
}

- (void)close
{
    [[self gradeSeeker] stop];
    [[self netClient] closeGardenWithID:[self ID]];
    
    [super close];
}

- (NUBranchAliaser *)branchAliaser
{
    return (NUBranchAliaser *)[self aliaser];
}

- (NUBranchNursery *)branchNursery
{
    return (NUBranchNursery *)[self nursery];
}

- (NUNurseryNetClient *)netClient
{
    return [[self branchNursery] netClient];
}

- (NUUInt64)allocProbationaryOOP
{
    @try {
        [lock lock];

        return nextProbationaryOOP--;
    }
    @finally {
        [lock unlock];
    }
}

+ (Class)aliaserClass
{
    return [NUBranchAliaser class];
}

+ (Class)gradeSeekerClass
{
    return [NUBranchGradeSeeker class];
}

+ (Class)apertureClass
{
    return [NUBranchAperture class];
}

@end

@implementation NUBranchGarden (SaveAndLoad)

- (NUFarmOutStatus)farmOut
{
    NUFarmOutStatus aFarmOutStatus = NUFarmOutStatusFailed;
    
    @try {
        NSData *aFixedOOPs = nil;
        NUUInt64 aLatestGrade = NUNilGrade;
        
        [[self gradeSeeker] stop];
        
        if (![self gradeIsEqualToNurseryGrade])
        {
            aFarmOutStatus = NUFarmOutStatusNurseryGradeUnmatched;
        }
        else
        {
            if (![self contains:[self nurseryRoot]])
                [[self aliaser] setRoots:[NSMutableArray arrayWithObject:[self nurseryRoot]]];
            
            [[self aliaser] encodeObjects];
            NSData *anEncodedObjectsData = [[self branchAliaser] encodedPupilData];
            aFarmOutStatus = [[[self branchNursery] netClient] farmOutPupils:anEncodedObjectsData rootOOP:[[[self nurseryRoot] bell] OOP] gardenWithID:[self ID] fixedOOPs:&aFixedOOPs latestGrade:&aLatestGrade];
                        
            if (aFarmOutStatus == NUFarmOutStatusSucceeded)
            {
                [self replaceProbationaryOOPsWithFixedOOPs:aFixedOOPs inPupils:[[self branchAliaser] reducedEncodedPupilsDictionary] grade:aLatestGrade];
                [[self branchAliaser] removeAllEncodedPupils];
                [self setGrade:aLatestGrade];
                [[self gradeSeeker] pushRootBell:[[self nurseryRoot] bell]];
            }

        }
    }
    @finally {
        [[self gradeSeeker] start];
    }
    
    return aFarmOutStatus;
}

@end

@implementation NUBranchGarden (Private)

- (NUNurseryRoot *)loadNurseryRoot
{
    if ([self ID] == NUNilGardenID)
    {
        [[self netClient] start];
        [self setID:[[self netClient] openGarden]];
    }
        
    return [super loadNurseryRoot];
}

- (void)replaceProbationaryOOPsWithFixedOOPs:(NSData *)aProbationaryOOPsFixedOOPs inPupils:(NUU64ODictionary *)aProbationaryPupils grade:(NUUInt64)aLatestGrade
{
    NUUInt64 *anOOPs = (NUUInt64 *)[aProbationaryOOPsFixedOOPs bytes];
    NUUInt64 aCount = [aProbationaryOOPsFixedOOPs length] / (sizeof(NUUInt64) * 2);
    
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        NUUInt64 aProbationaryOOP = NSSwapBigLongLongToHost(anOOPs[i * 2]);
        NUUInt64 aFixedOOP = NSSwapBigLongLongToHost(anOOPs[i * 2 + 1]);
        
        [[aProbationaryPupils objectForKey:aProbationaryOOP] setOOP:aFixedOOP];
    }
    
    [aProbationaryPupils enumerateKeysAndObjectsUsingBlock:^(NUUInt64 anOOP, NUPupilNote *aPupilNote, BOOL *stop) {
        [[self branchAliaser] fixProbationaryOOPsInPupil:aPupilNote];
    }];
    
    [aProbationaryPupils enumerateKeysAndObjectsUsingBlock:^(NUUInt64 anOOP, NUPupilNote *aPupilNote, BOOL *stop) {
        @try {
            [self lock];
            
            NUBell *aBell = [[self bellForOOP:anOOP] retain];
            [[self bells] removeObjectForKey:anOOP];
            [aBell setOOP:[aPupilNote OOP]];
            [aBell setGrade:aLatestGrade];
            [aBell setGradeAtCallFor:aLatestGrade];
            [[self bells] setObject:aBell forKey:[aBell OOP]];
            [aBell release];
        }
        @finally {
            [self unlock];
        }
        
        [aPupilNote setGrade:aLatestGrade];
        [[[self branchAliaser] pupilNoteCache] addPupilNote:aPupilNote grade:aLatestGrade];
    }];
}

@end
