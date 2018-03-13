//
//  NUBranchSandbox.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/23.
//
//

#import "NUSandbox.h"

@class NUBranchAliaser, NUBranchNursery, NUMainBranchNurseryAssociation;

@interface NUBranchSandbox : NUSandbox
{
    NUUInt64 nextProbationaryOOP;
}

- (NUBranchAliaser *)branchAliaser;
- (NUBranchNursery *)branchNursery;

- (NUUInt64)allocProbationaryOOP;

@end

@interface NUBranchSandbox (Private)

- (void)replaceProbationaryOOPsWithFixedOOPs:(NSData *)aProbationaryOOPsFixedOOPs inPupils:(NUU64ODictionary *)aProbationaryPupils grade:(NUUInt64)aLatestGrade;

@end
