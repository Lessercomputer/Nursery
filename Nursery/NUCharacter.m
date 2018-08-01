//
//  NUCharacter.m
//  Nursery
//
//  Created by Akifumi Takata on 11/02/08.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSArray.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSString.h>
#import <Foundation/NSException.h>

#import "NUCharacter.h"
#import "NUCharacter+Project.h"
#import "NUBell.h"
#import "NUIvar.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUAliaser.h"
#import "NUCoder.h"

const NUObjectFormat NUFixedIvars = 1;
const NUObjectFormat NUIndexedIvars = 2;
const NUObjectFormat NUFixedAndIndexedIvars = 3;
const NUObjectFormat NUIndexedBytes = 4;

NSString *NUCharacterIvarAlreadyExistsException = @"NUCharacterIvarAlreadyExistsException";
NSString *NUCharacterInvalidObjectFormatException = @"NUCharacterInvalidObjectFormatException";

@implementation NUCharacter

+ (id)characterWithName:(NSString *)aName super:(NUCharacter *)aSuper
{
	return [[[self alloc] initWithName:aName super:aSuper] autorelease];
}

- (id)initWithName:(NSString *)aName super:(NUCharacter *)aSuper
{
	if (self = [super init])
    {
        lock = [NSRecursiveLock new];
        [self setName:aName];
        [self setSuperCharacter:aSuper];
        [self setFormat:NUFixedIvars];
        [self setIvars:[NSMutableArray array]];
        subCharacters = [NSMutableSet new];
        needsComputeBasicSize = YES;
        [self setIsMutable:YES];
        needsComputeIvarOffset = YES;
        needsComputeIndexedIvarOffset = YES;
    }
    
	return self;
}

- (void)dealloc
{
	[self setName:nil];
	[self setIvars:nil];
	[subCharacters release];
    [allIvarDictionary release];
    [lock release];
	
	[super dealloc];
}

- (NUCharacter *)superCharacter
{
	return superCharacter;
}

- (void)setSuperCharacter:(NUCharacter *)aSuper
{
	superCharacter = aSuper;
}

- (NUObjectFormat)format
{
	return format;
}

- (void)setFormat:(NUObjectFormat)aFormat
{
	format = aFormat;
}

- (NUUInt32)version
{
	return version;
}

- (void)setVersion:(NUUInt32)aVersion
{
	version = aVersion;
}

- (NSString *)name
{
	return name;
}

- (void)setName:(NSString *)aName
{
	[name autorelease];
	name = [aName copy];
}

- (NSMutableArray *)ivars
{
	return ivars;
}

- (void)setIvars:(NSMutableArray *)anIvars
{
	[ivars autorelease];
	ivars = [anIvars retain];
}

- (void)addIvar:(NUIvar *)anIvar
{
    if ([self containsIvarWithName:[anIvar name]])
        @throw [NSException exceptionWithName:NUCharacterIvarAlreadyExistsException reason:NUCharacterIvarAlreadyExistsException userInfo:nil];
    
	[[self ivars] addObject:anIvar];
}

- (void)addOOPIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUOOPIvarType];
}

- (void)addInt8IvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUInt8IvarType];
}

- (void)addInt16IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUInt16IvarType];
}

- (void)addInt32IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUInt32IvarType];
}

- (void)addInt64IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUInt64IvarType];
}

- (void)addUInt8IvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUUInt8IvarType];
}

- (void)addUInt16IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUUInt16IvarType];
}

- (void)addUInt32IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUUInt32IvarType];
}

- (void)addUInt64IvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUUInt64IvarType];
}

- (void)addFloatIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUFloatIvarType];
}

- (void)addDoubleIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUDoubleIvarType];
}

- (void)addBOOLIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUBOOLIvarType];
}

- (void)addRangeIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUNSRangeIvarType];
}

- (void)addPointIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUNSPointIvarType];
}

- (void)addSizeIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUNSSizeIvarType];
}

- (void)addRectIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUNSRectIvarType];
}

- (void)addIvarWithName:(NSString *)aName type:(NUIvarType)aType
{
    [self addIvar:[NUIvar ivarWithName:aName type:aType]];
}

- (void)setAllOOPIvars:(NSArray *)anOOPIvars
{
	[allOOPIvars autorelease];
	allOOPIvars = [anOOPIvars copy];
}

- (NSArray *)allOOPIvars
{
    [lock lock];
	if (!allOOPIvars) [self setAllOOPIvars:[self getAllOOPIvars]];
    [lock unlock];
    
	return allOOPIvars;
}

- (NSUInteger)allOOPIvarsCount
{
    [lock lock];
    NSUInteger aCount = [[self allOOPIvars] count];
    [lock unlock];
    return aCount;
}

- (NUIvar *)ivarInAllOOPIvarsAt:(NSUInteger)anIndex
{
    [lock lock];
    NUIvar *anIvar = [[self allOOPIvars] objectAtIndex:anIndex];
    [lock unlock];
    return anIvar;
}

- (NSArray *)getAllOOPIvars
{
    [lock lock];
    
	NSMutableArray *anIvars = [NSMutableArray array];
	NSEnumerator *anEnumerator = [[self allIvars] objectEnumerator];
	NUIvar *anIvar = nil;
	
	while (anIvar = [anEnumerator nextObject])
		if ([anIvar type] == NUOOPIvarType)
			[anIvars addObject:anIvar];
	
    [lock unlock];
    
	return [[anIvars copy] autorelease];
}

- (NSArray *)copyAllIvars
{
    NSMutableArray *aCopiedAllIvars = [NSMutableArray array];
    
    @try
    {
        [lock lock];
        
        [[self allIvars] enumerateObjectsUsingBlock:^(NUIvar *anIvar, NSUInteger anIndex, BOOL *aStop) {
            [aCopiedAllIvars addObject:[[anIvar copy] autorelease]];
        }];
        
    }
    @finally
    {
        [lock unlock];
    }
    
    return [aCopiedAllIvars copy];
}

- (NSArray *)allIvars
{
    [lock lock];
	if (!allIvars) [self setAllIvars:[self getAllIvars]];
    [lock unlock];
    
	return allIvars;
}

- (NSDictionary *)allIvarDictionary
{
    @try {
        [lock lock];
        
        if (!allIvarDictionary)
            allIvarDictionary = [[self allIvarDictionaryFrom:[self allIvars]] copy];
    }
    @finally {
        [lock unlock];
    }
    
    return allIvarDictionary;
}

- (void)setAllIvars:(NSArray *)anIvars
{
    [lock lock];
	[allIvars autorelease];
	allIvars = [anIvars copy];
    [lock unlock];
}

- (NSArray *)getAllIvars
{
    NSMutableArray *anAllIvars;
    
    @try {
        [lock lock];

        NSArray *anAllIvarsOfSuper = [[[self superCharacter] copyAllIvars] autorelease];
        if (!anAllIvarsOfSuper) anAllIvarsOfSuper = [NSMutableArray array];
        NSEnumerator *anEnumerator = [[self ivars] objectEnumerator];
        NUIvar *anIvar = nil;
        anAllIvars = [[anAllIvarsOfSuper mutableCopy] autorelease];
        
        while (anIvar = [anEnumerator nextObject])
            [anAllIvars addObject:[[anIvar copy] autorelease]];
        
        if ([self isVariable])
        {
            if ([anAllIvars count] == 1 || ![[[anAllIvars objectAtIndex:1] name] isEqualToString:@"indexedIvarsSize"])
                [anAllIvars insertObject:[NUIvar ivarWithName:@"indexedIvarsSize" type:NUUInt64IvarType] atIndex:1];
        }
    }
    @finally {
        [lock unlock];
    }
    
    return [[anAllIvars copy] autorelease];
}

- (NSDictionary *)allIvarDictionaryFrom:(NSArray *)anIvars
{
    NSMutableDictionary *aDictionary = [NSMutableDictionary dictionary];
    
    [anIvars enumerateObjectsUsingBlock:^(NUIvar *anIvar, NSUInteger idx, BOOL *stop) {
        [aDictionary setObject:anIvar forKey:[anIvar name]];
    }];
    
    return [[aDictionary copy] autorelease];
}

- (NUIvar *)ivarInAllIvarsAt:(NSUInteger)anIndex
{
    NUIvar *anIvar;
    
    @try
    {
        [lock lock];
        
        anIvar = [[self allIvars] objectAtIndex:anIndex];
    }
    @finally
    {
        [lock unlock];
    }
    
    return anIvar;
}

- (NUUInt64)ivarOffsetForName:(NSString *)aName
{
    NUUInt64 anIvarOffset;
    
    @try
    {
        [lock lock];
        
        anIvarOffset = [[[self allIvarDictionary] objectForKey:aName] offset];
    }
    @finally
    {
        [lock unlock];
    }
    
    return anIvarOffset;
}

- (NSArray *)ancestors
{
	NSMutableArray *aCharacters = [NSMutableArray array];
	NUCharacter *aCharacter = nil;
	
	while ((aCharacter = [self superCharacter]))
		[aCharacters addObject:aCharacter];

	return [[aCharacters reverseObjectEnumerator] allObjects];
}

- (NSMutableSet *)subCharacters
{
    return NUGetIvar(&subCharacters);
}

- (void)setSubCharacters:(NSMutableSet *)aSubCharacters
{
    NUSetIvar(&subCharacters, aSubCharacters);
}

- (void)addSubCharacter:(NUCharacter *)aCharacter
{
    @try
    {
        [lock lock];
        
        if (![[self subCharacters] containsObject:aCharacter])
        {
            [[self subCharacters] addObject:aCharacter];
            [[[self bell] garden] markChangedObject:[self subCharacters]];
        }
    }
    @finally
    {
        [lock unlock];
    }
}

- (void)removeSubCharacter:(NUCharacter *)aCharacter
{
    @try
    {
        [lock lock];
        
        if ([[self subCharacters] containsObject:aCharacter])
        {
            [[self subCharacters] removeObject:aCharacter];
            [[[self bell] garden] markChangedObject:[self subCharacters]];
        }
    }
    @finally
    {
        [lock unlock];
    }
}

- (void)addToSuperCharacter
{
    [[self superCharacter] addSubCharacter:self];
}

- (void)removeFromSuperCharacter
{
    [[self superCharacter] removeSubCharacter:self];
}

- (NUUInt64)basicSize
{
	return needsComputeBasicSize ? [self computeBasicSize] : basicSize;
}

- (NUUInt64)computeBasicSize
{
	__block NUUInt64 aSize = 0;
    [[self allIvars] enumerateObjectsUsingBlock:^(NUIvar * _Nonnull anIvar, NSUInteger idx, BOOL * _Nonnull stop)
    {
        aSize += [anIvar sizeInBytes];
    }];
    
	basicSize = aSize;
	
	return aSize;
}

- (void)computeIvarOffset
{
	if (needsComputeIvarOffset)
	{
		NUUInt64 anOffset = 0;
		NSEnumerator *anEnumerator = [[self allIvars] objectEnumerator];
		NUIvar *anIvar = nil;
		
		while (anIvar = [anEnumerator nextObject])
		{
			[anIvar setOffset:anOffset];
			anOffset += [anIvar sizeInBytes];
		}
		
		needsComputeIvarOffset = NO;
	}
}

- (NUUInt64)indexedIvarOffset
{
    [lock lock];
    
	if (needsComputeIndexedIvarOffset)
	{
		NSEnumerator *anEnumerator = [[self allIvars] objectEnumerator];
		NUIvar *anIvar = nil;
		indexedIvarOffset = 0;
		
		while (anIvar = [anEnumerator nextObject])
			indexedIvarOffset += [anIvar sizeInBytes];
			
		needsComputeIndexedIvarOffset = NO;
	}
	
    [lock unlock];
    
	return indexedIvarOffset;
}

- (NUBell *)bell
{
	return bell;
}

- (void)setBell:(NUBell *)aBell
{
	bell = aBell;
}

- (NSString *)nameWithVersion
{
    return [NSString stringWithFormat:@"%@#%d", [self name], [self version]];
}

- (NSString *)inheritanceNameWithVersion
{
	if (!inheritanceName) [self setInheritanceNameWithVersion:[self getInheritanceNameWithVersion]];
	return inheritanceName;
}

- (NSString *)getInheritanceNameWithVersion
{
	NSMutableString *anInheritanceNameWithVersion;
	
 	if ([self isRoot])
		anInheritanceNameWithVersion = [[[self name] mutableCopy] autorelease];
	else
	{
		anInheritanceNameWithVersion = [[[[self superCharacter] inheritanceNameWithVersion] mutableCopy] autorelease];
		[anInheritanceNameWithVersion appendString:@"!"];
		[anInheritanceNameWithVersion appendString:[self name]];
	}
	
	[anInheritanceNameWithVersion appendFormat:@"#%d", [self version]];
	
	return anInheritanceNameWithVersion;
}

- (void)setInheritanceNameWithVersion:(NSString *)anInheritanceNameWithVersion
{
	[inheritanceName autorelease];
	inheritanceName = [anInheritanceNameWithVersion copy];
}

- (Class)targetClass
{
	return targetClass;
}

- (void)setTargetClass:(Class)aClass
{
    [targetClass autorelease];
	targetClass = [aClass retain];
}

- (Class)coderClass
{
	return coderClass;
}

- (void)setCoderClass:(Class)aClass
{
	coderClass = aClass;
}

- (NUCoder *)coder
{
    NUCoder *aCoder;
    
    [lock lock];
    
    if (!coder)
        [self setCoder:[coderClass coder]];
    
    aCoder = coder;
    
    [lock unlock];
    
    return aCoder;
}

- (void)setCoder:(NUCoder *)aCoder
{
    [lock lock];
    
    [coder autorelease];
    coder = [aCoder retain];
    
    [lock unlock];
}

- (BOOL)isMutable
{
	return isMutable;
}

- (void)setIsMutable:(BOOL)aMutableFlag
{
	isMutable = aMutableFlag;
}

- (BOOL)isEqual:(id)object
{
	if (self == object) return YES;
	if ([object isKindOfClass:[NUCharacter class]])
		return [self isEqualToCharacter:object];
	return NO;
}

- (BOOL)isEqualToCharacter:(NUCharacter *)aCharacter
{
	if ([super isEqual:aCharacter]) return YES;
	
	if (![self isRoot] && ![[self superCharacter] isEqual:[aCharacter superCharacter]]) return NO;
	if (![[self name] isEqualToString:[aCharacter name]]) return NO;
	if ([self format] != [aCharacter format]) return NO;
	if (![[self ivars] isEqualToArray:[aCharacter ivars]]) return NO;
	
	return YES;
}

- (BOOL)isRoot
{
	return [self superCharacter] ? NO : YES;
}

- (BOOL)formatIsValid
{
    return [self formatIsValid:[self format]];
}

- (BOOL)formatIsValid:(NUObjectFormat)anObjectFormat
{
    if ([self isRoot]) return YES;
    
    NUObjectFormat aSuperCharacterFormat = [[self superCharacter] format];
    
    if (anObjectFormat == NUFixedIvars && aSuperCharacterFormat != NUFixedIvars)
        return NO;
    
    if (anObjectFormat == NUIndexedIvars && !(aSuperCharacterFormat == NUFixedIvars || aSuperCharacterFormat == NUIndexedIvars))
        return NO;
    
    if (anObjectFormat == NUFixedAndIndexedIvars && aSuperCharacterFormat != NUFixedIvars)
        return NO;
    
    if (anObjectFormat == NUIndexedBytes && !(aSuperCharacterFormat == NUFixedIvars || aSuperCharacterFormat == NUIndexedBytes))
        return NO;
    
    return YES;
}

- (BOOL)isFixedIvars
{
	return [self format] == NUFixedIvars;
}

- (BOOL)isVariable
{
	return [self isIndexedIvars] || [self isFixedAndIndexedIvars] || [self isIndexedBytes];
}

- (BOOL)isIndexedIvars
{
	return [self format] == NUIndexedIvars;
}

- (BOOL)isFixedAndIndexedIvars
{
	return [self format] == NUFixedAndIndexedIvars;
}

- (BOOL)isIndexedBytes
{
	return [self format] == NUIndexedBytes;
}

- (BOOL)containsIvarWithName:(NSString *)aName
{
    __block BOOL anIvarNameContained = NO;
    
    @try
    {
        [lock lock];
        
        if (allIvarDictionary)
        {
            anIvarNameContained = [allIvarDictionary objectForKey:aName] ? YES : NO;
        }
        else
        {
            if ([[self superCharacter] containsIvarWithName:aName])
                anIvarNameContained = NO;
            else
                [[self ivars] enumerateObjectsUsingBlock:^(NUIvar *anIvar, NSUInteger anIndex, BOOL *aStop) {
                    if ([[anIvar name] isEqualToString:aName])
                    {
                        anIvarNameContained = YES;
                        *aStop = YES;
                    }
                }];
        }
    }
    @finally
    {
        [lock unlock];
    }
    
    return anIvarNameContained;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    if ([self isEqual:[NUCharacter class]])
	{
		[aCharacter setFormat:NUFixedIvars];
		[aCharacter addIvar:[NUIvar ivarWithName:@"superCharacter" type:NUOOPIvarType]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"format" type:NUUInt8IvarType]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"version" type:NUUInt32IvarType]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"name" type:NUOOPIvarType]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"ivars" type:NUOOPIvarType]];
        [aCharacter addIvar:[NUIvar ivarWithName:@"isMutable" type:NUBOOLIvarType]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"subCharacters" type:NUOOPIvarType]];
	}
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
	[anAliaser encodeObject:superCharacter];
	[anAliaser encodeUInt8:format];
	[anAliaser encodeUInt32:version];
	[anAliaser encodeObject:name];
	[anAliaser encodeObject:ivars];
    [anAliaser encodeBOOL:isMutable];
	[anAliaser encodeObject:subCharacters];
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    lock = [NSRecursiveLock new];
	[self setSuperCharacter:[anAliaser decodeObjectReally]];
	[self setFormat:[anAliaser decodeUInt8]];
	[self setVersion:[anAliaser decodeUInt32]];
	[self setName:[anAliaser decodeObjectReally]];
	[self setIvars:[anAliaser decodeObjectReally]];
    [self setIsMutable:[anAliaser decodeBOOL]];
	[self setSubCharacters:[anAliaser decodeObjectReally]];
    needsComputeBasicSize = YES;
	needsComputeIvarOffset = YES;
	needsComputeIndexedIvarOffset = YES;
    [self basicSize];
    [self computeIvarOffset];
    [self indexedIvarOffset];

	return self;
}

- (void)moveUpWithAliaser:(NUAliaser *)anAliaser
{
    @try
    {
        [lock lock];
        
        [self setSuperCharacter:[anAliaser decodeObjectReally]];
        [self setFormat:[anAliaser decodeUInt8]];
        [self setVersion:[anAliaser decodeUInt32]];
        [self setName:[anAliaser decodeObjectReally]];
        [self setIvars:[anAliaser decodeObjectReally]];
        [self setIsMutable:[anAliaser decodeBOOL]];
        [self setSubCharacters:[anAliaser decodeObjectReally]];
        needsComputeBasicSize = YES;
        needsComputeIvarOffset = YES;
        needsComputeIndexedIvarOffset = YES;
        [self basicSize];
        [self computeIvarOffset];
        [self indexedIvarOffset];
    }
    @finally
    {
        [lock unlock];
    }
}

- (void)moveUp
{
    [[[[self bell] garden] aliaser] moveUp:self ignoreGradeAtCallFor:YES];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@(%@): %p>", [self class], [self name], self];
}

@end
