//
//  NUAliaser.h
//  Nursery
//
//  Created by Akifumi Takata on 11/02/05.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

@class NUSandbox, NUPages, NUCodingContext, NUIndexArray, NUObjectTable, NUBell, NUPupilNote, NUCharacter;

extern NSString *NUObjectLocationNotFoundException;
extern NSString *NUBellBallNotFoundException;
extern NSString *NUAliaserCannotEncodeObjectException;
extern NSString *NUAliaserCannotDecodeObjectException;

@interface NUAliaser : NSObject
{
	NUSandbox *sandbox;
	NSMutableArray *contexts;
	NSMutableArray *roots;
	NSMutableArray *objectsToEncode;
	NUIndexArray *rootOOPs;
}
@end

@interface NUAliaser (Initializing)

+ (id)aliaserWithSandbox:(NUSandbox *)aSandbox;

- (id)initWithSandbox:(NUSandbox *)aSandbox;

@end

@interface NUAliaser (Accessing)

- (NUSandbox *)sandbox;
- (void)setSandbox:(NUSandbox *)aSandbox;

- (NSMutableArray *)contexts;
- (void)setContexts:(NSMutableArray *)aContexts;

- (NSMutableArray *)roots;
- (void)setRoots:(NSMutableArray *)aRoots;

- (NSMutableArray *)objectToEncode;
- (void)setObjectToEncode:(NSMutableArray *)anObjectsToEncode;

- (NUUInt64)indexedIvarOffset;
- (void)setIndexedIvarOffset:(NUUInt64)anOffset;
- (NUUInt64)indexedIvarsSize;
- (void)setIndexedIvarsSize:(NUUInt64)aSize;

- (NUCharacter *)character;

- (NUUInt64)rootOOP;

- (NUUInt64)grade;
- (NUUInt64)gradeForSave;

@end

@interface NUAliaser (Testing)

- (BOOL)isForMainBranch;

- (BOOL)containsValueForKey:(NSString *)aKey;

@end

@interface NUAliaser (Bell)

- (NUBell *)allocateBellForObject:(id)anObject;

@end

@interface NUAliaser (Contexts)

- (NUCodingContext *)currentContext;
- (void)pushContext:(NUCodingContext *)aContext;
- (NUCodingContext *)popContext;

@end

@interface NUAliaser (Encoding)

- (void)encodeObjects;
- (void)encodeRoots;
- (void)encodeChangedObjects;

- (void)encodeObjectsFromStarter;
- (void)encodeObjectReally:(id)anObject;
- (void)ensureCharacterRegistration:(NUCharacter *)aCharacter;
- (void)prepareCodingContextForEncode:(id)anObject;
- (void)objectDidEncode:(NUBell *)aBell;
- (id)nextObjectToEncode;

- (void)validateSandboxOfEncodingObject:(id)anObject;

- (void)encodeObject:(id)anObject;
- (NUUInt64)preEncodeObject:(id)anObject;
- (void)encodeBOOL:(BOOL)aValue;
- (void)encodeInt8:(NUInt8)aValue;
- (void)encodeInt16:(NUInt16)aValue;
- (void)encodeInt32:(NUInt32)aValue;
- (void)encodeInt64:(NUInt64)aValue;
- (void)encodeUInt8:(NUUInt8)aValue;
- (void)encodeUInt16:(NUUInt16)aValue;
- (void)encodeUInt32:(NUUInt32)aValue;
- (void)encodeUInt64:(NUUInt64)aValue;
- (void)encodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount;
- (void)encodeFloat:(NUFloat)aValue;
- (void)encodeDouble:(NUDouble)aValue;
- (void)encodeRegion:(NURegion)aValue;
- (void)encodeRange:(NSRange)aValue;
- (void)encodePoint:(NSPoint)aValue;
- (void)encodeSize:(NSSize)aValue;
- (void)encodeRect:(NSRect)aValue;

- (void)encodeObject:(id)anObject forKey:(NSString *)aKey;

- (void)encodeInt8:(NUInt8)aValue forKey:(NSString *)aKey;
- (void)encodeInt16:(NUInt16)aValue forKey:(NSString *)aKey;
- (void)encodeInt32:(NUInt32)aValue forKey:(NSString *)aKey;
- (void)encodeInt64:(NUInt64)aValue forKey:(NSString *)aKey;

- (void)encodeUInt8:(NUUInt8)aValue forKey:(NSString *)aKey;
- (void)encodeUInt16:(NUUInt16)aValue forKey:(NSString *)aKey;
- (void)encodeUInt32:(NUUInt32)aValue forKey:(NSString *)aKey;
- (void)encodeUInt64:(NUUInt64)aValue forKey:(NSString *)aKey;

- (void)encodeFloat:(NUFloat)aValue forKey:(NSString *)aKey;;
- (void)encodeDouble:(NUDouble)aValue forKey:(NSString *)aKey;
- (void)encodeBOOL:(BOOL)aValue forKey:(NSString *)aKey;

- (void)encodeRegion:(NURegion)aValue forKey:(NSString *)aKey;
- (void)encodeRange:(NSRange)aValue forKey:(NSString *)aKey;
- (void)encodePoint:(NSPoint)aValue forKey:(NSString *)aKey;
- (void)encodeSize:(NSSize)aValue forKey:(NSString *)aKey;
- (void)encodeRect:(NSRect)aValue forKey:(NSString *)aKey;

- (void)encodeIndexedIvars:(id *)anIndexedIvars count:(NUUInt64)aCount;
- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount;
- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)anOffset;

@end

@interface NUAliaser (Decoding)

- (NSMutableArray *)decodeRoots;
- (NSMutableArray *)decodeObjectsFromStarter;

- (id)decodeObject;
- (id)decodeObjectReally;
- (id)decodeObjectForOOP:(NUUInt64)aRawOOP really:(BOOL)aReallyDecode;
- (id)decodeObjectForBell:(NUBell *)aBell;
- (void)prepareCodingContextForDecode:(NUBell *)aBell;
- (id)decodeObjectForBell:(NUBell *)aBell classOOP:(NUUInt64)aClassOOP;
- (void)ensureCharacterForDecoding:(NUCharacter *)aCharacter;
- (BOOL)decodeBOOL;
- (NUInt8)decodeInt8;
- (NUInt16)decodeInt16;
- (NUInt16)decodeInt32;
- (NUInt64)decodeInt64;
- (NUUInt8)decodeUInt8;
- (NUUInt16)decodeUInt16;
- (NUUInt32)decodeUInt32;
- (NUUInt64)decodeUInt64;
- (void)decodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount;
- (NUFloat)decodeFloat;
- (NUDouble)decodeDouble;
- (NURegion)decodeRegion;
- (NSRange)decodeRange;
- (NSPoint)decodePoint;
- (NSSize)decodeSize;
- (NSRect)decodeRect;

- (id)decodeObjectForKey:(NSString *)aKey;

- (NUInt8)decodeInt8ForKey:(NSString *)aKey;
- (NUInt16)decodeInt16ForKey:(NSString *)aKey;
- (NUInt32)decodeInt32ForKey:(NSString *)aKey;
- (NUInt64)decodeInt64ForKey:(NSString *)aKey;

- (NUUInt8)decodeUInt8ForKey:(NSString *)aKey;
- (NUUInt16)decodeUInt16ForKey:(NSString *)aKey;
- (NUUInt32)decodeUInt32ForKey:(NSString *)aKey;
- (NUUInt64)decodeUInt64ForKey:(NSString *)aKey;

- (NUFloat)decodeFloatForKey:(NSString *)aKey;
- (NUDouble)decodeDoubleForKey:(NSString *)aKey;
- (BOOL)decodeBOOLForKey:(NSString *)aKey;

- (NURegion)decodeRegionForKey:(NSString *)aKey;
- (NSRange)decodeRangeForKey:(NSString *)aKey;
- (NSPoint)decodePointForKey:(NSString *)aKey;
- (NSSize)decodeSizeForKey:(NSString *)aKey;
- (NSRect)decodeRectForKey:(NSString *)aKey;

- (void)decodeIndexedIvar:(id *)anIndexedIvars count:(NUUInt64)aCount really:(BOOL)aReallyDecode;
- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount;
- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)aLocation;

- (void)moveUp:(id)anObject;
- (void)moveUp:(id)anObject ignoreGradeAtCallFor:(BOOL)anIgnoreFlag;
- (void)prepareCodingContextForMoveUp:(NUBell *)aBell;

- (NUUInt64)objectLocationForBell:(NUBell *)aBell gradeInto:(NUUInt64 *)aGrade;

@end

@interface NUAliaser (ObjectSpace)

- (NUUInt64)computeSizeOfObject:(id)anObject;

@end

@interface NUAliaser (Pupil)

- (void)fixProbationaryOOPsInPupil:(NUPupilNote *)aPupilNote;
- (void)fixProbationaryOOPAtOffset:(NUUInt64)anIvarOffset inPupil:(NUPupilNote *)aPupilNote character:(NUCharacter *)aCharacter;

@end
