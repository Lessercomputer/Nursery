//
//  NUBranchNursery.m
//  Nursery
//
//  Created by P,T,A on 2013/06/29.
//
//

#import "NUBranchNursery.h"
#import "NUBranchSandbox.h"
#import "NUBranchNurseryAssociation.h"
#import "NUPupilAlbum.h"

@implementation NUBranchNursery

- (id)initWithURL:(NSURL *)aURL association:(NUBranchNurseryAssociation *)anAssociation
{
    if (self = [super init])
    {
        url = [aURL copy];
        association = [anAssociation retain];
        sandbox = [[NUSandbox sandboxWithNursery:self usesGradeSeeker:YES] retain];
        pupilAlbum = [NUPupilAlbum new];
    }
    
    return self;
}

- (NSURL *)URL
{
    return url;
}

- (NSString *)name
{
    return [[self association] nurseryNameFromURL:[self URL]];
}

- (NUBranchNurseryAssociation *)association
{
    return association;
}

- (id <NUMainBranchNurseryAssociation>)mainBranchAssociationForSandbox:(NUBranchSandbox *)aSandbox
{
    return [[self association] mainBranchAssociationForSandbox:aSandbox];
}

- (NUPupilAlbum *)pupilAlbum
{
    return pupilAlbum;
}

- (void)dealloc
{
    [url release];
    [association release];
    [pupilAlbum release];
    
    [super dealloc];
}

@end

@implementation NUBranchNursery (Grade)

- (NUUInt64)latestGrade:(NUSandbox *)sender
{
    return [[self mainBranchAssociationForSandbox:(NUBranchSandbox *)sender] latestGradeForNurseryWithName:[self name]];
}

- (NUUInt64)olderRetainedGrade:(NUSandbox *)sender
{
    return [[self mainBranchAssociationForSandbox:(NUBranchSandbox *)sender] olderRetainedGradeForNurseryWithName:[self name]];
}

- (NUUInt64)retainLatestGradeBySandbox:(NUSandbox *)sender
{
    return [[self mainBranchAssociationForSandbox:(NUBranchSandbox *)sender] retainLatestGradeBySandboxWithID:[sender ID] inNurseryWithName:[self name]];
}

- (void)retainGrade:(NUUInt64)aGrade bySandbox:(NUSandbox *)sender
{
    [[self mainBranchAssociationForSandbox:(NUBranchSandbox *)sender] retainGrade:aGrade bySandboxWithID:[sender ID] inNurseryWithName:[self name]];
}

@end

@implementation NUBranchNursery (Testing)

- (BOOL)isMainBranch
{
    return NO;
}

@end

@implementation NUBranchNursery (Private)

- (void)setURL:(NSURL *)aURL
{
    [url autorelease];
    url = [aURL copy];
}

- (void)setAssociation:(NUBranchNurseryAssociation *)anAssociation
{
    [association autorelease];
    association = [anAssociation retain];
}

- (void)setPupilAlbum:(NUPupilAlbum *)aPupilAlbum
{
    [pupilAlbum autorelease];
    pupilAlbum = [aPupilAlbum retain];
}

@end
