//
//  NUBranchSandbox.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/23.
//
//

#import "NUSandbox.h"

@class NUBranchAliaser, NUBranchNursery;
@protocol NUMainBranchNurseryAssociation;

@interface NUBranchSandbox : NUSandbox
{
    NUU64ODictionary *storedChangedObjects;
    NUUInt64 nextProbationaryOOP;
}

- (NUBranchAliaser *)branchAliaser;
- (NUBranchNursery *)branchNursery;

- (NUUInt64)allocProbationaryOOP;

@end

@interface NUBranchSandbox (Private)

- (id <NUMainBranchNurseryAssociation>)mainBranchNurseryAssociation;

- (void)storeChangedObjects;
- (void)restoreChangedObjects;
- (void)setStoredChangedObjects:(NUU64ODictionary *)aChangedObjects;

- (void)replaceProbationaryOOPsWithFixedOOPs:(NSData *)aProbationaryOOPsFixedOOPs inPupils:(NUU64ODictionary *)aProbationaryPupils grade:(NUUInt64)aLatestGrade;

@end
