//
//  NUBranchNurseryAssociation.h
//  Nursery
//
//  Created by P,T,A on 2013/06/29.
//
//

#import <Nursery/NUNurseryAssociation.h>
#import <Nursery/NUMainBranchNurseryAssociation.h>

@class NUBranchNursery, NUBranchPlayLot, NUBranchNurseryAssociationEntry;

@interface NUBranchNurseryAssociation : NUNurseryAssociation
{
    NSMutableDictionary *entries;
}

+ (id)association;

- (NUBranchNursery *)nurseryForURL:(NSURL *)aURL;

- (void)close;

@end

@interface NUBranchNurseryAssociation (Private)

- (NUBranchNurseryAssociationEntry *)entryForURL:(NSURL *)aURL;
- (NSNumber *)ensureBranchNurseryAssociationThreadID;
- (id <NUMainBranchNurseryAssociation>)mainBranchAssociationForPlayLot:(NUBranchPlayLot *)aPlayLot;

@end