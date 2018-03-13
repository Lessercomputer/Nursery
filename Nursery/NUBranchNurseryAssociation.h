//
//  NUBranchNurseryAssociation.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Nursery/NUNurseryAssociation.h>
#import <Nursery/NUMainBranchNurseryAssociation.h>

@class NUBranchNursery, NUBranchSandbox, NUBranchNurseryAssociationEntry;
@protocol NUMainBranchNurseryAssociation;

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
- (NUMainBranchNurseryAssociation *)mainBranchAssociationForSandbox:(NUBranchSandbox *)aSandbox;

@end
