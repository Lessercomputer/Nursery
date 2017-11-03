//
//  NUBTree.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import "NUBTree.h"
#import "NUBTreeNode.h"
#import "NUBTreeLeaf.h"
#import "NUBTreeBranch.h"
#import "NUDefaultComparator.h"
#import "NUBTreeEnumerator.h"
#import "NUIvar.h"
#import "NUCharacter.h"
#import "NUBell.h"
#import "NUAliaser.h"

@implementation NUBTree

+ (id)treeWithKeyCapacity:(NUUInt64)aKeyCapacity comparator:(id <NUComparator>)aComparator
{
    return [[[self alloc] initWithKeyCapacity:aKeyCapacity comparator:aComparator] autorelease];
}

- (id)initWithKeyCapacity:(NUUInt64)aKeyCapacity comparator:(id <NUComparator>)aComparator
{
    [super init];
    
    keyCapacity = aKeyCapacity;
    NUSetIvar(&comparator, aComparator);
    NUSetIvar(&root, [NUBTreeLeaf nodeWithTree:self]);
    depth = 1;
    
    return self;
}

- (void)dealloc
{
    [root release];
    [comparator release];
    
    [super dealloc];
}

- (id)objectForKey:(id)aKey
{
    return [[self root] objectForKey:aKey];
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
    if ([[self root] setObject:anObject forKey:aKey] == NUBTreeSetObjectResultAdd)
    {
        count++;
        [[self bell] markChanged];
    }
    else
        [self updateKey:aKey];
    
    if ([[self root] isOverflow])
    {
        NUBTreeNode *aNewRightSibling = [[self root] split];
        NUBTreeBranch *aNewRoot = [NUBTreeBranch nodeWithTree:self key:[aNewRightSibling firstKey] leftChildNode:[self root] rightChildNode:aNewRightSibling];
        [self setRoot:aNewRoot];
        depth++;
    }
}

- (void)removeObjectForKey:(id)aKey
{
    if ([[self root] removeObjectForKey:aKey])
    {
        count--;
        [self updateKey:aKey];
        [[self bell] markChanged];
    }
    
    if ([[self root] isBranch] && [[self root] valueCount] == 1)
    {
        NUBTreeBranch *anOldRoot = (NUBTreeBranch *)[self root];
        NUBTreeNode *aNewRoot = [anOldRoot valueAt:0];
        [self setRoot:aNewRoot];
        [anOldRoot removeNodeAt:0];
        depth--;
    }
}

- (NUUInt64)count
{
    return count;
}

- (NUUInt64)depth
{
    return depth;
}

- (NUBTreeNode *)root
{
    return NUGetIvar(&root);
}

- (NUUInt64)keyCapacity
{
    return keyCapacity;
}

- (NUUInt64)minKeyCount
{
    return ceil([self keyCapacity] / 2.0);
}

- (id <NUComparator>)comparator
{
    return NUGetIvar(&comparator);
}

- (NSEnumerator *)objectEnumerator
{
    return [self objectEnumeratorFrom:nil to:nil];
}

- (NSEnumerator *)objectEnumeratorFrom:(id)aKey1 to:(id)aKey2
{
    return [self objectEnumeratorFrom:aKey1 to:aKey2 option:0];
}

- (NSEnumerator *)objectEnumeratorFrom:(id)aKey1 to:(id)aKey2 option:(NSEnumerationOptions)anOpts
{
    return [NUBTreeEnumerator enumeratorWithTree:self from:aKey1 to:aKey2 options:anOpts];
}

-(NSEnumerator *)reverseObjectEnumerator
{
    return [self reverseObjectEnumeratorFrom:nil to:nil];
}

- (NSEnumerator *)reverseObjectEnumeratorFrom:(id)aKey1 to:(id)aKey2
{
    return [self reverseObjectEnumeratorFrom:aKey1 to:aKey2 option:NSEnumerationReverse];
}

- (NSEnumerator *)reverseObjectEnumeratorFrom:(id)aKey1 to:(id)aKey2 option:(NSEnumerationOptions)anOpts
{
    return [NUBTreeEnumerator enumeratorWithTree:self from:nil to:nil options:NSEnumerationReverse];
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock
{
    [self enumerateKeysAndObjectsWithOptions:0 usingBlock:aBlock];
}

-(void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock
{
    [self enumerateKeysAndObjectsFrom:nil to:nil options:anOpts usingBlock:aBlock];
}

-(void)enumerateKeysAndObjectsFrom:(id)aKey1 to:(id)aKey2 options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock
{
    NUBTreeEnumerator *anEnumerator = (NUBTreeEnumerator *)[self objectEnumeratorFrom:aKey1 to:aKey2 option:anOpts];
    [anEnumerator enumerateKeysAndObjectsUsingBlock:aBlock];
}

+ (NUUInt64)defaultKeyCapacity
{
    return 250;
}

+ (Class)defaultComparatorClass
{
    return [NUDefaultComparator class];
}

@end

@implementation NUBTree (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
{
    [aCharacter addOOPIvarWithName:@"root"];
    [aCharacter addUInt64IvarWithName:@"count"];
    [aCharacter addUInt64IvarWithName:@"depth"];
    [aCharacter addUInt64IvarWithName:@"keyCapacity"];
    [aCharacter addOOPIvarWithName:@"comparator"];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
    [anAliaser encodeObject:root];
    [anAliaser encodeUInt64:count];
    [anAliaser encodeUInt64:depth];
    [anAliaser encodeUInt64:keyCapacity];
    [anAliaser encodeObject:comparator];
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    [super init];
    
    NUSetIvar(&root, [anAliaser decodeObject]);
    count = [anAliaser decodeUInt64];
    depth = [anAliaser decodeUInt64];
    keyCapacity = [anAliaser decodeUInt64];
    NUSetIvar(&comparator, [anAliaser decodeObject]);
    
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

@implementation NUBTree (Private)

- (void)setRoot:(NUBTreeNode *)aRoot
{
    NUSetIvar(&root, aRoot);
    [[self bell] markChanged];
}

- (void)setComparator:(id <NUComparator>)aComparator
{
    NUSetIvar(&comparator, aComparator);
    [[self bell] markChanged];
}

- (void)updateKey:(id)aKey
{
    [[self root] updateKey:aKey];
}
- (NUBTreeLeaf *)firstLeaf
{
    return [[self root] firstLeaf];
}

- (NUBTreeLeaf *)lastLeaf
{
    return [[self root] lastLeaf];
}

- (NUBTreeLeaf *)leafNodeContainingKeyGreaterThenOrEqualTo:(id)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
    return [[self root] leafNodeContainingKeyGreaterThenOrEqualTo:aKey keyIndex:aKeyIndex];
}

-(NUBTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(id)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
    return [[self root] leafNodeContainingKeyLessThanOrEqualTo:aKey keyIndex:aKeyIndex];
}

- (NUBTreeLeaf *)getNextKeyIndex:(NUUInt32 *)aKeyIndex node:(NUBTreeLeaf *)aNode
{
    if (!aKeyIndex)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:NSInvalidArgumentException userInfo:nil];
    
    if (!aNode)
        return nil;
    
    if (*aKeyIndex == NUNotFound32)
    {
        if ([aNode keyCount] == 0)
            return nil;
        else
        {
            *aKeyIndex = 0;
            return (NUBTreeLeaf *)aNode;
        }
    }
    
    if (*aKeyIndex + 1 < [aNode keyCount])
    {
        (*aKeyIndex)++;
        return (NUBTreeLeaf *)aNode;
    }
    else
    {
        *aKeyIndex = 0;
        return (NUBTreeLeaf *)[aNode rightNode];
    }
}

@end
