//
//  NUMutableDictionary.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/10/05.
//
//

#import "NUMutableDictionary.h"
#import "NUBell.h"
#import "NUSandbox.h"
#import "NUAliaser.h"
#import "NUCharacter.h"
#import "NUIvar.h"

@implementation NUMutableDictionary

+ (id)new
{
    return [[self alloc] initWithObjects:NULL forKeys:NULL count:0];
}

- (id)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
    if (self = [super init])
    {
        innerDictionary = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys count:cnt];
        
        setKeys = [NSMutableSet new];
        removedKeys = [NSMutableSet new];
    }
    
    return self;
}

- (void)dealloc
{
    [innerDictionary release];
    [setKeys release];
    [removedKeys release];
    
    [super dealloc];
}

- (NSUInteger)count
{
    return [[self innerDictionary] count];
}

- (id)objectForKey:(id)aKey
{
    return [[self innerDictionary] objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
    return [[self innerDictionary] keyEnumerator];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    [[self removedKeys] removeObject:aKey];
    [[self setKeys] addObject:[[aKey copyWithZone:NSDefaultMallocZone()] autorelease]];
    [[self innerDictionary] setObject:anObject forKey:aKey];
    [[[self bell] sandbox] markChangedObject:self];
    [[[self bell] sandbox] markChangedObject:[self innerDictionary]];
}

- (void)removeObjectForKey:(id)aKey
{
    if (![self objectForKey:aKey]) return;
    
    [[self setKeys] removeObject:aKey];
    [[self removedKeys] addObject:[[aKey copyWithZone:NSDefaultMallocZone()] autorelease]];
    [[self innerDictionary] removeObjectForKey:aKey];
    [[[self bell] sandbox] markChangedObject:self];
    [[[self bell] sandbox] markChangedObject:[self innerDictionary]];
}

- (NUBell *)bell
{
	return bell;
}

- (void)setBell:(NUBell *)aBell
{
	bell = aBell;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
{
    [aCharacter addOOPIvarWithName:@"innerDictionary"];
}

- (Class)classForNursery
{
    return [self class];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
	[anAliaser encodeObject:innerDictionary];
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    NUSetIvar(&innerDictionary, [anAliaser decodeObjectReally]);
	setKeys = [NSMutableSet new];
    removedKeys = [NSMutableSet new];

	return self;
}

- (void)moveUpWithAliaser:(NUAliaser *)anAliaser
{
    [anAliaser moveUp:innerDictionary ignoreGradeAtCallFor:NO];
}

@end

@implementation NUMutableDictionary (ModificationInfo)

- (void)removeAllModificationInfo
{
    [[self setKeys] removeAllObjects];
    [[self removedKeys] removeAllObjects];
}

@end

@implementation NUMutableDictionary (Private)

- (NSMutableDictionary *)innerDictionary
{
    return innerDictionary;
}

- (void)setInnerDictionary:(NSMutableDictionary *)aDictionary
{
    [innerDictionary autorelease];
    innerDictionary = [aDictionary retain];
}

- (NSMutableSet *)setKeys
{
    return setKeys;
}

- (void)setSetKeys:(NSMutableSet *)aKeys
{
    [setKeys autorelease];
    setKeys = [aKeys retain];
}

- (NSMutableSet *)removedKeys
{
    return removedKeys;
}

- (void)setRemovedKeys:(NSMutableSet *)aKeys
{
    [removedKeys autorelease];
    removedKeys = [aKeys retain];
}

@end
