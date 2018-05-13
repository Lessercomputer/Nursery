//
//  NUBranchNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Nursery/NUNursery.h>

@class NUPupilNoteCache, NUNurseryNetClient;

@interface NUBranchNursery : NUNursery
{
    NUPupilNoteCache *pupilNoteCache;
    NUNurseryNetClient *netClient;
}

+ (instancetype)branchNurseryWithServiceName:(NSString *)aServiceName;

- (instancetype)initWithServiceName:(NSString *)aServiceName;



@end

