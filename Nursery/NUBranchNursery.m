//
//  NUBranchNursery.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUBranchNursery.h"
#import "NUBranchNursery+Project.h"
#import "NUGarden+Project.h"
#import "NUBranchGarden.h"
#import "NUPupilAlbum.h"
#import "NUNurseryNetClient.h"


@implementation NUBranchNursery

+ (instancetype)branchNurseryWithServiceName:(NSString *)aServiceName
{
    return [[[self alloc] initWithServiceName:aServiceName] autorelease];
}

- (instancetype)initWithServiceName:(NSString *)aServiceName
{
    if (self = [super init])
    {
        netClient = [[NUNurseryNetClient alloc] initWithServiceName:aServiceName];
        pupilAlbum = [NUPupilAlbum new];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc:%@", self);
    [netClient stop];
    [netClient release];
    netClient = nil;
    [pupilAlbum release];
    pupilAlbum = nil;
    
    [super dealloc];
}

@end

@implementation NUBranchNursery (Grade)

- (NUUInt64)latestGrade:(NUGarden *)sender
{
    return [[self netClient] latestGrade];
}

- (NUUInt64)olderRetainedGrade:(NUGarden *)sender
{
    return [[self netClient] olderRetainedGrade];
}

- (NUUInt64)retainLatestGradeByGarden:(NUGarden *)sender
{
    return [[self netClient] retainLatestGradeByGardenWithID:[sender ID]];
}

- (void)retainGrade:(NUUInt64)aGrade byGarden:(NUGarden *)sender
{
    [[self netClient] retainGrade:aGrade byGardenWithID:[sender ID]];
}

@end

@implementation NUBranchNursery (Testing)

- (BOOL)isMainBranch
{
    return NO;
}

@end

@implementation NUBranchNursery (Private)

- (NUNurseryNetClient *)netClient
{
    return netClient;
}

- (void)setNetClient:(NUNurseryNetClient *)aNetClient
{
    [netClient release];
    netClient = [aNetClient retain];
}

- (NUPupilAlbum *)pupilAlbum
{
    return pupilAlbum;
}

- (void)setPupilAlbum:(NUPupilAlbum *)aPupilAlbum
{
    [pupilAlbum autorelease];
    pupilAlbum = [aPupilAlbum retain];
}

@end
