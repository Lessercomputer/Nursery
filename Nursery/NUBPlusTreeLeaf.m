//
//  NUBPlusTreeLeaf.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import <Foundation/NSArray.h>
#import <Foundation/NSIndexSet.h>

#import "NUBPlusTreeLeaf.h"
#import "NUBPlusTree.h"
#import "NUBell.h"
#import "NUGarden.h"
#import "NULazyMutableArray.h"

@implementation NUBPlusTreeLeaf

- (BOOL)isLeaf
{
    return YES;
}

- (BOOL)isBranch
{
    return NO;
}

- (id)firstKey
{
    return [self keyCount] ? [self keyAt:0] : nil;
}

- (id)lastKey
{
    return [self keyCount] ? [self keyAt:[self keyCount] - 1] : nil;
}

- (id)objectForKey:(id)aKey
{
    NUUInt64 aKeyIndex;
    
    if ([self getKeyIndexLessThanOrEqualTo:aKey keyIndexInto:&aKeyIndex])
        return [self valueAt:aKeyIndex];
    
    return nil;
}

- (NUBPlusTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey
{
    NUUInt64 aKeyIndex;
    NUBPlusTreeSetObjectResult result;
    
    if ([self getKeyIndexGreaterThanOrEqualTo:aKey keyIndexInto:&aKeyIndex])
    {
        [[self keys] replaceObjectAtIndex:aKeyIndex withObject:aKey];
        [[self values] replaceObjectAtIndex:aKeyIndex withObject:anObject];
        
        result = NUBPlusTreeSetObjectResultReplace;
    }
    else
    {
        if (aKeyIndex == NUNotFound64) aKeyIndex = [self valueCount];
        
        [[self keys] insertObject:aKey atIndex:aKeyIndex];
        [[self values] insertObject:anObject atIndex:aKeyIndex];

        result = NUBPlusTreeSetObjectResultAdd;
    }
    
    [[[self bell] garden] markChangedObject:[self keys]];
    [[[self bell] garden] markChangedObject:[self values]];

    return result;
}

- (BOOL)removeObjectForKey:(id)aKey
{
    NUUInt64 aKeyIndex;
    
    if ([self getKeyIndexGreaterThanOrEqualTo:aKey keyIndexInto:&aKeyIndex])
    {
        [[self keys] removeObjectAtIndex:aKeyIndex];
        [[self values] removeObjectAtIndex:aKeyIndex];
        [[[self bell] garden] markChangedObject:[self keys]];
        [[[self bell] garden] markChangedObject:[self values]];

        return YES;
    }
    
    return NO;
}

- (NUBPlusTreeNode *)split
{
    NSRange aRange = NSMakeRange([self minKeyCount], [self keyCount] - [self minKeyCount]);
    NULazyMutableArray *aKeys = [[self keys] subLazyMutableArrayWithRange:aRange];
    NULazyMutableArray *aNodes = [[self values] subLazyMutableArrayWithRange:aRange];
    
    NUBPlusTreeLeaf *aLeaf = [[self class] nodeWithTree:[self tree] keys:aKeys values:aNodes];

    [[self keys] removeObjectsInRange:aRange];
    [[self values] removeObjectsInRange:aRange];
    [[[self bell] garden] markChangedObject:[self keys]];
    [[[self bell] garden] markChangedObject:[self values]];

    [self insertRightSiblingNode:aLeaf];
    
    return aLeaf;
}

- (void)shuffleLeftNode
{
    NUBPlusTreeLeaf *aLeftNode = (NUBPlusTreeLeaf *)[self leftNode];
    NSRange aRange = NSMakeRange([[self tree] minKeyCount], [aLeftNode keyCount] - [aLeftNode minKeyCount]);
    NSArray *aKeys = [[aLeftNode keys] subarrayWithRange:aRange];
    NSArray *aValues = [[aLeftNode values] subarrayWithRange:aRange];
    NSIndexSet *anIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, aRange.length)];
    [[self keys] insertObjects:aKeys atIndexes:anIndexSet];
    [[self values] insertObjects:aValues atIndexes:anIndexSet];
    [[aLeftNode keys] removeObjectsInRange:aRange];
    [[aLeftNode values] removeObjectsInRange:aRange];
    [[[self bell] garden] markChangedObject:[self keys]];
    [[[self bell] garden] markChangedObject:[self values]];
    [[[self bell] garden] markChangedObject:[aLeftNode keys]];
    [[[self bell] garden] markChangedObject:[aLeftNode values]];
}

- (void)shuffleRightNode
{
    NUBPlusTreeLeaf *aRightNode = (NUBPlusTreeLeaf *)[self rightNode];
    NSRange aRange = NSMakeRange(0, [aRightNode keyCount] - [aRightNode minKeyCount]);
    NSArray *aKeys = [[aRightNode keys] subarrayWithRange:aRange];
    NSArray *aValues = [[aRightNode values] subarrayWithRange:aRange];
    NSIndexSet *anIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self keyCount], aRange.length)];
    [[self keys] insertObjects:aKeys atIndexes:anIndexSet];
    [[self values] insertObjects:aValues atIndexes:anIndexSet];
    [[aRightNode keys] removeObjectsInRange:aRange];
    [[aRightNode values] removeObjectsInRange:aRange];
    [[[self bell] garden] markChangedObject:[self keys]];
    [[[self bell] garden] markChangedObject:[self values]];
    [[[self bell] garden] markChangedObject:[aRightNode keys]];
    [[[self bell] garden] markChangedObject:[aRightNode values]];
}

- (void)mergeLeftNode
{
    NSIndexSet *anIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[self leftNode] keyCount])];
    [[self keys] insertObjects:(NSArray *)[[self leftNode] keys] atIndexes:anIndexSet];
    [[self values] insertObjects:(NSArray *)[[self leftNode] values] atIndexes:anIndexSet];
    [super mergeLeftNode];
}

- (void)mergeRightNode
{
    [[self keys] addObjectsFromArray:(NSArray *)[[self rightNode] keys]];
    [[self values] addObjectsFromArray:(NSArray *)[[self rightNode] values]];
    [super mergeRightNode];
}

@end

@implementation NUBPlusTreeLeaf (Private)

- (void)updateKey:(id)aKey
{
    NUUInt64 aKeyIndex;
    
    if ([self getKeyIndexLessThanOrEqualTo:aKey keyIndexInto:&aKeyIndex])
    {
        [[self keys] replaceObjectAtIndex:aKeyIndex withObject:aKey];
        [[[self bell] garden] markChangedObject:[self keys]];
    }
}

- (NUBPlusTreeLeaf *)firstLeaf
{
    return self;
}

- (NUBPlusTreeLeaf *)lastLeaf
{
    return self;
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
{
    NUUInt64 aCandidateKeyIndex;
    BOOL aSameKeyExists = [self getKeyIndexGreaterThanOrEqualTo:aKey keyIndexInto:&aCandidateKeyIndex];
    
    if (aCandidateKeyIndex != NUNotFound64)
    {
        if (!aSameKeyExists || anOrEqualToKeyFlag)
        {
            if (aKeyIndex) *aKeyIndex = aCandidateKeyIndex;
            return self;
        }
        else
        {
            NUBPlusTreeLeaf *aCandidateLeaf = self;
            
            while (YES)
            {
                aCandidateLeaf = [[self tree] getNextKeyIndex:&aCandidateKeyIndex node:aCandidateLeaf];
                NSComparisonResult aResult = [[self comparator] compareObject:[aCandidateLeaf keyAt:aCandidateKeyIndex] toObject:aKey];
                
                if (!aCandidateLeaf || aResult == NSOrderedDescending)
                {
                    *aKeyIndex = aCandidateKeyIndex;
                    return aCandidateLeaf;
                }
            }
        }
    }
    else if ([self rightNode])
        return [[self rightNode] leafNodeContainingKeyGreaterThan:aKey orEqualToKey:anOrEqualToKeyFlag keyIndex:aKeyIndex];
    else
        return nil;
}

- (NUBPlusTreeLeaf *)leafNodeContainingKeyLessThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
{
    NUUInt64 aCandidateKeyIndex;
    BOOL aSameKeyExists = [self getKeyIndexLessThanOrEqualTo:aKey keyIndexInto:&aCandidateKeyIndex];
    
    if (aCandidateKeyIndex != NUNotFound64)
    {
        if (!aSameKeyExists || anOrEqualToKeyFlag)
        {
            if (aKeyIndex) *aKeyIndex = aCandidateKeyIndex;
            return self;
        }
        else
        {
            NUBPlusTreeLeaf *aCandidateLeaf = self;
            
            while (YES)
            {
                aCandidateLeaf = [[self tree] getPreviousKeyIndex:&aCandidateKeyIndex node:aCandidateLeaf];
                NSComparisonResult aResult = [[self comparator] compareObject:[aCandidateLeaf keyAt:aCandidateKeyIndex] toObject:aKey];
                
                if (!aCandidateLeaf || aResult == NSOrderedAscending)
                {
                    *aKeyIndex = aCandidateKeyIndex;
                    return aCandidateLeaf;
                }
            }
        }
    }
    else if ([self leftNode])
        return [[self leftNode] leafNodeContainingKeyLessThan:aKey orEqualToKey:anOrEqualToKeyFlag keyIndex:aKeyIndex];
    else
        return nil;
}


@end
