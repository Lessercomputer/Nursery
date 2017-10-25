//
//  NUPeephole.m
//  Nursery
//
//  Created by P,T,A on 11/08/29.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUPeephole.h"
#import "NUMainBranchNursery.h"
#import "NUPages.h"
#import "NUCharacter.h"
#import "NUObjectTable.h"
#import "NUIvar.h"
#import "NUBellBall.h"


@implementation NUPeephole

+ (id)peepholeWithNursery:(NUNursery *)aNursery playLot:(NUPlayLot *)aPlayLot
{
	return [[[self alloc] initWithNursery:aNursery playLot:aPlayLot] autorelease];
}

- (id)initWithNursery:(NUNursery *)aNursery playLot:(NUPlayLot *)aPlayLot
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
