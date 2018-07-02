//
//  NUBranchNursery.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Foundation/NSString.h>

#import "NUNursery+Project.h"
#import "NUBranchNursery.h"
#import "NUBranchNursery+Project.h"
#import "NUGarden+Project.h"
#import "NUBranchGarden.h"
#import "NUPupilNoteCache.h"
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
        serviceName = [aServiceName copy];
        pupilNoteCache = [[NUPupilNoteCache alloc] initWithMaxCacheSizeInBytes:1024 * 1024 * 30 cacheablePupilNoteMaxSizeInBytes:1024 * 4];;
    }
    
    return self;
}

- (NSString *)serviceName
{
    return serviceName;
}

+ (Class)gardenClass
{
    return [NUBranchGarden class];
}

- (void)dealloc
{
    [serviceName release];
    serviceName = nil;
    
    [pupilNoteCache release];
    pupilNoteCache = nil;
    
    [super dealloc];
}

@end

@implementation NUBranchNursery (Grade)

- (NUUInt64)latestGrade:(NUGarden *)sender
{
    return [[(NUBranchGarden *)sender netClient] latestGrade];
}

- (NUUInt64)olderRetainedGrade:(NUGarden *)sender
{
    return [[(NUBranchGarden *)sender netClient] olderRetainedGrade];
}

- (NUUInt64)retainLatestGradeByGarden:(NUGarden *)sender
{
    return [[(NUBranchGarden *)sender netClient] retainLatestGradeByGardenWithID:[sender ID]];
}

- (void)retainGrade:(NUUInt64)aGrade byGarden:(NUGarden *)sender
{
    [[(NUBranchGarden *)sender netClient] retainGrade:aGrade byGardenWithID:[sender ID]];
}

@end

@implementation NUBranchNursery (Testing)

- (BOOL)isMainBranch
{
    return NO;
}

@end

@implementation NUBranchNursery (Private)

- (void)setServiceName:(NSString *)aServiceName
{
    [serviceName release];
    serviceName = [aServiceName copy];
}

- (NUPupilNoteCache *)pupilNoteCache
{
    return pupilNoteCache;
}

- (void)setPupilNoteCache:(NUPupilNoteCache *)aPupilNoteCache
{
    [pupilNoteCache autorelease];
    pupilNoteCache = [aPupilNoteCache retain];
}

@end
