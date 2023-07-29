//
//  NUObjectTableBranch.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/17.
//

#import "NUObjectTableBranch.h"
#import "NUObjectTable.h"
#import "NUBellBallArray.h"


@implementation NUObjectTableBranch

+ (NUUInt64)nodeOOP
{
	return NUObjectTableBranchNodeOOP;
}

- (NUOpaqueArray *)makeKeyArray
{
	return [[[NUBellBallArray alloc] initWithCapacity:[self keyCapacity] comparator:[[self tree] comparator]] autorelease];
}

#ifdef DEBUG

- (void)primitiveInsertValues:(NUUInt8 *)aValues at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
    NUUInt64 *aNodeLocations = (NUUInt64 *)aValues;
    
    for (NUUInt32 i = 0; i < aCount; i++)
        if (aNodeLocations[i] == 0)
            NSLog(@"aNodeLocation is 0");
    
	[super primitiveInsertValues:aValues at:anIndex count:aCount];
}

#endif

@end
