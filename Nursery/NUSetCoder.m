//
//  NUSetCoder.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import "NUSetCoder.h"
#import "NUCharacter.h"
#import "NUSandbox.h"
#import "NUAliaser.h"

@implementation NUSetCoder

- (id)new
{
    return [NSMutableSet new];
}

- (void)encode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    [self encodeIndexedIvarsOf:anObject withAliaser:anAliaser];
}

- (void)encodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
	NSSet *aSet = anObject;
	NUUInt64 aCount = [aSet count];
	if (aCount)
	{
		id *anObjects = malloc(sizeof(id) * aCount);
        __block NUUInt64 i = 0;
        [aSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop){anObjects[i++] = obj;}];
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
	NSMutableSet *aSet = anObject;
	[aSet setSet:[self decodeObjectWithAliaser:anAliaser]];
}

- (id)decodeObjectWithAliaser:(NUAliaser *)anAliaser
{
	NUUInt64 aSize = [anAliaser indexedIvarsSize];
	NSSet *aSet = nil;
	
	if (aSize)
	{
		NUUInt64 aCount = aSize / sizeof(NUUInt64);
		id *anObjects = malloc(sizeof(id) * aCount);
		
		[anAliaser decodeIndexedIvar:anObjects count:aCount really:YES];
		
        aSet = [[NSSet alloc] initWithObjects:anObjects count:aCount];
        
		free(anObjects);
	}
	else
		aSet = [NSSet new];
    
	return [aSet autorelease];
}

- (BOOL)canMoveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    return [[anAliaser character] isMutable];
}

- (void)moveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    if (![[anAliaser character] isMutable]) return;
    
    NSMutableSet *aSet = anObject;
    [aSet setSet:[self decodeObjectWithAliaser:anAliaser]];
    [[anAliaser sandbox] unmarkChangedObject:aSet];
}
@end
