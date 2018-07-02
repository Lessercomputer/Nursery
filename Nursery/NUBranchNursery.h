//
//  NUBranchNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Nursery/NUNursery.h>

@class NUPupilNoteCache;

@interface NUBranchNursery : NUNursery
{
    NSString *serviceName;
    NUPupilNoteCache *pupilNoteCache;
}

+ (instancetype)branchNurseryWithServiceName:(NSString *)aServiceName;

- (instancetype)initWithServiceName:(NSString *)aServiceName;

- (NSString *)serviceName;

@end

