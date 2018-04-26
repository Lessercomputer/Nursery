//
//  NUCharacter.h
//  Nursery
//
//  Created by Akifumi Takata on 11/02/08.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSObject.h>

#import <Nursery/NUTypes.h>
#import <Nursery/NUCoding.h>
#import <Nursery/NUMovingUp.h>

@class NSString, NSMutableArray, NSMutableSet, NSRecursiveLock;
@class NUBell, NUIvar, NUCharacter, NUGarden, NUCoder;

extern const NUObjectFormat NUFixedIvars;
extern const NUObjectFormat NUIndexedIvars;
extern const NUObjectFormat NUFixedAndIndexedIvars;
extern const NUObjectFormat NUIndexedBytes;

extern NSString *NUCharacterIvarAlreadyExistsException;
extern NSString *NUCharacterInvalidObjectFormatException;

@protocol NUCharacter

+ (BOOL)automaticallyEstablishCharacter;
+ (NUCharacter *)characterOn:(NUGarden *)aGarden;
+ (NUCharacter *)establishCharacterOn:(NUGarden *)aGarden;
+ (NUCharacter *)createCharacterOn:(NUGarden *)aGarden;
+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden;
+ (NSString *)CharacterNameOn:(NUGarden *)aGarden;
- (Class)classForNursery;

@end

@interface NUCharacter : NSObject <NUCoding, NUMovingUp>
{
	NUCharacter *superCharacter;
	NUObjectFormat format;
	NUUInt32 version;
	NSString *name;
	NSMutableArray *ivars;
	NSMutableSet *subCharacters;
	NUBell *bell;
	Class targetClass;
	Class coderClass;
    NUCoder *coder;
	BOOL needsComputeBasicSize;
	NUUInt64 basicSize;
	NSString *fullName;
	BOOL isMutable;
	NSArray *allOOPIvars;
	NSArray *allIvars;
    NSDictionary *allIvarDictionary;
	BOOL needsComputeIvarOffset;
	BOOL needsComputeIndexedIvarOffset;
	NUUInt64 indexedIvarOffset;
    NSRecursiveLock *lock;
}

+ (id)character;
+ (id)characterWithName:(NSString *)aName super:(NUCharacter *)aSuper;

- (id)initWithName:(NSString *)aName super:(NUCharacter *)aSuper;

- (NUCharacter *)superCharacter;
- (void)setSuperCharacter:(NUCharacter *)aSuper;

- (NUObjectFormat)format;
- (void)setFormat:(NUObjectFormat)aFormat;

- (NUUInt32)version;
- (void)setVersion:(NUUInt32)aVersion;

- (NSString *)name;
- (void)setName:(NSString *)aName;

- (NSMutableArray *)ivars;
- (void)setIvars:(NSMutableArray *)anIvars;

- (void)addOOPIvarWithName:(NSString *)aName;
- (void)addInt8IvarWithName:(NSString *)aName;
- (void)addInt16IvarName:(NSString *)aName;
- (void)addInt32IvarName:(NSString *)aName;
- (void)addInt64IvarName:(NSString *)aName;
- (void)addUInt8IvarWithName:(NSString *)aName;
- (void)addUInt16IvarName:(NSString *)aName;
- (void)addUInt32IvarName:(NSString *)aName;
- (void)addUInt64IvarWithName:(NSString *)aName;
- (void)addFloatIvarWithName:(NSString *)aName;
- (void)addDoubleIvarWithName:(NSString *)aName;
- (void)addBOOLIvarWithName:(NSString *)aName;
- (void)addRangeIvarWithName:(NSString *)aName;
- (void)addPointIvarWithName:(NSString *)aName;
- (void)addSizeIvarWithName:(NSString *)aName;
- (void)addRectIvarWithName:(NSString *)aName;

- (void)addIvarWithName:(NSString *)aName type:(NUIvarType)aType;
- (void)addIvar:(NUIvar *)anIvar;

- (void)setAllOOPIvars:(NSArray *)anOOPIvars;
- (NSArray *)allOOPIvars;
- (NSUInteger)allOOPIvarsCount;
- (NUIvar *)ivarInAllOOPIvarsAt:(NSUInteger)anIndex;
- (NSArray *)getAllOOPIvars;

- (NSArray *)copyAllIvars;
- (NSArray *)allIvars;
- (NSDictionary *)allIvarDictionary;
- (void)setAllIvars:(NSArray *)anIvars;
- (NSArray *)getAllIvars;
- (NSDictionary *)allIvarDictionaryFrom:(NSArray *)anIvars;

- (NUIvar *)ivarInAllIvarsAt:(NSUInteger)anIndex;

- (NUUInt64)ivarOffsetForName:(NSString *)aName;

- (NSArray *)ancestors;

- (NSMutableSet *)subCharacters;
- (void)setSubCharacters:(NSMutableSet *)aSubCharacters;

- (void)addSubCharacter:(NUCharacter *)aCharacter;
- (void)removeSubCharacter:(NUCharacter *)aCharacter;

- (void)addToSuperCharacter;
- (void)removeFromSuperCharacter;

- (NUUInt64)basicSize;
- (NUUInt64)computeBasicSize;
- (void)computeIvarOffset;
- (NUUInt64)indexedIvarOffset;

- (NSString *)fullName;
- (NSString *)getFullName;
- (void)setFullName:(NSString *)aFullName;

- (Class)targetClass;
- (void)setTargetClass:(Class)aClass;

- (Class)coderClass;
- (void)setCoderClass:(Class)aClass;

- (NUCoder *)coder;
- (void)setCoder:(NUCoder *)aCoder;

- (BOOL)isMutable;
- (void)setIsMutable:(BOOL)aMutableFlag;

- (BOOL)isEqualToCharacter:(NUCharacter *)aCharacter;

- (BOOL)isRoot;

- (BOOL)formatIsValid;
- (BOOL)formatIsValid:(NUObjectFormat)anObjectFormat;

- (BOOL)isFixedIvars;
- (BOOL)isVariable;
- (BOOL)isIndexedIvars;
- (BOOL)isFixedAndIndexedIvars;
- (BOOL)isIndexedBytes;

- (BOOL)containsIvarWithName:(NSString *)aName;

- (void)moveUp;

@end










