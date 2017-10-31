//
//  NUBranchNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Nursery/NUNursery.h>
#import <Nursery/NUMainBranchNurseryAssociation.h>

@class NUBranchNurseryAssociation, NUBranchSandbox, NUPupilAlbum;

@interface NUBranchNursery : NUNursery
{
    NSURL *url;
    NUBranchNurseryAssociation *association;
    NUPupilAlbum *pupilAlbum;
}

- (id)initWithURL:(NSURL *)aURL association:(NUBranchNurseryAssociation *)anAssociation;

- (NSURL *)URL;

- (NSString *)name;

- (NUBranchNurseryAssociation *)association;

- (id <NUMainBranchNurseryAssociation>)mainBranchAssociationForSandbox:(NUBranchSandbox *)aSandbox;

- (NUPupilAlbum *)pupilAlbum;

@end

@interface NUBranchNursery (Private)

- (void)setURL:(NSURL *)aURL;
- (void)setAssociation:(NUBranchNurseryAssociation *)anAssociation;
- (void)setPupilAlbum:(NUPupilAlbum *)aPupilAlbum;

@end
