//
//  NUBranchSandbox.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/23.
//
//

#import "NUBranchSandbox.h"
#import "NUGradeSeeker.h"
#import "NUBranchAliaser.h"
#import "NUMainBranchNurseryAssociationProtocol.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUNurseryRoot.h"
#import "NUBranchNursery.h"
#import "NUPupilAlbum.h"

@implementation NUBranchSandbox

- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker
{
    if (self = [super initWithNursery:aNursery grade:aGrade usesGradeSeeker:aUsesGradeSeeker])
    {
        nextProbationaryOOP = NUNotFound64 - 1;
        probationaryPupils = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [probationaryPupils release];
    
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

@end

@implementation NUBranchSandbox (SaveAndLoad)

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
            //[self storeChangedObjects];
            
            if (![self contains:[self nurseryRoot]])
                [[self aliaser] setRoots:[NSMutableArray arrayWithObject:[self nurseryRoot]]];
            
            [[self aliaser] encodeObjects];
            aFarmOutStatus = [[self mainBranchNurseryAssociation] farmOutPupils:[[self branchAliaser] encodedPupilData] rootOOP:[[[self nurseryRoot] bell] OOP] sandboxWithID:[self ID] inNurseryWithName:[[self branchNursery] name] fixedOOPs:&aFixedOOPs latestGrade:&aLatestGrade];
            
            if (aFarmOutStatus == NUFarmOutStatusSucceeded)
            {
                [self replaceProbationaryOOPsWithFixedOOPs:aFixedOOPs inPupils:[self probationaryPupils] grade:aLatestGrade];
                [[self probationaryPupils] removeAllObjects];
                [self setGrade:aLatestGrade];
                [[self gradeSeeker] pushRootBell:[[self nurseryRoot] bell]];
            }
            /*else
                [self restoreChangedObjects];*/
        }
    }
    @finally {
        //[self setStoredChangedObjects:nil];
        //[[self probationaryPupils] removeAllObjects];
        [[self gradeSeeker] start];
    }
    
    return aFarmOutStatus;
}

@end

@implementation NUBranchSandbox (Private)

- (id <NUMainBranchNurseryAssociation>)mainBranchNurseryAssociation
{
    id <NUMainBranchNurseryAssociation> aMainBranchNurseryAssociation = [[(NUBranchNursery *)[self nursery] association] mainBranchAssociationForSandbox:self];
    return aMainBranchNurseryAssociation;
}

- (NSMutableDictionary *)probationaryPupils
{
    return probationaryPupils;
}

- (NUNurseryRoot *)loadNurseryRoot
{
    [self mainBranchNurseryAssociation];
        
    return [super loadNurseryRoot];
}

- (void)storeChangedObjects
{
    [self setStoredChangedObjects:[[[self changedObjects] copy] autorelease]];
}

- (void)restoreChangedObjects
{
    [self setChangedObjects:storedChangedObjects];
}

- (void)setStoredChangedObjects:(NUU64ODictionary *)aChangedObjects
{
    [storedChangedObjects release];
    storedChangedObjects = [aChangedObjects retain];
}

- (void)replaceProbationaryOOPsWithFixedOOPs:(NSData *)aProbationaryOOPsFixedOOPs inPupils:(NSDictionary *)aProbationaryPupils grade:(NUUInt64)aLatestGrade
{
    NUUInt64 *anOOPs = (NUUInt64 *)[aProbationaryOOPsFixedOOPs bytes];
    NUUInt64 aCount = [aProbationaryOOPsFixedOOPs length] / (sizeof(NUUInt64) * 2);
    
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        NUUInt64 aProbationaryOOP = NSSwapBigLongLongToHost(anOOPs[i * 2]);
        NUUInt64 aFixedOOP = NSSwapBigLongLongToHost(anOOPs[i * 2 + 1]);
        NUBell *aBell = [self bellForOOP:aProbationaryOOP];
        
        [[aProbationaryPupils objectForKey:aBell] setOOP:aFixedOOP];
    }
    
    [aProbationaryPupils enumerateKeysAndObjectsUsingBlock:^(NUBell *aBell, NUPupilNote *aPupilNote, BOOL *stop) {
        [[self branchAliaser] fixProbationaryOOPsInPupil:aPupilNote];
    }];
    
    [aProbationaryPupils enumerateKeysAndObjectsUsingBlock:^(NUBell *aBell, NUPupilNote *aPupilNote, BOOL *stop) {
        
        @try {
            [self lock];
            
            [[self bellSet] removeObject:aBell];
            [aBell setOOP:[aPupilNote OOP]];
            [aBell setGrade:aLatestGrade];
            [aBell setGradeAtCallFor:aLatestGrade];
            [[self bellSet] addObject:aBell];
        }
        @finally {
            [self unlock];
        }

        [aPupilNote setGrade:aLatestGrade];
        [[[self branchAliaser] pupilAlbum] addPupilNote:aPupilNote grade:aLatestGrade];
    }];
}

@end
