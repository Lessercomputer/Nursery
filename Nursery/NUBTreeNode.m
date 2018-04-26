//
//  NUBTreeNode.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import <Foundation/NSArray.h>

#import "NUBTreeNode.h"
#import "NUBTree.h"
#import "NUCharacter.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBell.h"
#import "NUGarden.h"

@implementation NUBTreeNode

+ (id)nodeWithTree:(NUBTree *)aTree
{
    return [[[self alloc] initWithTree:aTree] autorelease];
}

+ (id)nodeWithTree:(NUBTree *)aTree keys:(NSMutableArray *)aKeys values:(NSMutableArray *)aValues
{
    return [[[self alloc] initWithTree:aTree keys:aKeys values:aValues] autorelease];
}

- (id)initWithTree:(NUBTree *)aTree
{   
    return [self initWithTree:aTree
                         keys:[NSMutableArray arrayWithCapacity:[aTree keyCapacity]]
                       values:[NSMutableArray arrayWithCapacity:[self isLeaf] ? [aTree keyCapacity] : [aTree keyCapacity] + 1]];
}

- (id)initWithTree:(NUBTree *)aTree keys:(NSMutableArray *)aKeys values:(NSMutableArray *)aValues
{
    [super init];
    
    NUSetIvar(&tree, aTree);
    
    NUSetIvar(&keys, aKeys);
    NUSetIvar(&values, aValues);
        
    return self;
}

- (void)dealloc
{    
    [keys release];
    [values release];
    [leftNode release];
    [rightNode release];
    [parentNode release];
    [tree release];
    
    [super dealloc];
}

- (id)objectForKey:(id)aKey
{
    return nil;
}

- (NUBTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey
{
    return NUBTreeSetObjectResultAdd;
}

- (BOOL)removeObjectForKey:(id)aKey
{
    return NO;
}

- (NSMutableArray *)keys
{
    return NUGetIvar(&keys);
}

- (NSMutableArray *)values
{
    return NUGetIvar(&values);
}

- (NUBTreeNode *)leftNode
{
    return NUGetIvar(&leftNode);
}

- (NUBTreeNode *)rightNode
{
    return NUGetIvar(&rightNode);
}

- (NUBTreeNode *)parentNode
{
    return NUGetIvar(&parentNode);
}

- (NUBTree *)tree
{
    return NUGetIvar(&tree);
}

- (id)firstKey
{
    return nil;
}

- (id)lastKey
{
    return nil;
}

- (id)keyAt:(NUUInt64)anIndex
{
    return [[self keys] objectAtIndex:anIndex];
}

- (NUUInt64)keyCount
{
    return [[self keys] count];
}

- (NUUInt64)minKeyCount
{
    return [[self tree] minKeyCount];
}

- (id)valueAt:(NUUInt64)anIndex
{
    return [[self values] objectAtIndex:anIndex];
}

- (NUUInt64)valueCount
{
    return [[self values] count];
}

- (BOOL)isBranch
{
    return NO;
}

- (BOOL)isLeaf
{
    return NO;
}

- (BOOL)isMin
{
    return [self keyCount] == [[self tree] minKeyCount];
}

- (BOOL)isUnderflow
{
    return [[self keys] count] < [[self tree] minKeyCount];
}

- (BOOL)isOverflow
{
    return [[self keys] count] > [[self tree] keyCapacity];
}

- (id <NUComparator>)comparator
{
    return [[self tree] comparator];
}

- (BOOL)getKeyIndexLessThanOrEqualTo:(id)aKey keyIndexInto:(NUUInt64 *)aKeyIndex
{
    if ([self keyCount] == 0)
    {
        *aKeyIndex = NUNotFound64;
        return NO;
    }

    NUUInt64 i = 0, j = [self keyCount] - 1;
    NUUInt64 k;
    
    while (YES)
    {
        k = i + ((j - i) / 2);
        
        NSComparisonResult result = [[self comparator] compareObject:[self keyAt:k] toObject:aKey];
        
        if (result == NSOrderedAscending)
        {
            if (k + 1 > j)
            {
                *aKeyIndex = k;
                return NO;
            }
            
            i = k + 1;
        }
        else if (result == NSOrderedDescending)
        {
            if (k == 0)
            {
                *aKeyIndex = NUNotFound64;
                return NO;
            }
            else if (k - 1 < i)
            {
                *aKeyIndex = k - 1;
                return NO;
            }
                        
            j = k - 1;
        }
        else
        {
            *aKeyIndex = k;
            return YES;
        }
    }
}

- (BOOL)getKeyIndexGreaterThanOrEqualTo:(id)aKey keyIndexInto:(NUUInt64 *)aKeyIndex
{
    if ([self keyCount] == 0)
    {
        *aKeyIndex = NUNotFound64;
        return NO;
    }
    
    NUUInt64 i = 0, j = [self keyCount] - 1;
    NUUInt64 k;
    
    while (YES)
    {
        k = i + ((j - i) / 2);
        
        NSComparisonResult result = [[self comparator] compareObject:[self keyAt:k] toObject:aKey];
        
        if (result == NSOrderedAscending)
        {
            if (k + 1 > j)
            {                
                *aKeyIndex = k + 1 < [self keyCount] ? k + 1 : NUNotFound64;
                return NO;
            }
            
            i = k + 1;
        }
        else if (result == NSOrderedDescending)
        {            
            if (k == 0 || k - 1 < i)
            {
                *aKeyIndex = k;
                return NO;
            }
            
            j = k - 1;
        }
        else
        {
            *aKeyIndex = k;
            return YES;
        }
    }
}

- (NUBTreeNode *)split
{
    return nil;
}

- (void)shuffleLeftNode
{
    
}

- (void)shuffleRightNode
{
    
}

- (void)mergeLeftNode
{
    [[[self leftNode] leftNode] setRightNode:self];
    [self setLeftNode:[[self leftNode] leftNode]];
    [[[self bell] garden] markChangedObject:[self keys]];
    [[[self bell] garden] markChangedObject:[self values]];
}

- (void)mergeRightNode
{
    [[[self rightNode] rightNode] setLeftNode:self];
    [self setRightNode:[[self rightNode] rightNode]];
    [[[self bell] garden] markChangedObject:[self keys]];
    [[[self bell] garden] markChangedObject:[self values]];
}

@end

@implementation NUBTreeNode (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    if (![[self class] isEqual:[NUBTreeNode class]]) return;

    [aCharacter addOOPIvarWithName:@"keys"];
    [aCharacter addOOPIvarWithName:@"values"];
    [aCharacter addOOPIvarWithName:@"tree"];
    [aCharacter addOOPIvarWithName:@"leftNode"];
    [aCharacter addOOPIvarWithName:@"rightNode"];
    [aCharacter addOOPIvarWithName:@"parentNode"];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
    [anAliaser encodeObject:keys];
    [anAliaser encodeObject:values];
    [anAliaser encodeObject:tree];
    [anAliaser encodeObject:leftNode];
    [anAliaser encodeObject:rightNode];
    [anAliaser encodeObject:parentNode];
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    [super init];
    
    NUSetIvar(&keys, [anAliaser decodeObject]);
    NUSetIvar(&values, [anAliaser decodeObject]);
    NUSetIvar(&tree, [anAliaser decodeObject]);
    NUSetIvar(&leftNode, [anAliaser decodeObject]);
    NUSetIvar(&rightNode, [anAliaser decodeObject]);
    NUSetIvar(&parentNode, [anAliaser decodeObject]);
    
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

@implementation NUBTreeNode (Private)

- (void)setKeys:(NSMutableArray *)aKeys
{
    NUSetIvar(&keys, aKeys);
    [[self bell] markChanged];
}

- (void)setValues:(NSMutableArray *)aValues
{
    NUSetIvar(&values, aValues);
    [[self bell] markChanged];
}

- (void)setLeftNode:(NUBTreeNode *)aLeftNode
{
    NUSetIvar(&leftNode, aLeftNode);
    [[self bell] markChanged];
}

- (void)setRightNode:(NUBTreeNode *)aRightNode
{
    NUSetIvar(&rightNode, aRightNode);
    [[self bell] markChanged];
}

- (void)setParentNode:(NUBTreeNode *)aParentNode
{
    NUSetIvar(&parentNode, aParentNode);
    [[self bell] markChanged];
}

- (void)insertRightSiblingNode:(NUBTreeNode *)aNode
{
    NUBTreeNode *anOldRightSibling = [self rightNode];
    [aNode setLeftNode:self];
    [aNode setRightNode:anOldRightSibling];
    [self setRightNode:aNode];
    [anOldRightSibling setLeftNode:aNode];
}

- (void)setTree:(NUBTree *)aTree
{
    NUSetIvar(&tree, aTree);
    [[self bell] markChanged];
}

- (void)updateKey:(id)aKey
{
    
}

- (NUBTreeLeaf *)firstLeaf
{
    return nil;
}

-(NUBTreeLeaf *)lastLeaf
{
    return nil;
}

- (NUBTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex
{
    return [self leafNodeContainingKeyGreaterThan:aKey orEqualToKey:YES keyIndex:aKeyIndex];
}

- (NUBTreeLeaf *)leafNodeContainingKeyGreaterThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
{
    return nil;
}

-(NUBTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex
{
    return [self leafNodeContainingKeyLessThan:aKey orEqualToKey:YES keyIndex:aKeyIndex];
}

- (NUBTreeLeaf *)leafNodeContainingKeyLessThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
{
    return nil;
}


@end
