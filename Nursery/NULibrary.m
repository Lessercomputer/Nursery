//
//  NULibrary.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import "NULibrary.h"
#import "NUBPlusTree.h"
#import "NUCharacter.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBell.h"
#import "NUGarden.h"

@interface NULibrary (Private)

- (NUBPlusTree *)tree;
- (void)setTree:(NUBPlusTree *)aTree;

@end

@implementation NULibrary

+ (id)library
{
    return [[self new] autorelease];
}

+ (id)libraryWithComparator:(id <NUComparator>)aComparator
{
    return [[[self alloc] initWithComparator:aComparator] autorelease];
}

- (id)init
{
    return [self initWithComparator:[[[NUBPlusTree defaultComparatorClass] new] autorelease]];
}

- (id)initWithComparator:(id <NUComparator>)aComparator
{
    [super init];
    
    NUSetIvar(&tree, [NUBPlusTree treeWithKeyCapacity:[NUBPlusTree defaultKeyCapacity] comparator:aComparator]);
    
    return self;
}

- (id)objectForKey:(id)aKey
{
    return [[self tree] objectForKey:aKey];
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
    [[self tree] setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
    [[self tree] removeObjectForKey:aKey];
}

- (id)firstKey
{
    return [[self tree] firstKey];
}

- (id)lastKey
{
    return [[self tree] lastKey];
}

- (id)keyGreaterThanOrEqualTo:(id)aKey
{
    return [[self tree] keyGreaterThanOrEqualTo:aKey];
}

- (id)keyGreaterThan:(id)aKey
{
    return [[self tree] keyGreaterThan:aKey];
}

- (id)keyLessThanOrEqualTo:(id)aKey
{
    return [[self tree] keyLessThanOrEqualTo:aKey];
}

- (id)keyLessThan:(id)aKey
{
    return [[self tree] keyLessThan:aKey];
}

- (NUUInt64)count
{
    return [[self tree] count];
}

- (id <NUComparator>)comparator
{
    return [[self tree] comparator];
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock
{
    [self enumerateKeysAndObjectsWithOptions:0 usingBlock:aBlock];
}

-(void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock
{
    [self enumerateKeysAndObjectsWithKeyGreaterThan:nil orEqual:YES andKeyLessThan:nil orEqual:YES options:anOpts usingBlock:aBlock];
}

- (void)enumerateKeysAndObjectsWithKeyGreaterThan:(id)aKey orEqual:(BOOL)anOrEqualFlag options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock
{
    [self enumerateKeysAndObjectsWithKeyGreaterThan:aKey orEqual:anOrEqualFlag andKeyLessThan:nil orEqual:YES options:anOpts usingBlock:aBlock];
}

- (void)enumerateKeysAndObjectsWithKeyLessThan:(id)aKey orEqual:(BOOL)anOrEqualFlag options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock
{
    [self enumerateKeysAndObjectsWithKeyGreaterThan:nil orEqual:YES andKeyLessThan:aKey orEqual:anOrEqualFlag options:anOpts usingBlock:aBlock];
}

- (void)enumerateKeysAndObjectsWithKeyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 andKeyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock
{
    [[self tree] enumerateKeysAndObjectsWithKeyGreaterThan:aKey1 orEqual:anOrEqualFlag1 andKeyLessThan:aKey2 orEqual:anOrEqualFlag2 options:anOpts usingBlock:aBlock];
}

- (BOOL)isEqual:(id)anObject
{
    return [self isEqualToLibrary:anObject];
}

- (BOOL)isEqualToLibrary:(NULibrary *)aLibrary
{
    if (self == aLibrary) return YES;
    
    __block BOOL anEqualFlag = YES;
    
    if ([self count] != [aLibrary count]) return NO;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id aKey, id anObj, BOOL *aStop) {
        id anAnotherObj = [aLibrary objectForKey:aKey];
        
        if (!anAnotherObj)
            anEqualFlag = NO;
        else if (![anObj isEqual:anAnotherObj])
            anEqualFlag = NO;
        
        if (!anEqualFlag)
            *aStop = YES;
    }];
    
    return anEqualFlag;
}

- (void)dealloc
{
    [tree release];
    
    [super dealloc];
}

@end


@implementation NULibrary (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    [aCharacter addOOPIvarWithName:@"tree"];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
    [anAliaser encodeObject:tree];
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    [super init];
    
    NUSetIvar(&tree, [anAliaser decodeObject]);
    
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

@end

@implementation NULibrary (Private)

- (NUBPlusTree *)tree
{
    return NUGetIvar(&tree);
}

- (void)setTree:(NUBPlusTree *)aTree
{
    NUSetIvar(&tree, aTree);
    [[self bell] markChanged];
}

@end
