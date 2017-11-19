//
//  NUArrayCoder.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/16.
//
//

#import "NUArrayCoder.h"
#import "NUCharacter.h"
#import "NUSandbox.h"

@implementation NUArrayCoder

- (id)new
{
	return [NSMutableArray new];
}

- (void)encode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    [self encodeIndexedIvarsOf:anObject withAliaser:anAliaser];
}

- (void)encodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
	NSArray *anArray = anObject;
	NUUInt64 aCount = [anArray count];
	if (aCount)
	{
		id *anObjects = malloc(sizeof(id) * aCount);
		[anArray getObjects:anObjects];
		[anAliaser encodeIndexedIvars:anObjects count:aCount];
		free(anObjects);
	}
}

- (void)decode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    [self decodeIndexedIvarsOf:anObject withAliaser:anAliaser];
}

- (void)decodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
	NSMutableArray *anArray = anObject;
	[anArray setArray:[self decodeObjectWithAliaser:anAliaser]];
}

- (id)decodeObjectWithAliaser:(NUAliaser *)anAliaser
{
	NUUInt64 aSize = [anAliaser indexedIvarsSize];
	NSArray *anArray = nil;
	
	if (aSize)
	{
		NUUInt64 aCount = aSize / sizeof(NUUInt64);
		id *anObjects = malloc(sizeof(id) * aCount);
		
		[anAliaser decodeIndexedIvar:anObjects count:aCount really:YES];
		
		anArray = [[NSArray alloc] initWithObjects:anObjects count:aCount];
        
		free(anObjects);
	}
	else
		anArray = [NSArray new];
    
	return [anArray autorelease];
}

- (BOOL)canMoveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    return [[anAliaser character] isMutable];
}

- (void)moveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    if (![[anAliaser character] isMutable]) return;
    
    NSMutableArray *anArray = anObject;
    [anArray setArray:[self decodeObjectWithAliaser:anAliaser]];
    [[anAliaser sandbox] unmarkChangedObject:anArray];
}

@end
