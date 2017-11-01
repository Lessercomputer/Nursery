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
    NSMutableDictionary *probationaryPupils;
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

- (NSMutableDictionary *)probationaryPupils;
- (void)replaceProbationaryOOPsWithFixedOOPs:(NSData *)aProbationaryOOPsFixedOOPs inPupils:(NSDictionary *)aProbationaryPupils grade:(NUUInt64)aLatestGrade;

@end
