//
//  NUIvar.m
//  Nursery
//
//  Created by Akifumi Takata on 11/02/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSException.h>

#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUCharacter.h"
#import "NUBell.h"
#import "NUGarden.h"
#import "NUGardenSeeker.h"

const NUIvarType NUOOPIvarType			= 0;
const NUIvarType NUUInt8IvarType		= 2;
const NUIvarType NUInt8IvarType			= 4;
const NUIvarType NUUInt16IvarType		= 6;
const NUIvarType NUInt16IvarType		= 8;
const NUIvarType NUUInt32IvarType		= 10;
const NUIvarType NUInt32IvarType		= 12;
const NUIvarType NUUInt64IvarType		= 14;
const NUIvarType NUInt64IvarType		= 16;
const NUIvarType NUFloatIvarType		= 18;
const NUIvarType NUDoubleIvarType		= 20;
const NUIvarType NUBOOLIvarType			= 22;
const NUIvarType NURegionIvarType       = 24;
const NUIvarType NUNSRangeIvarType      = 26;
const NUIvarType NUNSPointIvarType      = 28;
const NUIvarType NUNSSizeIvarType       = 30;
const NUIvarType NUNSRectIvarType       = 32;

id NUGetIvar(id __strong *anIvar)
{
    if ([(NSObject *)*anIvar isBell]) NUSetIvar(anIvar, [*anIvar object]);
    return *anIvar;
}

id NUSetIvar(id __strong *anIvar, id anObject)
{
    [anObject retain];
    [*anIvar release];
    *anIvar = anObject;
    return *anIvar;
}

NSString *NUIvarInvalidTypeException = @"NUIvarInvalidTypeException";

@implementation NUIvar

+ (id)ivarWithName:(NSString *)aName type:(NUIvarType)aType
{
	return [[[self alloc] initWithName:aName type:aType] autorelease];
}

+ (id)ivarWithName:(NSString *)aName type:(NUIvarType)aType size:(NUUInt64)aSize
{
	return [[[self alloc] initWithName:aName type:aType size:aSize] autorelease];
}

- (id)initWithName:(NSString *)aName type:(NUIvarType)aType
{
	return [self initWithName:aName type:aType size:1];
}

- (id)initWithName:(NSString *)aName type:(NUIvarType)aType size:(NUUInt64)aSize
{
	if (self = [super init])
    {
        [self setName:aName];
        [self setType:aType];
        [self setSize:aSize];
    }
    
	return self;
}

- (void)dealloc
{
	[self setName:nil];
	
	[super dealloc];
}

- (NSString *)name
{
	return name;
}

- (void)setName:(NSString *)aName
{
    NUSetIvar(&name, aName);
}

- (NUIvarType)type
{
	return type;
}

- (void)setType:(NUIvarType)aType
{
	type = aType;
}

- (NUUInt64)size
{
	return size;
}

- (void)setSize:(NUUInt64)aSize
{
	size = aSize;
}

- (NUUInt64)sizeInBytes
{
	NUIvarType aType = [self type];
	NUUInt64 aTypeSize = 0;
	
	if (NUOOPIvarType == aType || NUUInt64IvarType == aType) aTypeSize = sizeof(NUUInt64);
	else if (NUUInt8IvarType == aType) aTypeSize = sizeof(NUUInt8);
    else if (NUInt8IvarType == aType) aTypeSize = sizeof(NUInt8);
	else if (NUUInt16IvarType == aType) aTypeSize = sizeof(NUUInt16);
    else if (NUInt16IvarType == aType) aTypeSize = sizeof(NUInt16);
	else if (NUUInt32IvarType == aType) aTypeSize = sizeof(NUUInt32);
    else if (NUInt32IvarType == aType) aTypeSize = sizeof(NUInt32);
    else if (NUInt64IvarType == aType) aTypeSize = sizeof(NUInt64);
    else if (NUFloatIvarType == aType) aTypeSize = sizeof(NUFloat);
	else if (NUDoubleIvarType == aType) aTypeSize = sizeof(NUDouble);
    else if (NUBOOLIvarType == aType) aTypeSize = sizeof(NUUInt8);
    else if (NURegionIvarType == aType) aTypeSize = sizeof(NUUInt64) * 2;
    else if (NUNSRangeIvarType == aType) aTypeSize = sizeof(NUUInt64) * 2;
    else if (NUNSPointIvarType == aType) aTypeSize = sizeof(NUDouble) * 2;
    else if (NUNSSizeIvarType == aType) aTypeSize = sizeof(NUDouble) * 2;
    else if (NUNSRectIvarType == aType) aTypeSize = sizeof(NUDouble) * 4;
    else [[NSException exceptionWithName:NUIvarInvalidTypeException reason:NUIvarInvalidTypeException userInfo:nil] raise];

	return aTypeSize * [self size];
}

- (NUUInt64)offset
{
	return offset;
}

- (void)setOffset:(NUUInt64)anOffset
{
	offset = anOffset;
}

- (NUBell *)bell
{
	return bell;
}

- (void)setBell:(NUBell *)aBell
{
	bell = aBell;
}

- (BOOL)isEqual:(id)object
{
	if ([super isEqual:object]) return YES;

	if ([object isKindOfClass:[NUIvar class]])
		return [self isEqualToIvar:object];
		
	return NO;
}

- (BOOL)isEqualToIvar:(NUIvar *)anIvar
{
	if (![[self name] isEqualToString:[anIvar name]]) return NO;
	if ([self type] != [anIvar type]) return NO;
	if ([self size] != [anIvar size]) return NO;
	
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    if ([self isEqual:[NUIvar class]])
    {
        [aCharacter addOOPIvarWithName:@"name"];
        [aCharacter addUInt8IvarWithName:@"type"];
        [aCharacter addUInt64IvarWithName:@"size"];
    }
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
	[anAliaser encodeObject:name];
	[anAliaser encodeUInt8:type];
	[anAliaser encodeUInt64:size];

}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
	[self setName:[anAliaser decodeObjectReally]];
	[self setType:[anAliaser decodeUInt8]];
	[self setSize:[anAliaser decodeUInt64]];
	
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@(%@): %p>", [self class], [self name], self];
}

- (id)copyWithZone:(NSZone *)zone
{
	NUIvar *anIvar = [[NUIvar allocWithZone:zone] initWithName:[self name] type:[self type] size:[self size]];
	return anIvar;
}

@end
