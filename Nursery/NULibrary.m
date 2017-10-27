//
//  NULibrary.m
//  Nursery
//
//  Created by P,T,A on 2013/01/20.
//
//

#import <Nursery/NULibrary.h>
#import <Nursery/NUBTree.h>
#import <Nursery/NUCharacter.h>
#import <Nursery/NUIvar.h>
#import <Nursery/NUAliaser.h>
#import <Nursery/NUBell.h>
#import <Nursery/NUSandbox.h>

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
    return [self initWithComparator:[[[NUBTree defaultComparatorClass] new] autorelease]];
}

- (id)initWithComparator:(id <NUComparator>)aComparator
{
    [super init];
    
    NUSetIvar(&tree, [NUBTree treeWithKeyCapacity:[NUBTree defaultKeyCapacity] comparator:aComparator]);
    
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

- (NUUInt64)count
{
    return [[self tree] count];
}

- (id <NUComparator>)comparator
{
    return [[self tree] comparator];
}

- (NSEnumerator *)objectEnumerator
{
    return [[self tree] objectEnumerator];
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock
{
    [[self tree] enumerateKeysAndObjectsUsingBlock:aBlock];
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

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
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

- (NUBTree *)tree
{
    return NUGetIvar(&tree);
}

- (void)setTree:(NUBTree *)aTree
{
    NUSetIvar(&tree, aTree);
    [[self bell] markChanged];
}

@end
