//
//  NULocationTreeLeaf.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/17.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSString.h>

#import "NULocationTreeLeaf.h"
#import "NUObjectTable.h"
#import "NUPages.h"
#import "NURegionArray.h"
#import "NURegion.h"
#import "NUIndexArray.h"


@implementation NULocationTreeLeaf

+ (NUUInt64)nodeOOP
{
	return NULocationTreeLeafNodeOOP;
}

- (NUOpaqueArray *)makeValueArray
{
	return [[[NUIndexArray alloc] initWithCapacity:[self valueCapacity] comparator:[[self tree] comparator]] autorelease];
}

- (NURegion)regionAt:(NUUInt32)anIndex
{
	return NUMakeRegion(*(NUUInt64 *)[self keyAt:anIndex], *(NUUInt64 *)[self valueAt:anIndex]);
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
