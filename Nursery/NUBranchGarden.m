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
#import "NUBranchGardenSeeker.h"
#import "NUAliaser+Project.h"
#import "NUBranchAliaser.h"
#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUBellBall.h"
#import "NUNurseryRoot.h"
#import "NUBranchNursery.h"
#import "NUBranchNursery+Project.h"
#import "NUPupilNote.h"
#import "NUPupilNoteCache.h"
#import "NUU64ODictionary.h"
#import "NUNurseryNetClient.h"
#import "NUBranchAperture.h"

@implementation NUBranchGarden

- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGardenSeeker:(BOOL)aUsesGardenSeeker retainNursery:(BOOL)aRetainFlag
{
    if (self = [super initWithNursery:aNursery grade:aGrade usesGardenSeeker:aUsesGardenSeeker retainNursery:aRetainFlag])
    {
        nextProbationaryOOP = NUNotFound64 - 1;
    }
    
    return self;
}

- (void)close
{
    [[self gardenSeeker] stop];
    [[self netClient] closeGardenWithID:[self ID]];
    [[self netClient] stop];
    
    [super close];
}

- (void)dealloc
{
    [netClient release];
    netClient = nil;
    
    [super dealloc];
}

- (NUBranchAliaser *)branchAliaser
{
    return (NUBranchAliaser *)[self aliaser];
}

- (NUBranchNursery *)branchNursery
{
    return (NUBranchNursery *)[self nursery];
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

+ (Class)gardenSeekerClass
{
    return [NUBranchGardenSeeker class];
}

+ (Class)apertureClass
{
    return [NUBranchAperture class];
}

@end

@implementation NUBranchGarden (Bell)

- (BOOL)bellGradeIsUnmatched:(NUBell *)aBell
{
    NUPupilNote *aPupilNote = [[self branchAliaser] callForPupilNoteWithBell:aBell];
    
    return aPupilNote && [aPupilNote grade] != [aBell grade];
}

@end

@implementation NUBranchGarden (SaveAndLoad)

- (NUFarmOutStatus)farmOut
{
    NUFarmOutStatus aFarmOutStatus = NUFarmOutStatusFailed;
    
    @try {
        NSData *aFixedOOPs = nil;
        NUUInt64 aLatestGrade = NUNilGrade;
        
        [[self gardenSeeker] stop];
        
        if (![self gradeIsEqualToNurseryGrade])
        {
            aFarmOutStatus = NUFarmOutStatusNurseryGradeUnmatched;
        }
        else
        {
            if (![self contains:[self nurseryRoot]])
                [[self aliaser] setRoots:[NSMutableArray arrayWithObject:[self nurseryRoot]]];
            
            [[self aliaser] encodeObjects];
            NSData *anEncodedObjectsData = [[self branchAliaser] encodedPupilNotesData];
            aFarmOutStatus = [[self netClient] farmOutPupils:anEncodedObjectsData rootOOP:[[[self nurseryRoot] bell] OOP] gardenWithID:[self ID] fixedOOPs:&aFixedOOPs latestGrade:&aLatestGrade];
                        
            if (aFarmOutStatus == NUFarmOutStatusSucceeded)
            {
                [self replaceProbationaryOOPsWithFixedOOPs:aFixedOOPs inPupils:[[self branchAliaser] reducedEncodedPupilsDictionary] grade:aLatestGrade];
                [[self branchAliaser] removeAllEncodedPupils];
                [self setGrade:aLatestGrade];
                [[self gardenSeeker] pushRootBell:[[self nurseryRoot] bell]];
            }

        }
    }
    @finally {
        if (aFarmOutStatus == NUFarmOutStatusSucceeded)
            [[self gardenSeeker] start];
    }
    
    return aFarmOutStatus;
}

@end

@implementation NUBranchGarden (Private)

- (NUNurseryNetClient *)netClient
{
    return netClient;
}

- (void)setNetClient:(NUNurseryNetClient *)aNetClient
{
    [netClient release];
    netClient = [aNetClient retain];
}

- (NUNurseryRoot *)loadNurseryRoot
{
    if ([self ID] == NUNilGardenID)
    {
        netClient = [[NUNurseryNetClient alloc] initWithServiceName:[[self branchNursery] serviceName]];

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
