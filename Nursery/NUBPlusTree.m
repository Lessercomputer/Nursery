//
//  NUBPlusTree.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#include <math.h>
#import <Foundation/NSException.h>

#import "NUBPlusTree.h"
#import "NUBPlusTreeNode.h"
#import "NUBPlusTreeLeaf.h"
#import "NUBPlusTreeBranch.h"
#import "NUDefaultComparator.h"
#import "NUBPlusTreeEnumerator.h"
#import "NUIvar.h"
#import "NUCharacter.h"
#import "NUBell.h"
#import "NUAliaser.h"

@implementation NUBPlusTree

+ (id)treeWithKeyCapacity:(NUUInt64)aKeyCapacity comparator:(id <NUComparator>)aComparator
{
    return [[[self alloc] initWithKeyCapacity:aKeyCapacity comparator:aComparator] autorelease];
}

- (id)initWithKeyCapacity:(NUUInt64)aKeyCapacity comparator:(id <NUComparator>)aComparator
{
    [super init];
    
    keyCapacity = aKeyCapacity;
    NUSetIvar(&comparator, aComparator);
    NUSetIvar(&root, [NUBPlusTreeLeaf nodeWithTree:self]);
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

- (NUBPlusTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey
{
    NUBPlusTreeSetObjectResult aSetResult = [[self root] setObject:anObject forKey:aKey];
    
    if (aSetResult == NUBPlusTreeSetObjectResultAdd)
    {
        count++;
        [[self bell] markChanged];
    }
    else
        [self updateKey:aKey];
    
    if ([[self root] isOverflow])
    {
        NUBPlusTreeNode *aNewRightSibling = [[self root] split];
        NUBPlusTreeBranch *aNewRoot = [NUBPlusTreeBranch nodeWithTree:self key:[aNewRightSibling firstKey] leftChildNode:[self root] rightChildNode:aNewRightSibling];
        [self setRoot:aNewRoot];
        depth++;
    }
    
    return aSetResult;
}

- (BOOL)removeObjectForKey:(id)aKey
{
    BOOL aKeyAndObjectAreRemoved = [[self root] removeObjectForKey:aKey];
    
    if (aKeyAndObjectAreRemoved)
    {
        count--;
        [self updateKey:aKey];
        [[self bell] markChanged];
    }
    
    if ([[self root] isBranch] && [[self root] valueCount] == 1)
    {
        NUBPlusTreeBranch *anOldRoot = (NUBPlusTreeBranch *)[self root];
        NUBPlusTreeNode *aNewRoot = [anOldRoot valueAt:0];
        [self setRoot:aNewRoot];
        [anOldRoot removeNodeAt:0];
        depth--;
    }
    
    return aKeyAndObjectAreRemoved;
}

- (id)firstKey
{
    return [[self root] firstKey];
}

- (id)lastKey
{
    return [[self root] lastKey];
}

- (id)keyGreaterThanOrEqualTo:(id)aKey
{
    NUUInt64 aKeyIndex;
    NUBPlusTreeLeaf *aLeaf = [self leafNodeContainingKeyGreaterThanOrEqualTo:(id)aKey keyIndex:&aKeyIndex];
    
    return aLeaf ? [aLeaf keyAt:aKeyIndex] : nil;
}

- (id)keyGreaterThan:(id)aKey
{
    NUUInt64 aKeyIndex;
    NUBPlusTreeLeaf *aLeaf = [self leafNodeContainingKeyGreaterThan:aKey keyIndex:&aKeyIndex];
    
    return aLeaf ? [aLeaf keyAt:aKeyIndex] : nil;
}

- (id)keyLessThanOrEqualTo:(id)aKey
{
    NUUInt64 aKeyIndex;
    NUBPlusTreeLeaf *aLeaf = [self leafNodeContainingKeyLessThanOrEqualTo:aKey keyIndex:&aKeyIndex];
    
    return aLeaf ? [aLeaf keyAt:aKeyIndex] : nil;
}

- (id)keyLessThan:(id)aKey
{
    NUUInt64 aKeyIndex;
    NUBPlusTreeLeaf *aLeaf = [self leafNodeContainingKeyLessThan:aKey keyIndex:&aKeyIndex];
    
    return aLeaf ? [aLeaf keyAt:aKeyIndex] : nil;
}

- (NUUInt64)count
{
    return count;
}

- (NUUInt64)depth
{
    return depth;
}

- (NUBPlusTreeNode *)root
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


- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock
{
    [self enumerateKeysAndObjectsWithOptions:0 usingBlock:aBlock];
}

-(void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock
{
    [self enumerateKeysAndObjectsWithKeyGreaterThan:nil orEqual:YES andKeyLessThan:nil orEqual:YES options:0 usingBlock:aBlock];
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
    NUBPlusTreeEnumerator *anEnumerator = [NUBPlusTreeEnumerator enumeratorWithTree:self keyGreaterThan:aKey1 orEqual:anOrEqualFlag1 keyLessThan:aKey2 orEqual:anOrEqualFlag2 options:anOpts];
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

@implementation NUBPlusTree (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
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
    if (self = [super init])
    {
        [self initIvarsWithAliaser:anAliaser];
    }
    
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

@implementation NUBPlusTree (MovingUp)

- (void)moveUpWithAliaser:(NUAliaser *)anAliaser
{
    NSMutableArray *anAllLoadedNodes = [self allLoadedNodes];
    
    [anAllLoadedNodes enumerateObjectsUsingBlock:^(NUBPlusTreeNode * _Nonnull aNode, NSUInteger anIndex, BOOL * _Nonnull aStop) {
        [anAliaser moveUp:aNode];
    }];
    
    [self initIvarsWithAliaser:anAliaser];
    [[self bell] unmarkChanged];
}

@end

@implementation NUBPlusTree (Private)

- (void)initIvarsWithAliaser:(NUAliaser *)anAliaser
{
    NUSetIvar(&root, [anAliaser decodeObject]);
    count = [anAliaser decodeUInt64];
    depth = [anAliaser decodeUInt64];
    keyCapacity = [anAliaser decodeUInt64];
    NUSetIvar(&comparator, [anAliaser decodeObject]);
}

- (void)setRoot:(NUBPlusTreeNode *)aRoot
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
- (NUBPlusTreeLeaf *)firstLeaf
{
    return [[self root] firstLeaf];
}

- (NUBPlusTreeLeaf *)lastLeaf
{
    return [[self root] lastLeaf];
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex
{
    return [[self root] leafNodeContainingKeyGreaterThanOrEqualTo:aKey keyIndex:aKeyIndex];
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThan:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex
{
    return [[self root] leafNodeContainingKeyGreaterThan:aKey orEqualToKey:NO keyIndex:aKeyIndex];
}

-(NUBPlusTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex
{
    return [[self root] leafNodeContainingKeyLessThanOrEqualTo:aKey keyIndex:aKeyIndex];
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyLessThan:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex
{
    return [[self root] leafNodeContainingKeyLessThan:aKey orEqualToKey:NO keyIndex:aKeyIndex];
}

- (NUBPlusTreeLeaf *)getNextKeyIndex:(NUUInt64 *)aKeyIndex node:(NUBPlusTreeLeaf *)aNode
{
    if (!aKeyIndex)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:NSInvalidArgumentException userInfo:nil];
    
    if (!aNode)
        return nil;
    
    if (*aKeyIndex == NUNotFound64)
    {
        if ([aNode keyCount] == 0)
            return nil;
        else
        {
            *aKeyIndex = 0;
            return (NUBPlusTreeLeaf *)aNode;
        }
    }
    
    if (*aKeyIndex + 1 < [aNode keyCount])
    {
        (*aKeyIndex)++;
        return (NUBPlusTreeLeaf *)aNode;
    }
    else
    {
        *aKeyIndex = 0;
        return (NUBPlusTreeLeaf *)[aNode rightNode];
    }
}

- (NUBPlusTreeLeaf *)getPreviousKeyIndex:(NUUInt64 *)aKeyIndex node:(NUBPlusTreeLeaf *)aNode
{
    if (!aKeyIndex)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:NSInvalidArgumentException userInfo:nil];
    
    if (!aNode)
        return nil;
    
    if (*aKeyIndex == NUNotFound64)
    {
        if ([aNode keyCount] == 0)
            return nil;
        else
        {
            *aKeyIndex = [aNode keyCount] - 1;
            return (NUBPlusTreeLeaf *)aNode;
        }
    }
    
    if (*aKeyIndex != 0)
    {
        (*aKeyIndex)--;
        return (NUBPlusTreeLeaf *)aNode;
    }
    else
    {
        *aKeyIndex = [aNode keyCount] - 1;
        return (NUBPlusTreeLeaf *)[aNode leftNode];
    }
}

- (NSMutableArray *)allLoadedNodes
{
    NSMutableArray *anAllLoadedNodes = [NSMutableArray array];
    
    [[self root] addLoadedNodesTo:anAllLoadedNodes];
    
    return anAllLoadedNodes;
}

@end
