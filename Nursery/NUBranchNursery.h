//
//  NUBranchNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Nursery/NUNursery.h>

@class NUPupilAlbum, NUNurseryNetClient;

@interface NUBranchNursery : NUNursery
{
    NUPupilAlbum *pupilAlbum;
    NUNurseryNetClient *netClient;
}

+ (instancetype)branchNurseryWithServiceName:(NSString *)aServiceName;

- (instancetype)initWithServiceName:(NSString *)aServiceName;



@end

