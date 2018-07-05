//
//  NUBPlusTreeBranch.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import <Foundation/NSArray.h>
#import <Foundation/NSIndexSet.h>

#import "NUBPlusTreeBranch.h"
#import "NUBPlusTree.h"
#import "NUBell.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NULazyMutableArray.h"

@implementation NUBPlusTreeBranch

+ (id)nodeWithTree:(NUBPlusTree *)aTree key:(id)aKey leftChildNode:(NUBPlusTreeNode *)aLeftChildNode rightChildNode:(NUBPlusTreeNode *)aRightChildNode
{
    return [[[self alloc] initWithTree:aTree key:aKey leftChildNode:aLeftChildNode rightChildNode:aRightChildNode] autorelease];
}

- (id)initWithTree:(NUBPlusTree *)aTree key:(id)aKey leftChildNode:(NUBPlusTreeNode *)aLeftChildNode rightChildNode:(NUBPlusTreeNode *)aRightChildNode
{
    if (self = [super initWithTree:aTree])
    {
        [[self keys] addObject:aKey];
        [self addNode:aLeftChildNode];
        [self addNode:aRightChildNode];
    }
    
    return self;
}

- (BOOL)isLeaf
{
    return NO;
}

- (BOOL)isBranch
{
    return YES;
}

- (id)firstKey
{
    return [[self valueAt:0] firstKey];
}

- (id)lastKey
{
    return [[self valueAt:[self valueCount] - 1] lastKey];
}

- (id)objectForKey:(id)aKey
{
    return [[self nodeForKey:aKey] objectForKey:aKey];
}

- (NUBPlusTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey
{
    NUUInt64 aNodeIndex = [self nodeIndexForKey:aKey];
    NUBPlusTreeNode *aNode = [self valueAt:aNodeIndex];
    NUBPlusTreeSetObjectResult aSetResult = [aNode setObject:anObject forKey:aKey];
    
    if ([aNode isOverflow])
    {
        NUBPlusTreeBranch *aNewChildNode = (NUBPlusTreeBranch *)[aNode split];
        [self insertKey:[aNewChildNode firstKey] at:aNodeIndex];
        [self insertNode:aNewChildNode at:aNodeIndex + 1];
    }
    
    return aSetResult;
}

- (BOOL)removeObjectForKey:(id)aKey
{
    NUUInt64 aNodeIndex = [self nodeIndexForKey:aKey];
    NUBPlusTreeNode *aNode = [self valueAt:aNodeIndex];
    BOOL aRemoved = [aNode removeObjectForKey:aKey];
    
    if ([aNode isUnderflow])
    {
        if (aNodeIndex != 0 && ![[self valueAt:aNodeIndex - 1] isMin])
        {
            [aNode shuffleLeftNode];
            [[self keys] replaceObjectAtIndex:(NSUInteger)aNodeIndex - 1 withObject:[aNode firstKey]];
            
#ifdef DEBUG
            if ([aNode isBranch] && [aNode keyCount] + 1 != [aNode valueCount])
                NSLog(@"error");
            if ([[aNode leftNode] isBranch] && [[aNode leftNode] keyCount] + 1 != [[aNode leftNode] valueCount])
                NSLog(@"error");
#endif
        }
        else if (aNodeIndex != [self valueCount] - 1 && ![[self valueAt:aNodeIndex + 1] isMin])
        {
            [aNode shuffleRightNode];
            [[self keys] replaceObjectAtIndex:(NSUInteger)aNodeIndex withObject:[[aNode rightNode] firstKey]];
            
#ifdef DEBUG
            if ([aNode isBranch] && [aNode keyCount] + 1 != [aNode valueCount])
                NSLog(@"error");
            if ([[aNode rightNode] isBranch] && [[aNode rightNode] keyCount] + 1 != [[aNode rightNode] valueCount])
                NSLog(@"error");
#endif
        }
        else if (aNodeIndex != 0)
        {
            [[aNode leftNode] mergeRightNode];
            
#ifdef DEBUG
            if ([[aNode leftNode] isBranch] && [[aNode leftNode] keyCount] + 1 != [[aNode leftNode] valueCount])
                NSLog(@"error");
#endif

            [[self keys] removeObjectAtIndex:(NSUInteger)aNodeIndex - 1];
            [[self values] removeObjectAtIndex:(NSUInteger)aNodeIndex];
        }
        else if (aNodeIndex != [self valueCount] - 1)
        {
            [[aNode rightNode] mergeLeftNode];
            
#ifdef DEBUG
            if ([[aNode rightNode] isBranch] && [[aNode rightNode] keyCount] + 1 != [[aNode rightNode] valueCount])
                NSLog(@"error");
#endif
            
            [[self keys] removeObjectAtIndex:(NSUInteger)aNodeIndex];
            [[self values] removeObjectAtIndex:(NSUInteger)aNodeIndex];
        }
        else
        {
#ifdef DEBUG
            NSLog(@"error");
#endif
        }
    }
    
    return aRemoved;
}

- (NUBPlusTreeNode *)split
{
    NSRange aKeyRemoveRange = NSMakeRange((NSUInteger)[self minKeyCount], (NSUInteger)([self keyCount] - [self minKeyCount]));
    NSRange aNewKeyRange = NSMakeRange(aKeyRemoveRange.location + 1, aKeyRemoveRange.length - 1);
    NSRange aNewValueRange = NSMakeRange(aKeyRemoveRange.location + 1, aKeyRemoveRange.length);
    
    NULazyMutableArray *aKeys = [[self keys] subLazyMutableArrayWithRange:aNewKeyRange];
    NULazyMutableArray *aValues = [[self values] subLazyMutableArrayWithRange:aNewValueRange];
    
    [[self keys] removeObjectsInRange:aKeyRemoveRange];
    [[self values] removeObjectsInRange:aNewValueRange];

#ifdef DEBUG
    if ([self keyCount] + 1 != [self valueCount])
        NSLog(@"error");
#endif
    
    NUBPlusTreeBranch *aBranch = [[self class] nodeWithTree:[self tree] keys:aKeys values:aValues];
    
#ifdef DEBUG
    if ([aBranch keyCount] + 1 != [self valueCount])
        NSLog(@"error");
#endif
    
    [self insertRightSiblingNode:aBranch];
    
    return aBranch;
}

- (void)shuffleLeftNode
{
    NSRange aKeyRange = NSMakeRange((NSUInteger)[[self tree] minKeyCount], (NSUInteger)([[self leftNode] keyCount] - [[self tree] minKeyCount]));
    NSRange aValueRange = NSMakeRange(aKeyRange.location + 1, aKeyRange.length);
    NULazyMutableArray *aKeys = [[[self leftNode] keys] subLazyMutableArrayWithRange:aKeyRange];
    NULazyMutableArray *aValues = [[[self leftNode] values] subLazyMutableArrayWithRange:aValueRange];
    
    [[[self leftNode] keys] removeObjectsInRange:aKeyRange];
    [[[self leftNode] values] removeObjectsInRange:aValueRange];
    
    [aKeys removeObjectAtIndex:0];
    [aKeys addObject:[self firstKey]];
    
    [[self keys] insertObjects:(NSArray *)aKeys atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [aKeys count])]];
    [[self values] insertObjects:aValues atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [aValues count])]];

    [aValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setParentNode:self];
    }];
    
#ifdef DEBUG
    if ([self keyCount] + 1 != [self valueCount])
        NSLog(@"error");
#endif
}

- (void)shuffleRightNode
{
    NSRange aRange = NSMakeRange(0, (NSUInteger)([[self rightNode] keyCount] - [[self tree] minKeyCount]));
    NULazyMutableArray *aKeys = [[[self rightNode] keys] subLazyMutableArrayWithRange:aRange];
    NULazyMutableArray *aValues = [[[self rightNode] values] subLazyMutableArrayWithRange:aRange];
    
    [[[self rightNode] keys] removeObjectsInRange:aRange];
    [[[self rightNode] values] removeObjectsInRange:aRange];
    
#ifdef DEBUG
    if ([self keyCount] + [aKeys count] + 1 != [self valueCount] + [aValues count])
        NSLog(@"error");
#endif
    
    [aKeys removeLastObject];
    [aKeys insertObject:[[aValues objectAtIndex:0] firstKey] atIndex:0];
    
    [[self keys] addObjectsFromArray:(NSArray *)aKeys];
    [[self values] addObjectsFromArray:aValues];

    [aValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setParentNode:self];
    }];
    
#ifdef DEBUG
    if ([self keyCount] + 1 != [self valueCount])
        NSLog(@"error");
#endif
}

- (void)mergeLeftNode
{
    NULazyMutableArray *aKeys = [[[[self leftNode] keys] mutableCopy] autorelease];
    [aKeys addObject:[self firstKey]];
    
    [[self keys] insertObjects:(NSArray *)aKeys atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [aKeys count])]];
    [[self values] insertObjects:(NSArray *)[[self leftNode] values] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, (NSUInteger)[[self leftNode] valueCount])]];
    
    [[[self leftNode] values] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setParentNode:self];
    }];
    
#ifdef DEBUG
    if ([self keyCount] + 1 != [self valueCount])
        NSLog(@"error");
#endif
    
    [super mergeLeftNode];
}

- (void)mergeRightNode
{
    [[self keys] addObject:[[self rightNode] firstKey]];
    [[self keys] addObjectsFromArray:(NSArray *)[[self rightNode] keys]];
    [[self values] addObjectsFromArray:(NSArray *)[[self rightNode] values]];
    [[[self rightNode] values] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setParentNode:self];
    }];
    
#ifdef DEBUG
    if ([self keyCount] + 1 != [self valueCount])
        NSLog(@"error");
#endif
    
    [super mergeRightNode];
}

- (NUBPlusTreeNode *)nodeForKey:(id)aKey
{
    return [self valueAt:[self nodeIndexForKey:aKey]];
}

- (NUUInt64)nodeIndexForKey:(id)aKey
{
    NUUInt64 aKeyIndex;
    [self getKeyIndexLessThanOrEqualTo:aKey keyIndexInto:&aKeyIndex];
    return aKeyIndex == NUNotFound64 ? 0 : aKeyIndex + 1;
}

- (void)addNode:(NUBPlusTreeNode *)aNode
{
    [self insertNode:aNode at:[self valueCount]];
}

- (void)insertNode:(NUBPlusTreeNode *)aNode at:(NUUInt64)anIndex
{
    [[self values] insertObject:aNode atIndex:(NSUInteger)anIndex];
    [aNode setParentNode:self];
}

- (void)removeNodeAt:(NUUInt64)anIndex
{
    NUBPlusTreeNode *aNode = [self valueAt:anIndex];
    [[self values] removeObjectAtIndex:(NSUInteger)anIndex];
    [aNode setParentNode:nil];
}

- (void)insertKey:(id)aKey at:(NUUInt64)anIndex
{
    [[self keys] insertObject:aKey atIndex:(NSUInteger)anIndex];
}

- (void)addLoadedNodesTo:(id)aLoadedNodes
{
    [super addLoadedNodesTo:aLoadedNodes];
    
    for (NSUInteger i = 0; i < [self valueCount]; i++)
    {
        if ([[self values] hasOOPs])
        {
            NUUInt64 aNodeOOP = [[self values] oopAt:i];
            NUBell *aNodeBell = [[[self bell] garden] bellForOOP:aNodeOOP];
            if ([aNodeBell isLoaded])
                [(NUBPlusTreeNode *)[aNodeBell object] addLoadedNodesTo:aLoadedNodes];
        }
        else
        {
            NUBPlusTreeNode *aNode = [self valueAt:i];
            [aNode addLoadedNodesTo:aLoadedNodes];
        }
    }
}

@end

@implementation NUBPlusTreeBranch (Private)

- (void)setValues:(NULazyMutableArray *)aValues
{
    [super setValues:aValues];
    [[self values] makeObjectsPerformSelector:@selector(setParentNode:) withObject:self];
}

- (void)updateKey:(id)aKey
{
    NUUInt64 aKeyIndex;
    
    if ([self getKeyIndexLessThanOrEqualTo:aKey keyIndexInto:&aKeyIndex])
    {
        [[self keys] replaceObjectAtIndex:(NSUInteger)aKeyIndex withObject:[[self valueAt:aKeyIndex + 1] firstKey]];
    }
    
    [[self valueAt:aKeyIndex != NUNotFound64 ? aKeyIndex + 1 : 0] updateKey:aKey];
}

- (NUBPlusTreeLeaf *)firstLeaf
{
    return [[self valueAt:0] firstLeaf];
}

-(NUBPlusTreeLeaf *)lastLeaf
{
    return [[self valueAt:[self valueCount] - 1] lastLeaf];
}

- (NUUInt64)insertionTargetNodeIndexFor:(id)aKey
{
    NUUInt64 aKeyIndex;
    
    [self getKeyIndexLessThanOrEqualTo:aKey keyIndexInto:&aKeyIndex];
    
    return aKeyIndex != NUNotFound64 ? aKeyIndex + 1 : 0;
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
{
    return [[self valueAt:[self insertionTargetNodeIndexFor:aKey]] leafNodeContainingKeyGreaterThan:aKey orEqualToKey:anOrEqualToKeyFlag keyIndex:aKeyIndex];
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyLessThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
{
    return [[self valueAt:[self insertionTargetNodeIndexFor:aKey]] leafNodeContainingKeyLessThan:aKey orEqualToKey:anOrEqualToKeyFlag keyIndex:aKeyIndex];
}

@end
