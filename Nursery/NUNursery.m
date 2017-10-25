//
//  NUNursery.m
//  Nursery
//
//  Created by P,T,A on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUNursery.h"
#import "NUPlayLot.h"
#import "NUNurseryRoot.h"
#import "NURegion.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBellBall.h"

NSString * const NUOOPNotFoundException = @"NUOOPNotFoundException";

NUUInt64 NUNilPlayLotID = 0;
NUUInt64 NUFirstPlayLotID = 1000;

@implementation NUNursery

@end

@implementation NUNursery (InitializingAndRelease)

- (id)init
{
    if (self = [super init])
        openStatus = NUNurseryOpenStatusClose;
    
    return self;
}

- (void)dealloc
{
    [playLot release];
    
	[super dealloc];
}

@end

@implementation NUNursery (Accessing)

- (NUPlayLot *)playLot
{
	return playLot;
}

@end

@implementation NUNursery (Grade)

- (NUUInt64)latestGrade:(NUPlayLot *)sender
{
    return NUNilGrade;
}

- (NUUInt64)olderRetainedGrade:(NUPlayLot *)sender
{
    return NUNilGrade;
}

- (NUUInt64)retainLatestGradeByPlayLot:(NUPlayLot *)sender
{
    return [self retainLatestGradeByPlayLotWithID:[sender ID]];
}

- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade byPlayLot:(NUPlayLot *)sender
{
    NUUInt64 anOlderGrade = [self olderRetainedGrade:sender];
    NUUInt64 aLatestGrade = [self latestGrade:sender];
    
    if (anOlderGrade <= aGrade && aGrade <= aLatestGrade)
        return aGrade;
    else
        return NUNilGrade;
}

- (void)retainGrade:(NUUInt64)aGrade byPlayLot:(NUPlayLot *)sender
{
    [self retainGrade:aGrade byPlayLotWithID:[sender ID]];
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade byPlayLot:(NUPlayLot *)sender
{
    [self releaseGradeLessThan:aGrade byPlayLotWithID:[sender ID]];
}

- (NUUInt64)retainLatestGradeByPlayLotWithID:(NUUInt64)anID
{
    return NUNilGrade;
}

- (void)retainGrade:(NUUInt64)aGrade byPlayLotWithID:(NUUInt64)anID
{
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade byPlayLotWithID:(NUUInt64)anID
{
}

@end

@implementation NUNursery (PlayLot)

- (NUPlayLot *)createPlayLot
{
    return [self createPlayLotWithGrade:NUNilGrade];
}

- (NUPlayLot *)createPlayLotWithGrade:(NUUInt64)aGrade
{
    NUPlayLot *aPlayLot = [NUPlayLot playLotWithNursery:self grade:aGrade usesGradeKidnapper:YES];
    return aPlayLot;
}

- (void)playLotDidClose:(NUPlayLot *)aPlayLot
{
    if ([aPlayLot isEqual:[self playLot]]) [self close];
}

@end

@implementation NUNursery (Testing)

- (BOOL)isMainBranch
{
    return YES;
}

@end

@implementation NUNursery (Private)

- (void)setPlayLot:(NUPlayLot *)aPlayLot
{
    [playLot autorelease];
    playLot = [aPlayLot retain];
}

- (BOOL)open
{
    openStatus = NUNurseryOpenStatusOpenWithFile;
    return YES;
}

- (void)close
{
    NUPlayLot *aPlayLot = [self playLot];
    playLot = nil;
    [aPlayLot close];
    [aPlayLot release];
    
    openStatus = NUNurseryOpenStatusClose;
}


- (NUNurseryOpenStatus)openStatus
{
    return openStatus;
}

- (void)setOpenStatus:(NUNurseryOpenStatus)aStatus
{
    openStatus = aStatus;
}

@end
