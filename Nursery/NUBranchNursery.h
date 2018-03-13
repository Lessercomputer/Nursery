//
//  NUBranchNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Nursery/NUNursery.h>

@class NUBranchSandbox, NUPupilAlbum, NUNurseryNetClient;

@interface NUBranchNursery : NUNursery
{
    NUPupilAlbum *pupilAlbum;
}

+ (instancetype)branchNurseryWithServiceName:(NSString *)aServiceName;

- (instancetype)initWithServiceName:(NSString *)aServiceName;

@property (nonatomic, retain) NUNurseryNetClient *netClient;
- (NUPupilAlbum *)pupilAlbum;

@end

@interface NUBranchNursery (Private)

- (void)setPupilAlbum:(NUPupilAlbum *)aPupilAlbum;

@end
