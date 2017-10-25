//
//  NUIvar.h
//  Nursery
//
//  Created by P,T,A on 11/02/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>
#import <Nursery/NUCoding.h>

@class NUBell;

extern const NUIvarType NUOOPType;
extern const NUIvarType NUOOPArrayType;
extern const NUIvarType NUUInt8Type;
extern const NUIvarType NUUInt8ArrayType;
extern const NUIvarType NUInt8Type;
extern const NUIvarType NUInt8ArrayType;
extern const NUIvarType NUUInt16Type;
extern const NUIvarType NUUInt16ArrayType;
extern const NUIvarType NUInt16Type;
extern const NUIvarType NUInt16ArrayType;
extern const NUIvarType NUUInt32Type;
extern const NUIvarType NUUInt32ArrayType;
extern const NUIvarType NUInt32Type;
extern const NUIvarType NUInt32ArrayType;
extern const NUIvarType NUUInt64Type;
extern const NUIvarType NUUInt64ArrayType;
extern const NUIvarType NUInt64Type;
extern const NUIvarType NUInt64ArrayType;
extern const NUIvarType NUFloatType;
extern const NUIvarType NUFloatArrayType;
extern const NUIvarType NUDoubleType;
extern const NUIvarType NUDoubleArrayType;
extern const NUIvarType NUBOOLType;
extern const NUIvarType NUBOOLArrayType;
extern const NUIvarType NURegionType;
extern const NUIvarType NURegionArrayType;
extern const NUIvarType NUNSRangeType;
extern const NUIvarType NUNSRangeArrayType;
extern const NUIvarType NUNSPointType;
extern const NUIvarType NUNSPointArrayType;
extern const NUIvarType NUNSSizeType;
extern const NUIvarType NUNSSizeArrayType;
extern const NUIvarType NUNSRectType;
extern const NUIvarType NUNSRectArrayType;

extern id NUGetIvar(id *anIvar);
extern id NUSetIvar(id *anIvar, id anObject);

extern NSString *NUIvarInvalidTypeException;

@interface NUIvar : NSObject <NUCoding, NSCopying>
{
	NSString *name;
	NUIvarType type;
	NUUInt64 size;
	NUUInt64 offset;
	NUBell *bell;
}

+ (id)ivarWithName:(NSString *)aName type:(NUIvarType)aType;
+ (id)ivarWithName:(NSString *)aName type:(NUIvarType)aType size:(NUUInt64)aSize;

- (id)initWithName:(NSString *)aName type:(NUIvarType)aType;
- (id)initWithName:(NSString *)aName type:(NUIvarType)aType size:(NUUInt64)aSize;

- (NSString *)name;
- (void)setName:(NSString *)aName;

- (NUIvarType)type;
- (void)setType:(NUIvarType)aType;

- (NUUInt64)size;
- (void)setSize:(NUUInt64)aSize;

- (NUUInt64)sizeInBytes;

- (NUUInt64)offset;
- (void)setOffset:(NUUInt64)anOffset;

- (BOOL)isEqualToIvar:(NUIvar *)anIvar;

@end
