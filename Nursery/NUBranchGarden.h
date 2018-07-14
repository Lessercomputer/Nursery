//
//  NUBranchGarden.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/23.
//
//

#import "NUGarden.h"

@class NUBranchAliaser, NUBranchNursery, NUMainBranchNurseryAssociation, NUNurseryNetClient;

@interface NUBranchGarden : NUGarden
{
    NUUInt64 nextProbationaryOOP;
    NUNurseryNetClient *netClient;
}

- (NUBranchAliaser *)branchAliaser;
- (NUBranchNursery *)branchNursery;

- (NUUInt64)allocProbationaryOOP;

@end

@interface NUBranchGarden (SaveAndLoad)

- (NUFarmOutStatus)farmOut;

@end

@interface NUBranchGarden (Private)

- (NUNurseryNetClient *)netClient;
- (void)setNetClient:(NUNurseryNetClient *)aNetClient;

- (void)replaceProbationaryOOPsWithFixedOOPs:(NSData *)aProbationaryOOPsFixedOOPs inPupils:(NUU64ODictionary *)aProbationaryPupils grade:(NUUInt64)aLatestGrade;

@end
