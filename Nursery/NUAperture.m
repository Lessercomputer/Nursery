//
//  NUAperture.m
//  Nursery
//
//  Created by Akifumi Takata on 11/08/29.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUAperture.h"
#import "NUMainBranchNursery.h"
#import "NUPages.h"
#import "NUCharacter.h"
#import "NUObjectTable.h"
#import "NUIvar.h"
#import "NUBellBall.h"


@implementation NUAperture

+ (id)apertureWithNursery:(NUNursery *)aNursery sandbox:(NUSandbox *)aSandbox
{
	return [[[self alloc] initWithNursery:aNursery sandbox:aSandbox] autorelease];
}

- (id)initWithNursery:(NUNursery *)aNursery sandbox:(NUSandbox *)aSandbox
{
	self = [super init];
		
	return self;
}

- (void)peekAt:(NUBellBall)aBellBall
{
}

- (BOOL)hasNextFixedOOP
{
	return currentFixedOOPIvarIndex < [self fixedOOPCount];
}

- (NUUInt64)nextFixedOOP
{
	return NUNilOOP;
}

- (BOOL)hasNextIndexedOOP
{
	return currentIndexedOOPIndex < [self indexedOOPCount];
}

- (NUUInt64)nextIndexedOOP
{
	return NUNilOOP;
}

- (NUCharacter *)character
{
	return character;
}

- (NUUInt64)fixedOOPCount
{
	return [[self character] allOOPIvarsCount];
}

- (NUUInt64)indexedOOPCount
{
	return indexedOOPCount;
}

@end
