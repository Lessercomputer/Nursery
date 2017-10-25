//
//  NUIvar.m
//  Nursery
//
//  Created by P,T,A on 11/02/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUCharacter.h"
#import "NUBell.h"
#import "NUPlayLot.h"
#import "NUGradeKidnapper.h"

const NUIvarType NUOOPType			= 0;
const NUIvarType NUOOPArrayType		= 1;
const NUIvarType NUUInt8Type		= 2;
const NUIvarType NUUInt8ArrayType	= 3;
const NUIvarType NUInt8Type			= 4;
const NUIvarType NUInt8ArrayType	= 5;
const NUIvarType NUUInt16Type		= 6;
const NUIvarType NUUInt16ArrayType	= 7;
const NUIvarType NUInt16Type		= 8;
const NUIvarType NUInt16ArrayType	= 9;
const NUIvarType NUUInt32Type		= 10;
const NUIvarType NUUInt32ArrayType	= 11;
const NUIvarType NUInt32Type		= 12;
const NUIvarType NUInt32ArrayType	= 13;
const NUIvarType NUUInt64Type		= 14;
const NUIvarType NUUInt64ArrayType	= 15;
const NUIvarType NUInt64Type		= 16;
const NUIvarType NUInt64ArrayType	= 17;
const NUIvarType NUFloatType		= 18;
const NUIvarType NUFloatArrayType	= 19;
const NUIvarType NUDoubleType		= 20;
const NUIvarType NUDoubleArrayType	= 21;
const NUIvarType NUBOOLType			= 22;
const NUIvarType NUBOOLArrayType	= 23;
const NUIvarType NURegionType       = 24;
const NUIvarType NURegionArrayType  = 25;
const NUIvarType NUNSRangeType      = 26;
const NUIvarType NUNSRangeArrayType = 27;
const NUIvarType NUNSPointType      = 28;
const NUIvarType NUNSPointArrayType = 29;
const NUIvarType NUNSSizeType       = 30;
const NUIvarType NUNSSizeArrayType  = 31;
const NUIvarType NUNSRectType       = 32;
const NUIvarType NUNSRectArrayType  = 33;

id NUGetIvar(id *anIvar)
{
    if ([(NSObject *)*anIvar isBell]) NUSetIvar(anIvar, [*anIvar object]);
    return *anIvar;
}

id NUSetIvar(id *anIvar, id anObject)
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
	[super init];
	
	[self setName:aName];
	[self setType:aType];
	[self setSize:aSize];

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
	
	if (NUOOPType == aType || NUUInt64Type == aType) aTypeSize = sizeof(NUUInt64);
	else if (NUUInt8Type == aType) aTypeSize = sizeof(NUUInt8);
    else if (NUInt8Type == aType) aTypeSize = sizeof(NUInt8);
	else if (NUUInt16Type == aType) aTypeSize = sizeof(NUUInt16);
    else if (NUInt16Type == aType) aTypeSize = sizeof(NUInt16);
	else if (NUUInt32Type == aType) aTypeSize = sizeof(NUUInt32);
    else if (NUInt32Type == aType) aTypeSize = sizeof(NUInt32);
    else if (NUInt64Type == aType) aTypeSize = sizeof(NUInt64);
    else if (NUFloatType == aType) aTypeSize = sizeof(NUFloat);
	else if (NUDoubleType == aType) aTypeSize = sizeof(NUDouble);
    else if (NUBOOLType == aType) aTypeSize = sizeof(NUUInt8);
    else if (NURegionType == aType) aTypeSize = sizeof(NUUInt64) * 2;
    else if (NUNSRangeType == aType) aTypeSize = sizeof(NUUInt64) * 2;
    else if (NUNSPointType == aType) aTypeSize = sizeof(NUDouble) * 2;
    else if (NUNSSizeType == aType) aTypeSize = sizeof(NUDouble) * 2;
    else if (NUNSRectType == aType) aTypeSize = sizeof(NUDouble) * 4;
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

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
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
