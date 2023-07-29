//
//  NUCodingContext.m
//  Nursery
//
//  Created by Akifumi Takata on 11/03/19.
//

#import <Foundation/NSException.h>

#import "NUCodingContext.h"
#import "NURegion.h"
#import "NUCharacter.h"
#import "NUCharacter+Project.h"
#import "NUIvar.h"

@implementation NUCodingContext

+ (id)context
{
    return [[[self alloc] initWithObjectLocation:0] autorelease];
}

+ (id)contextWithObjectLocation:(NUUInt64)anObjectLocation
{
	return [[[self alloc] initWithObjectLocation:anObjectLocation] autorelease];
}

- (id)initWithObjectLocation:(NUUInt64)anObjectLocation
{
	if (self = [super init])
    {
        objectLocation = anObjectLocation;
	}
    
	return self;
}

- (NUBell *)bell
{
	return bell;
}

- (void)setBell:(NUBell *)aBell
{
	bell = aBell;
}

- (id)object
{
	return object;
}

- (void)setObject:(id)anObject
{
	object = anObject;
}

- (NUCharacter *)character
{
    return character;
}

- (void)setCharacter:(NUCharacter *)aCharacter
{
    character = aCharacter;
}

- (NUUInt64)objectLocation
{
	return objectLocation;
}

- (void)setCurrentObjectLocation:(NUUInt64)aLocation
{
	objectLocation = aLocation;
}

- (NUUInt64)nextIvarIndex
{
    return nextIvarIndex;
}

- (NUUInt64)nextIndexedIvarIndex
{
    return nextIndexedIvarIndex;
}

- (NUUInt64)indexedIvarOffset
{
    return indexedIvarOffset;
}

- (void)setIndexedIvarOffset:(NUUInt64)anOffset
{
    indexedIvarOffset = anOffset;
}

- (NUUInt64)indexedIvarsSize
{
	return indexedIvarsSize;
}

- (void)setIndexedIvarsSize:(NUUInt64)aSize
{
	indexedIvarsSize = aSize;
}

- (NUUInt64)nextIvarOffset
{
    NUUInt64 anIvarOffset;
    
    if (![self isIndexed])
    {
        NUIvar *anIvar = [[self character] ivarInAllIvarsAt:(NSUInteger)[self nextIvarIndex]];
        anIvarOffset = [anIvar offset];
    }
    else
    {
        anIvarOffset = [self indexedIvarOffset] + [self nextIndexedIvarIndex] * sizeof(NUUInt64);
    }

    return anIvarOffset;
}

- (void)incrementNextIvarIndex
{
    [self incrementNextIvarIndexByCount:1];
}

- (void)incrementNextIvarIndexByCount:(NUUInt64)aCount
{
    if ([self isIndexed])
        nextIndexedIvarIndex += aCount;
    else
        nextIvarIndex += aCount;
}

- (BOOL)isIndexed
{
    return isIndexed;
}

- (void)setIsIndexed:(BOOL)aFlag
{
    isIndexed = aFlag;
}

- (id<NUCodingNote>)codingNote
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
}

- (NUUInt64)ivarOffsetForKey:(NSString *)aKey
{
    return [[self character] ivarOffsetForName:aKey];
}
            
@end

@implementation NUCodingContext (Encoding)

- (void)encodeBOOL:(BOOL)aValue
{
    [[self codingNote] writeBOOL:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeUInt8:(NUUInt8)aValue
{
    [[self codingNote] writeUInt8:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeUInt16:(NUUInt16)aValue
{
    [[self codingNote] writeUInt16:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeUInt32:(NUUInt32)aValue
{
    [[self codingNote] writeUInt32:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeUInt64:(NUUInt64)aValue
{
    [[self codingNote] writeUInt64:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeInt64:(NUInt64)aValue
{
    [self encodeUInt64:aValue];
}

- (void)encodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount
{
    [[self codingNote] writeUInt64Array:aValues ofCount:aCount at:[self objectLocation] + [self indexedIvarOffset]];
}

- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount
{
    [self encodeIndexedBytes:aBytes count:aCount at:0];
}

- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)anOffset
{
    [[self codingNote] write:aBytes length:aCount at:[self objectLocation] + [self indexedIvarOffset] + anOffset];
}

- (void)encodeFloat:(NUFloat)aValue
{
    [[self codingNote] writeFloat:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeDouble:(NUDouble)aValue
{
    [[self codingNote] writeDouble:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeRegion:(NURegion)aValue
{
    [[self codingNote] writeRegion:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeRange:(NSRange)aValue
{
    [[self codingNote] writeRange:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodePoint:(NUPoint)aValue
{
    [[self codingNote] writePoint:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeSize:(NUSize)aValue
{
    [[self codingNote] writeSize:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeRect:(NURect)aValue
{
    [[self codingNote] writeRect:aValue at:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
}

- (void)encodeUInt8:(NUUInt8)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeUInt8:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeUInt16:(NUUInt16)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeUInt16:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeUInt32:(NUUInt32)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeUInt32:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeUInt64:(NUUInt64)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeUInt64:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeFloat:(NUFloat)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeFloat:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeDouble:(NUDouble)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeDouble:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeBOOL:(BOOL)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeBOOL:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeRegion:(NURegion)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeRegion:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeRange:(NSRange)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeRange:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodePoint:(NUPoint)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writePoint:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeSize:(NUSize)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeSize:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)encodeRect:(NURect)aValue forKey:(NSString *)aKey
{
    [[self codingNote] writeRect:aValue at:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

@end

@implementation NUCodingContext (Decoding)

- (BOOL)decodeBOOL
{
    BOOL aValue = [[self codingNote] readBOOLAt:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NUUInt8)decodeUInt8
{
    NUUInt8 aValue = [[self codingNote] readUInt8At:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NUUInt16)decodeUInt16
{
    NUUInt16 aValue = [[self codingNote] readUInt16At:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NUUInt32)decodeUInt32
{
    NUUInt32 aValue = [[self codingNote] readUInt32At:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NUUInt64)decodeUInt64
{
    NUUInt64 aValue = [[self codingNote] readUInt64At:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NUInt64)decodeInt64
{
    return [self decodeUInt64];
}

- (void)decodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount
{
    [[self codingNote] readUInt64Array:aValues ofCount:aCount at:[self objectLocation] + [self indexedIvarOffset]];
}

- (NUFloat)decodeFloat
{
    NUFloat aValue = [[self codingNote] readFloatAt:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NUDouble)decodeDouble
{
    NUDouble aValue = [[self codingNote] readDoubleAt:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NURegion)decodeRegion
{
    NURegion aValue = [[self codingNote] readRegionAt:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NSRange)decodeRange
{
    NSRange aValue = [[self codingNote] readRangeAt:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NUPoint)decodePoint
{
    NUPoint aValue = [[self codingNote] readPointAt:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NUSize)decodeSize
{
    NUSize aValue = [[self codingNote] readSizeAt:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NURect)decodeRect
{
    NURect aValue = [[self codingNote] readRectAt:[self objectLocation] + [self nextIvarOffset]];
    [self incrementNextIvarIndex];
    return aValue;
}

- (NUUInt8)decodeUInt8ForKey:(NSString *)aKey
{
    return [[self codingNote] readUInt8At:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NUUInt16)decodeUInt16ForKey:(NSString *)aKey
{
    return [[self codingNote] readUInt16At:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NUUInt32)decodeUInt32ForKey:(NSString *)aKey
{
    return [[self codingNote] readUInt32At:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NUUInt64)decodeUInt64ForKey:(NSString *)aKey
{
    return [[self codingNote] readUInt64At:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NUFloat)decodeFloatForKey:(NSString *)aKey
{
    return [[self codingNote] readFloatAt:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NUDouble)decodeDoubleForKey:(NSString *)aKey
{
    return [[self codingNote] readDoubleAt:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (BOOL)decodeBOOLForKey:(NSString *)aKey
{
    return [[self codingNote] readBOOLAt:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NURegion)decodeRegionForKey:(NSString *)aKey
{
    return [[self codingNote] readRegionAt:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NSRange)decodeRangeForKey:(NSString *)aKey
{
    return [[self codingNote] readRangeAt:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NUPoint)decodePointForKey:(NSString *)aKey
{
    return [[self codingNote] readPointAt:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NUSize)decodeSizeForKey:(NSString *)aKey
{
    return [[self codingNote] readSizeAt:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (NURect)decodeRectForKey:(NSString *)aKey
{
    return [[self codingNote] readRectAt:[self objectLocation] + [self ivarOffsetForKey:aKey]];
}

- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount
{
    [[self codingNote] read:aBytes length:aCount at:[self objectLocation] + [self indexedIvarOffset]];
}

- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)aLocation
{
    [[self codingNote] read:aBytes length:aCount at:[self objectLocation] + [self indexedIvarOffset] + aLocation];
}

@end
