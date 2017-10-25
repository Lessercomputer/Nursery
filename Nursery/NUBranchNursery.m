//
//  NUBranchNursery.m
//  Nursery
//
//  Created by P,T,A on 2013/06/29.
//
//

#import "NUBranchNursery.h"
#import "NUBranchPlayLot.h"
#import "NUBranchNurseryAssociation.h"
#import "NUPupilAlbum.h"

@implementation NUBranchNursery

- (id)initWithURL:(NSURL *)aURL association:(NUBranchNurseryAssociation *)anAssociation
{
    if (self = [super init])
    {
        url = [aURL copy];
        association = [anAssociation retain];
        playLot = [[NUPlayLot playLotWithNursery:self usesGradeKidnapper:YES] retain];
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

- (id <NUMainBranchNurseryAssociation>)mainBranchAssociationForPlayLot:(NUBranchPlayLot *)aPlayLot
{
    return [[self association] mainBranchAssociationForPlayLot:aPlayLot];
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

- (NUUInt64)latestGrade:(NUPlayLot *)sender
{
    return [[self mainBranchAssociationForPlayLot:(NUBranchPlayLot *)sender] latestGradeForNurseryWithName:[self name]];
}

- (NUUInt64)olderRetainedGrade:(NUPlayLot *)sender
{
    return [[self mainBranchAssociationForPlayLot:(NUBranchPlayLot *)sender] olderRetainedGradeForNurseryWithName:[self name]];
}

- (NUUInt64)retainLatestGradeByPlayLot:(NUPlayLot *)sender
{
    return [[self mainBranchAssociationForPlayLot:(NUBranchPlayLot *)sender] retainLatestGradeByPlayLotWithID:[sender ID] inNurseryWithName:[self name]];
}

- (void)retainGrade:(NUUInt64)aGrade byPlayLot:(NUPlayLot *)sender
{
    [[self mainBranchAssociationForPlayLot:(NUBranchPlayLot *)sender] retainGrade:aGrade byPlayLotWithID:[sender ID] inNurseryWithName:[self name]];
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