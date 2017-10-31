//
//  NUReversedObjectTableLeaf.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/12.
//
//

#import "NUReversedObjectTableLeaf.h"
#import "NUObjectTable.h"
#import "NUIndexArray.h"
#import "NUBellBallArray.h"

@implementation NUReversedObjectTableLeaf

+ (NUUInt64)nodeOOP
{
	return NUReversedObjectTableLeafNodeOOP;
}

- (NUOpaqueArray *)makeValueArray
{
	return [[[NUBellBallArray alloc] initWithCapacity:[self valueCapacity] comparator:[[self tree] comparator]] autorelease];
}

@end
