//
//  NUNursery.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUNursery.h"
#import "NUSandbox.h"
#import "NUNurseryRoot.h"
#import "NURegion.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBellBall.h"

NSString * const NUOOPNotFoundException = @"NUOOPNotFoundException";

NUUInt64 NUNilSandboxID = 0;
NUUInt64 NUFirstSandboxID = 1000;

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
    [sandbox release];
    
	[super dealloc];
}

@end

@implementation NUNursery (Accessing)

- (NUSandbox *)sandbox
{
	return sandbox;
}

@end

@implementation NUNursery (Grade)

- (NUUInt64)latestGrade:(NUSandbox *)sender
{
    return NUNilGrade;
}

- (NUUInt64)olderRetainedGrade:(NUSandbox *)sender
{
    return NUNilGrade;
}

- (NUUInt64)retainLatestGradeBySandbox:(NUSandbox *)sender
{
    return [self retainLatestGradeBySandboxWithID:[sender ID]];
}

- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade bySandbox:(NUSandbox *)sender
{
    NUUInt64 anOlderGrade = [self olderRetainedGrade:sender];
    NUUInt64 aLatestGrade = [self latestGrade:sender];
    
    if (anOlderGrade <= aGrade && aGrade <= aLatestGrade)
        return aGrade;
    else
        return NUNilGrade;
}

- (void)retainGrade:(NUUInt64)aGrade bySandbox:(NUSandbox *)sender
{
    [self retainGrade:aGrade bySandboxWithID:[sender ID]];
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandbox:(NUSandbox *)sender
{
    [self releaseGradeLessThan:aGrade bySandboxWithID:[sender ID]];
}

- (NUUInt64)retainLatestGradeBySandboxWithID:(NUUInt64)anID
{
    return NUNilGrade;
}

- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID
{
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID
{
}

@end

@implementation NUNursery (Sandbox)

- (NUSandbox *)createSandbox
{
    return [self createSandboxWithGrade:NUNilGrade];
}

- (NUSandbox *)createSandboxWithGrade:(NUUInt64)aGrade
{
    NUSandbox *aSandbox = [NUSandbox sandboxWithNursery:self grade:aGrade usesGradeSeeker:YES];
    return aSandbox;
}

- (void)sandboxDidClose:(NUSandbox *)aSandbox
{
    if ([aSandbox isEqual:[self sandbox]]) [self close];
}

@end

@implementation NUNursery (Testing)

- (BOOL)isMainBranch
{
    return YES;
}

@end

@implementation NUNursery (Private)

- (void)setSandbox:(NUSandbox *)aSandbox
{
    [sandbox autorelease];
    sandbox = [aSandbox retain];
}

- (BOOL)open
{
    openStatus = NUNurseryOpenStatusOpenWithFile;
    return YES;
}

- (void)close
{
    NUSandbox *aSandbox = [self sandbox];
    sandbox = nil;
    [aSandbox close];
    [aSandbox release];
    
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
