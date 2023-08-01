//
//  NUAperture.m
//  Nursery
//
//  Created by Akifumi Takata on 11/08/29.
//

#import "NUAperture.h"
#import "NUMainBranchNursery.h"
#import "NUPages.h"
#import "NUCharacter.h"
#import "NUCharacter+Project.h"
#import "NUObjectTable.h"
#import "NUIvar.h"
#import "NUBellBall.h"


@implementation NUAperture

+ (id)apertureWithNursery:(NUNursery *)aNursery garden:(NUGarden *)aGarden
{
	return [[[self alloc] initWithNursery:aNursery garden:aGarden] autorelease];
}

- (id)initWithNursery:(NUNursery *)aNursery garden:(NUGarden *)aGarden
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
