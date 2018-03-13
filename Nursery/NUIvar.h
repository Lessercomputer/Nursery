//
//  NUIvar.h
//  Nursery
//
//  Created by Akifumi Takata on 11/02/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>
#import <Nursery/NUCoding.h>

@class NUBell;

extern const NUIvarType NUOOPIvarType;
extern const NUIvarType NUUInt8IvarType;
extern const NUIvarType NUInt8IvarType;
extern const NUIvarType NUUInt16IvarType;
extern const NUIvarType NUInt16IvarType;
extern const NUIvarType NUUInt32IvarType;
extern const NUIvarType NUInt32IvarType;
extern const NUIvarType NUUInt64IvarType;
extern const NUIvarType NUInt64IvarType;
extern const NUIvarType NUFloatIvarType;
extern const NUIvarType NUDoubleIvarType;
extern const NUIvarType NUBOOLIvarType;
extern const NUIvarType NURegionIvarType;
extern const NUIvarType NUNSRangeIvarType;
extern const NUIvarType NUNSPointIvarType;
extern const NUIvarType NUNSSizeIvarType;
extern const NUIvarType NUNSRectIvarType;

extern id NUGetIvar(id __strong *anIvar);
extern id NUSetIvar(id __strong *anIvar, id anObject);

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
