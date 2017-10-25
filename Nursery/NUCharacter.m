//
//  NUCharacter.m
//  Nursery
//
//  Created by P,T,A on 11/02/08.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUCharacter.h"
#import "NUBell.h"
#import "NUIvar.h"
#import "NUPlayLot.h"
#import "NUAliaser.h"
#import "NUCoder.h"

const NUObjectFormat NUFixedIvars = 1;
const NUObjectFormat NUIndexedIvars = 2;
const NUObjectFormat NUFixedAndIndexedIvars = 3;
const NUObjectFormat NUIndexedBytes = 4;

NSString *NUCharacterIvarAlreadyExistsException = @"NUCharacterIvarAlreadyExistsException";
NSString *NUCharacterInvalidObjectFormatException = @"NUCharacterInvalidObjectFormatException";

@implementation NUCharacter

+ (id)character
{
	return [[[self alloc] initWithName:nil super:nil] autorelease];
}

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
    [self addIvarWithName:aName type:NUOOPType];
}

- (void)addInt8IvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUInt8Type];
}

- (void)addInt16IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUInt16Type];
}

- (void)addInt32IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUInt32Type];
}

- (void)addInt64IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUInt64Type];
}

- (void)addUInt8IvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUUInt8Type];
}

- (void)addUInt16IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUUInt16Type];
}

- (void)addUInt32IvarName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUUInt32Type];
}

- (void)addUInt64IvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUUInt64Type];
}

- (void)addUInt64ArrayIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUUInt64ArrayType];
}

- (void)addFloatIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUFloatType];
}

- (void)addDoubleIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUDoubleType];
}

- (void)addBOOLIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUBOOLType];
}

- (void)addRangeIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUNSRangeType];
}

- (void)addPointIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUNSPointType];
}

- (void)addSizeIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUNSSizeType];
}

- (void)addRectIvarWithName:(NSString *)aName
{
    [self addIvarWithName:aName type:NUNSRectType];
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
		if ([anIvar type] == NUOOPType)
			[anIvars addObject:anIvar];
	
    [lock unlock];
    
	return [[anIvars copy] autorelease];
}

- (NSArray *)copyAllIvars
{
    NSMutableArray *aCopiedAllIvars = [NSMutableArray array];
    [lock lock];
    
    @try
    {
        [[self allIvars] enumerateObjectsUsingBlock:^(NUIvar *anIvar, NSUInteger anIndex, BOOL *aStop) {
            [aCopiedAllIvars addObject:[[anIvar copy] autorelease]];
        }];
        
        return [aCopiedAllIvars copy];
    }
    @finally
    {
        [lock unlock];
    }
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
    [lock lock];
    @try {
        if (!allIvarDictionary)
            allIvarDictionary = [[self allIvarDictionaryFrom:[self allIvars]] copy];
        return allIvarDictionary;
    }
    @finally {
        [lock unlock];
    }
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
    [lock lock];
    @try {
        NSArray *anAllIvarsOfSuper = [[[self superCharacter] copyAllIvars] autorelease];
        if (!anAllIvarsOfSuper) anAllIvarsOfSuper = [NSMutableArray array];
        NSEnumerator *anEnumerator = [[self ivars] objectEnumerator];
        NUIvar *anIvar = nil;
        NSMutableArray *anAllIvars = [[anAllIvarsOfSuper mutableCopy] autorelease];
        
        while (anIvar = [anEnumerator nextObject])
            [anAllIvars addObject:[[anIvar copy] autorelease]];
        
        if ([self isVariable])
        {
            if ([anAllIvars count] == 1 || ![[[anAllIvars objectAtIndex:1] name] isEqualToString:@"indexedIvarsSize"])
                [anAllIvars insertObject:[NUIvar ivarWithName:@"indexedIvarsSize" type:NUUInt64Type] atIndex:1];
        }
            
        return [[anAllIvars copy] autorelease];
    }
    @finally {
        [lock unlock];
    }
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
    @try
    {
        [lock lock];
        
        return [[self allIvars] objectAtIndex:anIndex];
    }
    @finally
    {
        [lock unlock];
    }
}

- (NUUInt64)ivarOffsetForName:(NSString *)aName
{
    @try
    {
        [lock lock];
        
        return [[[self allIvarDictionary] objectForKey:aName] offset];
    }
    @finally
    {
        [lock unlock];
    }
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
            [[[self bell] playLot] markChangedObject:[self subCharacters]];
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
            [[[self bell] playLot] markChangedObject:[self subCharacters]];
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
	NUUInt64 aSize = 0;
	NSEnumerator *enumerator = [[self allIvars] objectEnumerator];
	NUIvar *anIvar = nil;
	
	while (anIvar = [enumerator nextObject])
		aSize += [anIvar sizeInBytes];
	
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

- (NSString *)fullName
{
	if (!fullName) [self setFullName:[self getFullName]];
	return fullName;
}

- (NSString *)getFullName
{
	NSMutableString *aFullName;
	
 	if ([self isRoot])
		aFullName = [[[self name] mutableCopy] autorelease];
	else
	{
		aFullName = [[[[self superCharacter] fullName] mutableCopy] autorelease];
		[aFullName appendString:@"!"];
		[aFullName appendString:[self name]];
	}
	
	[aFullName appendFormat:@"#%d", [self version]];
	
	return aFullName;
}

- (void)setFullName:(NSString *)aFullName
{
	[fullName autorelease];
	fullName = [aFullName copy];
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
    @try
    {
        [lock lock];
        
        if (allIvarDictionary)
        {
            return [allIvarDictionary objectForKey:aName] ? YES : NO;
        }
        else
        {
            if ([[self superCharacter] containsIvarWithName:aName]) return NO;
            
            __block BOOL anIvarNameContained = NO;
            
            [[self ivars] enumerateObjectsUsingBlock:^(NUIvar *anIvar, NSUInteger anIndex, BOOL *aStop) {
                if ([[anIvar name] isEqualToString:aName])
                {
                    anIvarNameContained = YES;
                    *aStop = YES;
                }
            }];
            
            return anIvarNameContained;
        }
    }
    @finally
    {
        [lock unlock];
    }
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    if ([self isEqual:[NUCharacter class]])
	{
		[aCharacter setFormat:NUFixedIvars];
		[aCharacter addIvar:[NUIvar ivarWithName:@"superCharacter" type:NUOOPType]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"format" type:NUUInt8Type]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"version" type:NUUInt32Type]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"name" type:NUOOPType]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"ivars" type:NUOOPType]];
        [aCharacter addIvar:[NUIvar ivarWithName:@"isMutable" type:NUBOOLType]];
		[aCharacter addIvar:[NUIvar ivarWithName:@"subCharacters" type:NUOOPType]];
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
    [[[[self bell] playLot] aliaser] moveUp:self ignoreGradeAtCallFor:YES];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@(%@): %p>", [self class], [self name], self];
}

@end
