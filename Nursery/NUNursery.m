//
//  NUNursery.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUNursery.h"
#import "NUGarden.h"
#import "NUNurseryRoot.h"
#import "NURegion.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBellBall.h"

NSString * const NUOOPNotFoundException = @"NUOOPNotFoundException";

NUUInt64 NUNilGardenID = 0;
NUUInt64 NUFirstGardenID = 1000;

@implementation NUNursery

@end

@implementation NUNursery (InitializingAndRelease)

- (id)init
{
    if (self = [super init])
        openStatus = NUNurseryOpenStatusClose;
    
    return self;
}

- (instancetype)retain
{
    return [super retain];
}

- (void)dealloc
{
    [self close];
    
	[super dealloc];
}

@end

@implementation NUNursery (Accessing)

@end

@implementation NUNursery (Grade)

- (NUUInt64)latestGrade:(NUGarden *)sender
{
    return NUNilGrade;
}

- (NUUInt64)olderRetainedGrade:(NUGarden *)sender
{
    return NUNilGrade;
}

- (NUUInt64)retainLatestGradeByGarden:(NUGarden *)sender
{
    return [self retainLatestGradeByGardenWithID:[sender ID]];
}

- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade byGarden:(NUGarden *)sender
{
    NUUInt64 anOlderGrade = [self olderRetainedGrade:sender];
    NUUInt64 aLatestGrade = [self latestGrade:sender];
    
    if (anOlderGrade <= aGrade && aGrade <= aLatestGrade)
        return aGrade;
    else
        return NUNilGrade;
}

- (void)retainGrade:(NUUInt64)aGrade byGarden:(NUGarden *)sender
{
    [self retainGrade:aGrade byGardenWithID:[sender ID]];
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade byGarden:(NUGarden *)sender
{
    [self releaseGradeLessThan:aGrade byGardenWithID:[sender ID]];
}

- (NUUInt64)retainLatestGradeByGardenWithID:(NUUInt64)anID
{
    return NUNilGrade;
}

- (void)retainGrade:(NUUInt64)aGrade byGardenWithID:(NUUInt64)anID
{
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade byGardenWithID:(NUUInt64)anID
{
}

@end

@implementation NUNursery (Garden)

- (NUGarden *)makeGarden
{
    return [self makeGardenWithGrade:NUNilGrade];
}

- (NUGarden *)makeGardenWithGrade:(NUUInt64)aGrade
{
    NUGarden *aGarden = [NUGarden gardenWithNursery:self grade:aGrade usesGradeSeeker:YES];
    return aGarden;
}

@end

@implementation NUNursery (Testing)

- (BOOL)isMainBranch
{
    return YES;
}

@end

@implementation NUNursery (Private)

- (BOOL)open
{
    openStatus = NUNurseryOpenStatusOpenWithFile;
    return YES;
}

- (void)close
{
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
