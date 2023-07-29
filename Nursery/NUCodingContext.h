//
//  NUCodingContext.h
//  Nursery
//
//  Created by Akifumi Takata on 11/03/19.
//

#import "NUTypes.h"
#import "NUCodingNote.h"

@class NUBell, NUCharacter;

@interface NUCodingContext : NSObject
{
	NUBell *bell;
	id object;
    NUCharacter *character;
	NUUInt64 objectLocation;
    NUUInt64 nextIvarIndex;
    NUUInt64 nextIndexedIvarIndex;
    NUUInt64 indexedIvarOffset;
	NUUInt64 indexedIvarsSize;
    BOOL isIndexed;
}

+ (id)context;
+ (id)contextWithObjectLocation:(NUUInt64)anObjectLocation;

- (id)initWithObjectLocation:(NUUInt64)anObjectLocation;

- (NUBell *)bell;
- (void)setBell:(NUBell *)aBell;

- (id)object;
- (void)setObject:(id)anObject;

- (NUCharacter *)character;
- (void)setCharacter:(NUCharacter *)aCharacter;

- (NUUInt64)objectLocation;
- (void)setCurrentObjectLocation:(NUUInt64)aLocation;

- (NUUInt64)nextIvarIndex;
- (NUUInt64)nextIndexedIvarIndex;

- (NUUInt64)indexedIvarOffset;
- (void)setIndexedIvarOffset:(NUUInt64)anOffset;
- (NUUInt64)indexedIvarsSize;
- (void)setIndexedIvarsSize:(NUUInt64)aSize;

- (NUUInt64)nextIvarOffset;
- (NUUInt64)ivarOffsetForKey:(NSString *)aKey;

- (void)incrementNextIvarIndex;
- (void)incrementNextIvarIndexByCount:(NUUInt64)aCount;

- (BOOL)isIndexed;
- (void)setIsIndexed:(BOOL)aFlag;

- (id<NUCodingNote>)codingNote;

@end

@interface NUCodingContext (Encoding)

- (void)encodeBOOL:(BOOL)aValue;
- (void)encodeUInt8:(NUUInt8)aValue;
- (void)encodeUInt16:(NUUInt16)aValue;
- (void)encodeUInt32:(NUUInt32)aValue;
- (void)encodeInt64:(NUInt64)aValue;
- (void)encodeUInt64:(NUUInt64)aValue;
- (void)encodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount;
- (void)encodeFloat:(NUFloat)aValue;
- (void)encodeDouble:(NUDouble)aValue;
- (void)encodeRegion:(NURegion)aValue;
- (void)encodeRange:(NSRange)aValue;
- (void)encodePoint:(NUPoint)aValue;
- (void)encodeSize:(NUSize)aValue;
- (void)encodeRect:(NURect)aValue;

- (void)encodeUInt8:(NUUInt8)aValue forKey:(NSString *)aKey;
- (void)encodeUInt16:(NUUInt16)aValue forKey:(NSString *)aKey;
- (void)encodeUInt32:(NUUInt32)aValue forKey:(NSString *)aKey;
- (void)encodeUInt64:(NUUInt64)aValue forKey:(NSString *)aKey;
- (void)encodeFloat:(NUFloat)aValue forKey:(NSString *)aKey;
- (void)encodeDouble:(NUDouble)aValue forKey:(NSString *)aKey;
- (void)encodeBOOL:(BOOL)aValue forKey:(NSString *)aKey;
- (void)encodeRegion:(NURegion)aValue forKey:(NSString *)aKey;
- (void)encodeRange:(NSRange)aValue forKey:(NSString *)aKey;
- (void)encodePoint:(NUPoint)aValue forKey:(NSString *)aKey;
- (void)encodeSize:(NUSize)aValue forKey:(NSString *)aKey;
- (void)encodeRect:(NURect)aValue forKey:(NSString *)aKey;

- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount;
- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)anOffset;

@end

@interface NUCodingContext (Decoding)

- (BOOL)decodeBOOL;
- (NUUInt8)decodeUInt8;
- (NUUInt16)decodeUInt16;
- (NUUInt32)decodeUInt32;
- (NUUInt64)decodeUInt64;
- (NUInt64)decodeInt64;
- (void)decodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount;
- (NUFloat)decodeFloat;
- (NUDouble)decodeDouble;
- (NURegion)decodeRegion;
- (NSRange)decodeRange;
- (NUPoint)decodePoint;
- (NUSize)decodeSize;
- (NURect)decodeRect;

- (NUUInt8)decodeUInt8ForKey:(NSString *)aKey;
- (NUUInt16)decodeUInt16ForKey:(NSString *)aKey;
- (NUUInt32)decodeUInt32ForKey:(NSString *)aKey;
- (NUUInt64)decodeUInt64ForKey:(NSString *)aKey;
- (NUFloat)decodeFloatForKey:(NSString *)aKey;
- (NUDouble)decodeDoubleForKey:(NSString *)aKey;
- (BOOL)decodeBOOLForKey:(NSString *)aKey;
- (NURegion)decodeRegionForKey:(NSString *)aKey;
- (NSRange)decodeRangeForKey:(NSString *)aKey;
- (NUPoint)decodePointForKey:(NSString *)aKey;
- (NUSize)decodeSizeForKey:(NSString *)aKey;
- (NURect)decodeRectForKey:(NSString *)aKey;

- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount;
- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)aLocation;

@end
