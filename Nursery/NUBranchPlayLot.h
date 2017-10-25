//
//  NUBranchPlayLot.h
//  Nursery
//
//  Created by P,T,A on 2013/10/23.
//
//

#import <Nursery/Nursery.h>

@class NUBranchAliaser;

@interface NUBranchPlayLot : NUPlayLot
{
    NUU64ODictionary *storedChangedObjects;
    NUUInt64 nextProbationaryOOP;
    NSMutableDictionary *probationaryPupils;
}

- (NUBranchAliaser *)branchAliaser;
- (NUBranchNursery *)branchNursery;

- (NUUInt64)allocProbationaryOOP;

@end

@interface NUBranchPlayLot (Private)

- (id <NUMainBranchNurseryAssociation>)mainBranchNurseryAssociation;

- (void)storeChangedObjects;
- (void)restoreChangedObjects;
- (void)setStoredChangedObjects:(NUU64ODictionary *)aChangedObjects;

- (NSMutableDictionary *)probationaryPupils;
- (void)replaceProbationaryOOPsWithFixedOOPs:(NSData *)aProbationaryOOPsFixedOOPs inPupils:(NSDictionary *)aProbationaryPupils grade:(NUUInt64)aLatestGrade;

@end