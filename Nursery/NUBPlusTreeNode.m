//
//  NUBPlusTreeNode.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//


#import "NUBPlusTreeNode.h"
#import "NULazyMutableArray.h"
#import "NUBPlusTree.h"
#import "NUCharacter.h"
#import "NUIvar.h"
#import "NUAliaser.h"
#import "NUBell.h"
#import "NUGarden.h"

@implementation NUBPlusTreeNode

+ (id)nodeWithTree:(NUBPlusTree *)aTree
{
    return [[[self alloc] initWithTree:aTree] autorelease];
}

+ (id)nodeWithTree:(NUBPlusTree *)aTree keys:(NULazyMutableArray *)aKeys values:(NULazyMutableArray *)aValues
{
    return [[[self alloc] initWithTree:aTree keys:aKeys values:aValues] autorelease];
}

- (id)initWithTree:(NUBPlusTree *)aTree
{   
    return [self initWithTree:aTree
                         keys:[NULazyMutableArray arrayWithCapacity:(NSUInteger)[aTree keyCapacity]]
                       values:[NULazyMutableArray arrayWithCapacity:(NSUInteger)([self isLeaf] ? [aTree keyCapacity] : [aTree keyCapacity] + 1)]];
}

- (id)initWithTree:(NUBPlusTree *)aTree keys:(NULazyMutableArray *)aKeys values:(NULazyMutableArray *)aValues
{
    if (self = [super init])
    {
        NUSetIvar(&tree, aTree);
        
        NUSetIvar(&keys, aKeys);
        NUSetIvar(&values, aValues);
    }
        
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

- (NUBPlusTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey
{
    return NUBPlusTreeSetObjectResultAdd;
}

- (BOOL)removeObjectForKey:(id)aKey
{
    return NO;
}

- (NULazyMutableArray *)keys
{
    return NUGetIvar(&keys);
}

- (NULazyMutableArray *)values
{
    return NUGetIvar(&values);
}

- (NUBPlusTreeNode *)leftNode
{
    return NUGetIvar(&leftNode);
}

- (NUBPlusTreeNode *)rightNode
{
    return NUGetIvar(&rightNode);
}

- (NUBPlusTreeNode *)parentNode
{
    return NUGetIvar(&parentNode);
}

- (NUBPlusTree *)tree
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
    return [[self keys] objectAtIndex:(NSUInteger)anIndex];
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
    return [[self values] objectAtIndex:(NSUInteger)anIndex];
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

- (NUBPlusTreeNode *)split
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
}

- (void)mergeRightNode
{
    [[[self rightNode] rightNode] setLeftNode:self];
    [self setRightNode:[[self rightNode] rightNode]];
}

- (void)addLoadedNodesTo:(id)aLoadedNodes
{
    [aLoadedNodes addObject:self];
}

@end

@implementation NUBPlusTreeNode (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    if (![[self class] isEqual:[NUBPlusTreeNode class]]) return;

    [aCharacter setVersion:1];
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
    if (self = [super init])
    {
        [self initIversWithAliaser:anAliaser forMoveUp:NO];
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

@implementation NUBPlusTreeNode (MovingUp)

- (void)moveUpWithAliaser:(NUAliaser *)anAliaser
{
    [self initIversWithAliaser:anAliaser forMoveUp:YES];
    [[self bell] unmarkChanged];
}

@end

@implementation NUBPlusTreeNode (Private)

- (void)initIversWithAliaser:(NUAliaser *)anAliaser forMoveUp:(BOOL)aMoveUpFlag
{
    NUCharacter *aCharacter = [anAliaser characterForClass:[NUBPlusTreeNode class]];

    if (aMoveUpFlag)
    {
        [anAliaser moveUp:keys];
        [anAliaser moveUp:values];
    }
    
    if ([aCharacter version] == 0)
    {
        NSMutableArray *anArray = [anAliaser decodeObjectReally];
        NULazyMutableArray *aLazyArray = [NULazyMutableArray arrayWithArray:anArray];
        NUSetIvar(&keys, aLazyArray);
        
        anArray = [anAliaser decodeObjectReally];
        aLazyArray = [NULazyMutableArray arrayWithArray:anArray];
        NUSetIvar(&values, aLazyArray);
    }
    else
    {
        NUSetIvar(&keys, [anAliaser decodeObject]);
        NUSetIvar(&values, [anAliaser decodeObject]);
    }
    
    NUSetIvar(&tree, [anAliaser decodeObject]);
    NUSetIvar(&leftNode, [anAliaser decodeObject]);
    NUSetIvar(&rightNode, [anAliaser decodeObject]);
    NUSetIvar(&parentNode, [anAliaser decodeObject]);
}

- (void)setKeys:(NULazyMutableArray *)aKeys
{
    NUSetIvar(&keys, aKeys);
    [[self bell] markChanged];
}

- (void)setValues:(NULazyMutableArray *)aValues
{
    NUSetIvar(&values, aValues);
    [[self bell] markChanged];
}

- (void)setLeftNode:(NUBPlusTreeNode *)aLeftNode
{
    NUSetIvar(&leftNode, aLeftNode);
    [[self bell] markChanged];
}

- (void)setRightNode:(NUBPlusTreeNode *)aRightNode
{
    NUSetIvar(&rightNode, aRightNode);
    [[self bell] markChanged];
}

- (void)setParentNode:(NUBPlusTreeNode *)aParentNode
{
    NUSetIvar(&parentNode, aParentNode);
    [[self bell] markChanged];
}

- (void)insertRightSiblingNode:(NUBPlusTreeNode *)aNode
{
    NUBPlusTreeNode *anOldRightSibling = [self rightNode];
    [aNode setLeftNode:self];
    [aNode setRightNode:anOldRightSibling];
    [self setRightNode:aNode];
    [anOldRightSibling setLeftNode:aNode];
}

- (void)setTree:(NUBPlusTree *)aTree
{
    NUSetIvar(&tree, aTree);
    [[self bell] markChanged];
}

- (void)updateKey:(id)aKey
{
    
}

- (NUBPlusTreeLeaf *)firstLeaf
{
    return nil;
}

-(NUBPlusTreeLeaf *)lastLeaf
{
    return nil;
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex
{
    return [self leafNodeContainingKeyGreaterThan:aKey orEqualToKey:YES keyIndex:aKeyIndex];
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
{
    return nil;
}

-(NUBPlusTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex
{
    return [self leafNodeContainingKeyLessThan:aKey orEqualToKey:YES keyIndex:aKeyIndex];
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyLessThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
{
    return nil;
}


@end
