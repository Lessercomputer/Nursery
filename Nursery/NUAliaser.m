//
//  NUAliaser.m
//  Nursery
//
//  Created by Akifumi Takata on 11/02/05.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#include <stdlib.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSException.h>

#import "NUAliaser.h"
#import "NUAliaser+Project.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUPages.h"
#import "NUCodingContext.h"
#import "NUIndexArray.h"
#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUObjectTable.h"
#import "NUCoding.h"
#import "NUCoder.h"
#import "NUCharacter.h"
#import "NUSpaces.h"
#import "NUSeeker.h"
#import "NURegion.h"
#import "NUBellBall.h"
#import "NUGradeSeeker.h"
#import "NUBranchAliaser.h"
#import "NUPairedMainBranchGarden.h"
#import "NUPairedMainBranchAliaser.h"
#import "NUU64ODictionary.h"
#import "NUPupilNote.h"
#import "NUIvar.h"
#import "NUQueue.h"

NSString *NUObjectLocationNotFoundException = @"NUObjectLocationNotFoundException";
NSString *NUBellBallNotFoundException = @"NUBellBallNotFoundException";
NSString *NUAliaserCannotEncodeObjectException = @"NUAliaserCannotEncodeObjectException";
NSString *NUAliaserCannotDecodeObjectException = @"NUAliaserCannotDecodeObjectException";

@class NUMainBranchAliaser, NUBranchAliaser, NUPairedMainBranchAliaser;

@implementation NUAliaser
@end

@implementation NUAliaser (Initializing)

+ (id)aliaserWithGarden:(NUGarden *)aGarden
{
	return [[[self alloc] initWithGarden:aGarden] autorelease];
}

- (id)initWithGarden:(NUGarden *)aGarden
{
	if (self = [super init])
    {
        [self setGarden:aGarden];
        [self setContexts:[NSMutableArray array]];
        [self setObjectsToEncode:[NUQueue queue]];
        encodedPupils = [NSMutableArray new];
	}
    
	return self;
}

- (void)dealloc
{
	[self setRoots:nil];
	[self setObjectsToEncode:nil];
	[self setContexts:nil];
    [encodedPupils release];
	
	[super dealloc];
}

@end

@implementation NUAliaser (Accessing)

- (NUGarden *)garden
{
	return garden;
}

- (void)setGarden:(NUGarden *)aGarden
{
	garden = aGarden;
}

- (NSMutableArray *)contexts
{
	return contexts;
}

- (void)setContexts:(NSMutableArray *)aContexts
{
	[contexts autorelease];
	contexts = [aContexts retain];
}

- (NSMutableArray *)roots
{
	return roots;
}

- (void)setRoots:(NSMutableArray *)aRoots
{
	[roots autorelease];
	roots = [aRoots retain];
}

- (NUQueue *)objectsToEncode
{
	return objectsToEncode;
}

- (void)setObjectsToEncode:(NUQueue *)anObjectsToEncode
{
	[objectsToEncode autorelease];
	objectsToEncode = [anObjectsToEncode retain];
}

- (NSMutableArray *)encodedPupils
{
    return encodedPupils;
}

- (void)setEncodedPupils:(NSMutableArray *)anEncodedPupils
{
    [encodedPupils autorelease];
    encodedPupils = [anEncodedPupils retain];
}

- (NUUInt64)indexedIvarOffset
{
    return [[self currentContext] indexedIvarOffset];
}

- (void)setIndexedIvarOffset:(NUUInt64)anOffset
{
    [[self currentContext] setIndexedIvarOffset:anOffset];
}

- (NUUInt64)indexedIvarsSize
{
	return [[self currentContext] indexedIvarsSize];
}

- (void)setIndexedIvarsSize:(NUUInt64)aSize
{
	[[self currentContext] setIndexedIvarsSize:aSize];
}

- (NUCharacter *)character
{
    return [[self currentContext] character];
}

- (NUUInt64)rootOOP
{
    return NUNilOOP;
}

- (NUUInt64)grade
{
    return [[self garden] grade];
}

- (NUUInt64)gradeForSave
{
    return NUTemporaryGrade;
}

@end

@implementation NUAliaser (Testing)

- (BOOL)isForMainBranch
{
    return YES;
}

- (BOOL)containsValueForKey:(NSString *)aKey
{
    return [[self character] containsIvarWithName:aKey];
}

@end

@implementation NUAliaser (Bell)

- (NUBell *)allocateBellForObject:(id)anObject
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
}

@end

@implementation NUAliaser (Contexts)

- (NUCodingContext *)currentContext
{
	return [[self contexts] lastObject];
}

- (void)pushContext:(NUCodingContext *)aContext
{
	[[self contexts] addObject:aContext];
}

- (NUCodingContext *)popContext
{
	NUCodingContext *aContext = [[self contexts] lastObject];
	[[self contexts] removeLastObject];
	return aContext;
}

@end

@implementation NUAliaser (Encoding)

- (void)encodeObjects
{
	[self encodeRoots];
	[self encodeChangedObjects];
}

- (void)encodeRoots
{
	while ([[self roots] count])
	{
		id anObject = [[self roots] objectAtIndex:0];
		[[self objectsToEncode] push:anObject];
        [[self roots] removeObjectAtIndex:0];
		[self encodeObjectsFromStarter];
	}
}

- (void)encodeChangedObjects
{
	NUBell *aChangedObject;
	NUU64ODictionary *aChangedObjects = [[self garden] changedObjects];
	
	while ((aChangedObject = [aChangedObjects anyObject]))
	{
		[[self objectsToEncode] push:aChangedObject];
		[self encodeObjectsFromStarter];
	}
}

- (void)encodeObjectsFromStarter
{
	id aCurrentObject;
	
	while ((aCurrentObject = [self nextObjectToEncode]))
		[self encodeObjectReally:aCurrentObject];
}

- (void)encodeObjectReally:(id)anObject
{
    NUCharacter *aCharacter = [[anObject classForNursery] characterOn:[self garden]];
    
	[self ensureCharacterRegistration:aCharacter];
    
	[self prepareCodingContextForEncode:anObject];
	
	[self encodeObject:aCharacter];
	
    [[self currentContext] setCharacter:aCharacter];
    
	if ([aCharacter isVariable])
    {
        [self setIndexedIvarOffset:[aCharacter indexedIvarOffset]];
        [self encodeUInt64:[anObject indexedIvarsSize]];
    }
    
	if ([aCharacter coderClass])
		[[aCharacter coder] encode:anObject withAliaser:self];
	else
		[anObject encodeWithAliaser:self];
	
	[self objectDidEncode:[[self currentContext] bell]];
	[[self garden] unmarkChangedObject:anObject];
	[self popContext];

}

- (void)ensureCharacterRegistration:(NUCharacter *)aCharacter
{
    do {
        if (![[self garden] characterForName:[aCharacter fullName]])
            [[self garden] setCharacter:aCharacter forName:[aCharacter fullName]];
    } while ((aCharacter = [aCharacter superCharacter]));
}

- (NUU64ODictionary *)reducedEncodedPupilsDictionary:(NSArray *)anEncodedPupils
{
    NUU64ODictionary *aReducedEncodedPupilsDictionary = [NUU64ODictionary dictionary];
    
    [anEncodedPupils enumerateObjectsUsingBlock:^(NUPupilNote * _Nonnull aPupilNote, NSUInteger idx, BOOL * _Nonnull stop) {
        [aReducedEncodedPupilsDictionary setObject:aPupilNote forKey:[aPupilNote OOP]];
    }];
    
    return aReducedEncodedPupilsDictionary;
}

- (NSArray *)reducedEncodedPupilsFor:(NSArray *)anEncodedPupils with:(NUU64ODictionary *)aReducedEncodedPupilsDictionary
{
    NSMutableArray *aReducedEncodedPupils = [NSMutableArray array];
    
    [anEncodedPupils enumerateObjectsUsingBlock:^(NUPupilNote * _Nonnull aPupilNote, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([aReducedEncodedPupilsDictionary objectForKey:[aPupilNote OOP]] == aPupilNote)
            [aReducedEncodedPupils addObject:aPupilNote];
    }];
    
    return aReducedEncodedPupils;
}

- (NUUInt64)sizeOfEncodedObjects:(NSArray *)aReducedEncodedPupils
{
    __block NUUInt64 anEncodedObjectsSize = 0;
    
    [aReducedEncodedPupils enumerateObjectsUsingBlock:^(NUPupilNote * _Nonnull aPupilNote, NSUInteger idx, BOOL * _Nonnull stop) {
            anEncodedObjectsSize += [aPupilNote size];
    }];
    
    return anEncodedObjectsSize;
}

- (NUUInt64)sizeOfEncodedObjects:(NSArray *)aReducedEncodedPupils with:(NUU64ODictionary *)aReducedEncodedPupilsDictionary
{
    __block NUUInt64 anEncodedObjectsSize = 0;
    
    [aReducedEncodedPupils enumerateObjectsUsingBlock:^(NUPupilNote * _Nonnull aPupilNote, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([aReducedEncodedPupilsDictionary objectForKey:[aPupilNote OOP]] == aPupilNote)
            anEncodedObjectsSize += [aPupilNote size];
    }];
    
    return anEncodedObjectsSize;
}

- (void)objectDidEncode:(NUBell *)aBell
{
    
}

- (void)prepareCodingContextForEncode:(id)anObject
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
}

- (id)nextObjectToEncode
{	
	while ([objectsToEncode count])
	{
		id aNextObject = [[self objectsToEncode] pop];
		
		if ([[self garden] needsEncode:aNextObject]) return aNextObject;
    }
		
	return nil;
}

- (void)validateGardenOfEncodingObject:(id)anObject
{
    NUGarden *aGardenOfAnObject = nil;
    
    if ([anObject isBell])
        aGardenOfAnObject = [(NUBell *)anObject garden];
    else if ([anObject conformsToProtocol:@protocol(NUCoding)])
        aGardenOfAnObject = [[(id <NUCoding>)anObject bell] garden];
    
    if (aGardenOfAnObject && ![aGardenOfAnObject isEqual:[self garden]])
        @throw [NSException exceptionWithName:NUAliaserCannotEncodeObjectException reason:NUAliaserCannotEncodeObjectException userInfo:nil];
}

- (void)encodeObject:(id)anObject
{
	[self encodeUInt64:[self preEncodeObject:anObject]];
}

- (NUUInt64)preEncodeObject:(id)anObject
{
    NUUInt64 anOOP = NUNilOOP;
    
    [self validateGardenOfEncodingObject:anObject];
    
    if ([anObject isBell])
        anOOP = [anObject OOP];
    else if (anObject
             && ([anObject conformsToProtocol:@protocol(NUCoding)]
                 || [[[anObject classForNursery] characterOn:[self garden]] coderClass]))
    {
        NUBell *aBell = [[self garden] bellForObject:anObject];
        
        if (aBell)
        {
            anOOP = [aBell OOP];
            if ([[self garden] needsEncode:anObject])
                [[self objectsToEncode] push:anObject];
        }
        else
        {
            anOOP = [[self allocateBellForObject:anObject] OOP];
            [[self objectsToEncode] push:anObject];
            [[self garden] markChangedObject:anObject];
        }
    }

    return anOOP;
}

- (void)encodeBOOL:(BOOL)aValue
{
    [[self currentContext] encodeBOOL:aValue];
}

- (void)encodeInt8:(NUInt8)aValue
{
    [self encodeUInt8:aValue];
}

- (void)encodeInt16:(NUInt16)aValue
{
    [self encodeUInt16:aValue];
}

- (void)encodeInt32:(NUInt32)aValue
{
    [self encodeUInt32:aValue];
}

- (void)encodeInt64:(NUInt64)aValue
{
    [[self currentContext] encodeUInt64:aValue];
}

- (void)encodeUInt8:(NUUInt8)aValue
{
	[[self currentContext] encodeUInt8:aValue];
}

- (void)encodeUInt16:(NUUInt16)aValue
{
    [[self currentContext] encodeUInt16:aValue];
}

- (void)encodeUInt32:(NUUInt32)aValue
{
	[[self currentContext] encodeUInt32:aValue];
}

- (void)encodeUInt64:(NUUInt64)aValue
{
	[[self currentContext] encodeUInt64:aValue];
}

- (void)encodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount
{
    [[self currentContext] encodeUInt64Array:aValues count:aCount];
}

- (void)encodeFloat:(NUFloat)aValue
{
    [[self currentContext] encodeFloat:aValue];
}

- (void)encodeDouble:(NUDouble)aValue
{
	[[self currentContext] encodeDouble:aValue];
}

- (void)encodeRegion:(NURegion)aValue
{
    [[self currentContext] encodeRegion:aValue];
}

- (void)encodeRange:(NSRange)aValue
{
    [[self currentContext] encodeRange:aValue];
}

- (void)encodePoint:(NSPoint)aValue
{
    [[self currentContext] encodePoint:aValue];
}

- (void)encodeSize:(NSSize)aValue
{
    [[self currentContext] encodeSize:aValue];
}

- (void)encodeRect:(NSRect)aValue
{
    [[self currentContext] encodeRect:aValue];
}

- (void)encodeObject:(id)anObject forKey:(NSString *)aKey
{
    [self encodeUInt64:[self preEncodeObject:anObject] forKey:aKey];
}

- (void)encodeInt8:(NUInt8)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeUInt8:aValue forKey:aKey];
}

- (void)encodeInt16:(NUInt16)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeUInt16:aValue forKey:aKey];
}

- (void)encodeInt32:(NUInt32)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeUInt32:aValue forKey:aKey];
}

- (void)encodeInt64:(NUInt64)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeUInt64:aValue forKey:aKey];
}

- (void)encodeUInt8:(NUUInt8)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeUInt8:aValue forKey:aKey];
}

- (void)encodeUInt16:(NUUInt16)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeUInt16:aValue forKey:aKey];
}

- (void)encodeUInt32:(NUUInt32)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeUInt32:aValue forKey:aKey];
}

- (void)encodeUInt64:(NUUInt64)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeUInt64:aValue forKey:aKey];
}

- (void)encodeFloat:(NUFloat)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeFloat:aValue forKey:aKey];
}

- (void)encodeDouble:(NUDouble)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeDouble:aValue forKey:aKey];
}

- (void)encodeBOOL:(BOOL)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeBOOL:aValue forKey:aKey];
}

- (void)encodeRegion:(NURegion)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeRegion:aValue forKey:aKey];
}

- (void)encodeRange:(NSRange)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeRange:aValue forKey:aKey];
}

- (void)encodePoint:(NSPoint)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodePoint:aValue forKey:aKey];
}

- (void)encodeSize:(NSSize)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeSize:aValue forKey:aKey];
}

- (void)encodeRect:(NSRect)aValue forKey:(NSString *)aKey
{
    [[self currentContext] encodeRect:aValue forKey:aKey];
}

- (void)encodeIndexedIvars:(id *)anIndexedIvars count:(NUUInt64)aCount
{
    NUCodingContext *aContext = [self currentContext];
    [aContext setIsIndexed:YES];
	
	for (NUUInt64 i = 0; i < aCount; i++)
		[self encodeObject:anIndexedIvars[i]];
    
    [aContext setIsIndexed:NO];
}

- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount
{
    [[self currentContext] setIsIndexed:YES];
    [[self currentContext] encodeIndexedBytes:aBytes count:aCount];
    [[self currentContext] setIsIndexed:NO];
}

- (void)encodeIndexedBytes:(const NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)anOffset
{
    [[self currentContext] setIsIndexed:YES];
    [[self currentContext] encodeIndexedBytes:aBytes count:aCount at:anOffset];
    [[self currentContext] setIsIndexed:NO];
}

@end

@implementation NUAliaser (Decoding)

- (NSMutableArray *)decodeRoots
{
	return [self decodeObjectsFromStarter];
}

- (NSMutableArray *)decodeObjectsFromStarter
{
	NSMutableArray *anObjects = [NSMutableArray array];
	NUUInt32 i = 0;
	
	for (; i < [rootOOPs count]; i++)
	{
		NUUInt64 aRawOOP = [rootOOPs indexAt:i];
		[anObjects addObject:[self decodeObjectForOOP:aRawOOP really:YES]];
	}
	
	return anObjects;
}

- (id)decodeObject
{
	return [self decodeObjectForOOP:[self decodeUInt64] really:NO];
}

- (id)decodeObjectReally
{
    NUUInt64 anOOP = [self decodeUInt64];
	return [self decodeObjectForOOP:anOOP really:YES];
}

- (id)decodeObjectForOOP:(NUUInt64)anOOP really:(BOOL)aReallyDecode
{
	if (anOOP == NUNilOOP) return nil;

	NUBell *aBell = [[self garden] bellForOOP:anOOP];
	if (!aBell) aBell = [[self garden] allocateBellForBellBall:NUMakeBellBall(anOOP, NUNilGrade)];
    [aBell setGradeAtCallFor:[self grade]];
	
	if (aReallyDecode)
		return [aBell hasObject] ? [aBell object] : [self decodeObjectForBell:aBell];
	else
		return [aBell hasObject] ? [aBell object] : aBell;
}

- (id)decodeObjectForBell:(NUBell *)aBell
{
    [self prepareCodingContextForDecode:aBell];
    return [self decodeObjectForBell:aBell classOOP:[self decodeUInt64]];
}

- (void)prepareCodingContextForDecode:(NUBell *)aBell
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
}

- (id)decodeObjectForBell:(NUBell *)aBell classOOP:(NUUInt64)aClassOOP
{
	id anObject = nil;
	NUCharacter *aCharacter = [[self garden] objectForOOP:aClassOOP];
    
    [self ensureCharacterForDecoding:aCharacter];
    [[self currentContext] setCharacter:aCharacter];
	
	if ([aCharacter isVariable])
    {
        [self setIndexedIvarOffset:[aCharacter indexedIvarOffset]];
        [self setIndexedIvarsSize:[self decodeUInt64]];
    }
    
	if ([aCharacter coderClass])
	{
		NUCoder *aCoder = [aCharacter coder];
		
		if ([aCharacter isMutable])
		{
			anObject = [aCoder new];
			[[self garden] setObject:anObject forBell:aBell];
			[aCoder decode:anObject withAliaser:self];
		}
		else
		{
			anObject = [[aCoder decodeObjectWithAliaser:self] retain];
			[[self garden] setObject:anObject forBell:aBell];
		}
	}
	else
	{
		anObject = [[aCharacter targetClass] new];
		[[self garden] setObject:anObject forBell:aBell];
		[anObject initWithAliaser:self];
	}
	
	[self popContext];
    
    [aBell setIsLoaded:YES];
    [[[self garden] gradeSeeker] bellDidLoadIvars:aBell];
    
	return [anObject autorelease];
}

- (void)ensureCharacterForDecoding:(NUCharacter *)aCharacter
{
    if (![aCharacter targetClass] && ![aCharacter coderClass])
    {
        Class aClass = NSClassFromString([aCharacter name]);
        if (aClass && [aClass conformsToProtocol:@protocol(NUCoding)])
            [aCharacter setTargetClass:aClass];
    }
    
    if (![aCharacter targetClass] && ![aCharacter coderClass])
        [[NSException exceptionWithName:NUAliaserCannotDecodeObjectException reason:NUAliaserCannotDecodeObjectException userInfo:nil] raise];
}

- (BOOL)decodeBOOL
{
    return [[self currentContext] decodeBOOL];
}

- (NUInt8)decodeInt8
{
    return [self decodeUInt8];
}

- (NUInt16)decodeInt16
{
    return [self decodeUInt16];
}

- (NUInt16)decodeInt32
{
    return [self decodeUInt32];
}

- (NUInt64)decodeInt64
{
    return [[self currentContext] decodeInt64];
}

- (NUUInt8)decodeUInt8
{
	return [[self currentContext] decodeUInt8];
}

- (NUUInt16)decodeUInt16
{
    return [[self currentContext] decodeUInt16];
}

- (NUUInt32)decodeUInt32
{
	return [[self currentContext] decodeUInt32];
}

- (NUUInt64)decodeUInt64
{
	return [[self currentContext] decodeUInt64];
}

- (void)decodeUInt64Array:(NUUInt64 *)aValues count:(NUUInt64)aCount
{
    [[self currentContext] decodeUInt64Array:aValues count:aCount];
}

- (NUFloat)decodeFloat
{
    return [[self currentContext] decodeFloat];
}

- (NUDouble)decodeDouble
{
	return [[self currentContext] decodeDouble];
}

- (NURegion)decodeRegion
{
    return [[self currentContext] decodeRegion];
}

- (NSRange)decodeRange
{
    return [[self currentContext] decodeRange];
}

- (NSPoint)decodePoint
{
    return [[self currentContext] decodePoint];
}

- (NSSize)decodeSize
{
    return [[self currentContext] decodeSize];
}

- (NSRect)decodeRect
{
    return [[self currentContext] decodeRect];
}

- (id)decodeObjectForKey:(NSString *)aKey
{
    return [self decodeObjectForOOP:[self decodeUInt64ForKey:aKey] really:NO];
}

- (NUInt8)decodeInt8ForKey:(NSString *)aKey
{
    return [[self currentContext] decodeUInt8ForKey:aKey];
}

- (NUInt16)decodeInt16ForKey:(NSString *)aKey
{
    return [[self currentContext] decodeUInt16ForKey:aKey];
}

- (NUInt32)decodeInt32ForKey:(NSString *)aKey
{
    return [[self currentContext] decodeUInt32ForKey:aKey];
}

- (NUInt64)decodeInt64ForKey:(NSString *)aKey
{
    return [[self currentContext] decodeUInt64ForKey:aKey];
}

- (NUUInt8)decodeUInt8ForKey:(NSString *)aKey
{
    return [[self currentContext] decodeUInt8ForKey:aKey];
}

- (NUUInt16)decodeUInt16ForKey:(NSString *)aKey
{
    return [[self currentContext] decodeUInt16ForKey:aKey];
}

- (NUUInt32)decodeUInt32ForKey:(NSString *)aKey
{
    return [[self currentContext] decodeUInt32ForKey:aKey];
}

- (NUUInt64)decodeUInt64ForKey:(NSString *)aKey
{
    return [[self currentContext] decodeUInt64ForKey:aKey];
}

- (NUFloat)decodeFloatForKey:(NSString *)aKey
{
    return [[self currentContext] decodeFloatForKey:aKey];
}

- (NUDouble)decodeDoubleForKey:(NSString *)aKey
{
    return [[self currentContext] decodeDoubleForKey:aKey];
}

- (BOOL)decodeBOOLForKey:(NSString *)aKey
{
    return [[self currentContext] decodeBOOLForKey:aKey];
}

- (NURegion)decodeRegionForKey:(NSString *)aKey
{
    return [[self currentContext] decodeRegionForKey:aKey];
}

- (NSRange)decodeRangeForKey:(NSString *)aKey
{
    return [[self currentContext] decodeRangeForKey:aKey];
}

- (NSPoint)decodePointForKey:(NSString *)aKey
{
    return [[self currentContext] decodePointForKey:aKey];
}

- (NSSize)decodeSizeForKey:(NSString *)aKey
{
    return [[self currentContext] decodeSizeForKey:aKey];
}

- (NSRect)decodeRectForKey:(NSString *)aKey
{
    return [[self currentContext] decodeRectForKey:aKey];
}

- (void)decodeIndexedIvar:(id *)anIndexedIvars count:(NUUInt64)aCount really:(BOOL)aReallyDecode
{
	NUUInt64 *aValues = malloc(sizeof(NUUInt64) * aCount);
	NUUInt64 i = 0;
	
    [[self currentContext] setIsIndexed:YES];
    [self decodeUInt64Array:aValues count:aCount];
    [[self currentContext] setIsIndexed:NO];
    
	for (; i < aCount; i++) anIndexedIvars[i] = [self decodeObjectForOOP:aValues[i] really:aReallyDecode];
	free(aValues);
}

- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount
{
	[[self currentContext] decodeBytes:aBytes count:aCount];
}

- (void)decodeBytes:(NUUInt8 *)aBytes count:(NUUInt64)aCount at:(NUUInt64)aLocation
{
    [[self currentContext] decodeBytes:aBytes count:aCount at:aLocation];
}

- (void)moveUp:(id)anObject
{
    [self moveUp:anObject ignoreGradeAtCallFor:YES];
}

- (void)moveUp:(id)anObject ignoreGradeAtCallFor:(BOOL)anIgnoreFlag
{
    if ([anObject isBell]) return;
    NUBell *aBell = [[self garden] bellForObject:anObject];
    if (!aBell) return;
    if (!anIgnoreFlag && [aBell gradeAtCallFor] == [self grade]) return;
    
    [aBell setGrade:NUNilGrade];
    [self prepareCodingContextForMoveUp:aBell];
    
    NUUInt64 aClassOOP = [self decodeUInt64];
    NUCharacter *aCharacter = [[self garden] objectForOOP:aClassOOP];
    
    if (![aCharacter isMutable]) return;
    [[self currentContext] setCharacter:aCharacter];
    
    if ([aCharacter coderClass] && ![[aCharacter coder] canMoveUpObject:anObject withAliaser:self]) return;
    if (![aCharacter coderClass] && ![anObject conformsToProtocol:@protocol(NUMovingUp)]) return;
    
    if ([aCharacter isVariable])
    {
        [self setIndexedIvarOffset:[aCharacter indexedIvarOffset]];
        [self setIndexedIvarsSize:[self decodeUInt64]];
    }
    
    if ([aCharacter coderClass])
        [[aCharacter coder] moveUpObject:anObject withAliaser:self];
    else
        [anObject moveUpWithAliaser:self];
    
    [self popContext];
    
    [[[self garden] gradeSeeker] bellDidLoadIvars:aBell];
}

- (void)prepareCodingContextForMoveUp:(NUBell *)aBell
{
    [self prepareCodingContextForDecode:aBell];
}

- (NUUInt64)objectLocationForBell:(NUBell *)aBell gradeInto:(NUUInt64 *)aGrade
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
}

@end

@implementation NUAliaser (ObjectSpace)

- (NUUInt64)computeSizeOfObject:(id)anObject
{
	NUCharacter *aCharacter = [[anObject classForNursery] characterOn:[self garden]];
	NUUInt64 aSize = [aCharacter basicSize];
	
	if ([aCharacter isVariable])
	{
		aSize += [anObject indexedIvarsSize];
	}
    
	return aSize;
}

@end

@implementation NUAliaser (Pupil)

- (void)fixProbationaryOOPsInPupil:(NUPupilNote *)aPupilNote
{
//#ifdef DEBUG
//    NSLog(@"#fixProbationaryOOPsInPupil:%@", aPupilNote);
//#endif
    NUUInt64 aCharacterOOP = [aPupilNote isa];
    NUCharacter *aCharacter = [[self garden] objectForOOP:aCharacterOOP];
    
    for (NSUInteger i = 0; i < [aCharacter allOOPIvarsCount]; i++)
    {
        NUIvar *anIvar = [aCharacter ivarInAllOOPIvarsAt:i];
        [self fixProbationaryOOPAtOffset:[anIvar offset] inPupil:aPupilNote character:aCharacter];
    }
    
    if ([aCharacter isIndexedIvars] || [aCharacter isFixedAndIndexedIvars])
    {
        NUUInt64 anIndexedOOPCount = [aPupilNote readUInt64At:sizeof(NUUInt64)] / sizeof(NUUInt64);
        
        for (NUUInt64 i = 0; i < anIndexedOOPCount; i++)
        {
            NUUInt64 anIvarOffset = [aCharacter indexedIvarOffset] + sizeof(NUUInt64) * i;
            [self fixProbationaryOOPAtOffset:anIvarOffset inPupil:aPupilNote character:aCharacter];
        }
    }
}

- (void)fixProbationaryOOPAtOffset:(NUUInt64)anIvarOffset inPupil:(NUPupilNote *)aPupilNote character:(NUCharacter *)aCharacter
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
}

@end
