//
//  NULengthTreeLeaf.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/16.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSString.h>

#import "NULengthTreeLeaf.h"
#import "NUObjectTable.h"
#import "NURegionArray.h"
#import "NUPages.h"
#import "NURegion.h"


@implementation NULengthTreeLeaf

+ (NUUInt64)nodeOOP
{
	return NULengthTreeLeafNodeOOP;
}

- (void)computeKeyCapacityInto:(NUUInt32 *)aKeyCapacity valueCapacityInto:(NUUInt32 *)aValueCapacity
{
    NUUInt32 aCapacity = ([[[self tree] pages] pageSize]  - sizeof(NUUInt64) * 4) / [[self tree] keyLength];
    if (aKeyCapacity) *aKeyCapacity = aCapacity;
    if (aValueCapacity) *aValueCapacity = aCapacity;
}

- (NUOpaqueArray *)makeKeyArray
{
	return [[[NURegionArray alloc] initWithCapacity:[self keyCapacity] comparator:[tree comparator]] autorelease];
}

- (NURegion)regionAt:(NUUInt32)anIndex
{
	return [(NURegionArray *)[self keys] regionAt:anIndex];
}

- (NSString *)description
{
	NSMutableString *aString = [NSMutableString stringWithFormat:@"<%@:%p> (", 
									NSStringFromClass([self class]), self];
	NUUInt32 i = 0;
	for (; i < [self keyCount]; i++)
	{
		[aString appendString:NUStringFromRegion([self regionAt:i])];
		if (i != [self keyCount] - 1) [aString appendString:@", "];
	}
	
	[aString appendString:@")"];
	
	return aString;
}

@end
