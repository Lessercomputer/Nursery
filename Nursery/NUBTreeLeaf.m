//
//  NUBTreeLeaf.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import "NUBTreeLeaf.h"
#import "NUBTree.h"
#import "NUBell.h"
#import "NUSandbox.h"

@implementation NUBTreeLeaf

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

- (NUBTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey
{
    NUUInt64 aKeyIndex;
    NUBTreeSetObjectResult result;
    
    if ([self getKeyIndexGreaterThanOrEqualTo:aKey keyIndexInto:&aKeyIndex])
    {
        [[self keys] replaceObjectAtIndex:aKeyIndex withObject:aKey];
        [[self values] replaceObjectAtIndex:aKeyIndex withObject:anObject];
        
        result = NUBTreeSetObjectResultReplace;
    }
    else
    {
        if (aKeyIndex == NUNotFound64) aKeyIndex = [self valueCount];
        
        [[self keys] insertObject:aKey atIndex:aKeyIndex];
        [[self values] insertObject:anObject atIndex:aKeyIndex];

        result = NUBTreeSetObjectResultAdd;
    }
    
    [[[self bell] sandbox] markChangedObject:[self keys]];
    [[[self bell] sandbox] markChangedObject:[self values]];

    return result;
}

- (BOOL)removeObjectForKey:(id)aKey
{
    NUUInt64 aKeyIndex;
    
    if ([self getKeyIndexGreaterThanOrEqualTo:aKey keyIndexInto:&aKeyIndex])
    {
        [[self keys] removeObjectAtIndex:aKeyIndex];
        [[self values] removeObjectAtIndex:aKeyIndex];
        [[[self bell] sandbox] markChangedObject:[self keys]];
        [[[self bell] sandbox] markChangedObject:[self values]];

        return YES;
    }
    
    return NO;
}

- (NUBTreeNode *)split
{
    NSRange aRange = NSMakeRange([self minKeyCount], [self keyCount] - [self minKeyCount]);
    NSMutableArray *aKeys = [[[[self keys] subarrayWithRange:aRange] mutableCopy] autorelease];
    NSMutableArray *aNodes = [[[[self values] subarrayWithRange:aRange] mutableCopy] autorelease];
    
    NUBTreeLeaf *aLeaf = [[self class] nodeWithTree:[self tree] keys:aKeys values:aNodes];

    [[self keys] removeObjectsInRange:aRange];
    [[self values] removeObjectsInRange:aRange];
    [[[self bell] sandbox] markChangedObject:[self keys]];
    [[[self bell] sandbox] markChangedObject:[self values]];

    [self insertRightSiblingNode:aLeaf];
    
    return aLeaf;
}

- (void)shuffleLeftNode
{
    NUBTreeLeaf *aLeftNode = (NUBTreeLeaf *)[self leftNode];
    NSRange aRange = NSMakeRange([[self tree] minKeyCount], [aLeftNode keyCount] - [aLeftNode minKeyCount]);
    NSArray *aKeys = [[aLeftNode keys] subarrayWithRange:aRange];
    NSArray *aValues = [[aLeftNode values] subarrayWithRange:aRange];
    NSIndexSet *anIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, aRange.length)];
    [[self keys] insertObjects:aKeys atIndexes:anIndexSet];
    [[self values] insertObjects:aValues atIndexes:anIndexSet];
    [[aLeftNode keys] removeObjectsInRange:aRange];
    [[aLeftNode values] removeObjectsInRange:aRange];
    [[[self bell] sandbox] markChangedObject:[self keys]];
    [[[self bell] sandbox] markChangedObject:[self values]];
    [[[self bell] sandbox] markChangedObject:[aLeftNode keys]];
    [[[self bell] sandbox] markChangedObject:[aLeftNode values]];
}

- (void)shuffleRightNode
{
    NUBTreeLeaf *aRightNode = (NUBTreeLeaf *)[self rightNode];
    NSRange aRange = NSMakeRange(0, [aRightNode keyCount] - [aRightNode minKeyCount]);
    NSArray *aKeys = [[aRightNode keys] subarrayWithRange:aRange];
    NSArray *aValues = [[aRightNode values] subarrayWithRange:aRange];
    NSIndexSet *anIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self keyCount], aRange.length)];
    [[self keys] insertObjects:aKeys atIndexes:anIndexSet];
    [[self values] insertObjects:aValues atIndexes:anIndexSet];
    [[aRightNode keys] removeObjectsInRange:aRange];
    [[aRightNode values] removeObjectsInRange:aRange];
    [[[self bell] sandbox] markChangedObject:[self keys]];
    [[[self bell] sandbox] markChangedObject:[self values]];
    [[[self bell] sandbox] markChangedObject:[aRightNode keys]];
    [[[self bell] sandbox] markChangedObject:[aRightNode values]];
}

- (void)mergeLeftNode
{
    NSIndexSet *anIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[self leftNode] keyCount])];
    [[self keys] insertObjects:[[self leftNode] keys] atIndexes:anIndexSet];
    [[self values] insertObjects:[[self leftNode] values] atIndexes:anIndexSet];
    [super mergeLeftNode];
}

- (void)mergeRightNode
{
    [[self keys] addObjectsFromArray:[[self rightNode] keys]];
    [[self values] addObjectsFromArray:[[self rightNode] values]];
    [super mergeRightNode];
}

@end

@implementation NUBTreeLeaf (Private)

- (void)updateKey:(id)aKey
{
    NUUInt64 aKeyIndex;
    
    if ([self getKeyIndexLessThanOrEqualTo:aKey keyIndexInto:&aKeyIndex])
    {
        [[self keys] replaceObjectAtIndex:aKeyIndex withObject:aKey];
        [[[self bell] sandbox] markChangedObject:[self keys]];
    }
}

- (NUBTreeLeaf *)firstLeaf
{
    return self;
}

- (NUBTreeLeaf *)lastLeaf
{
    return self;
}

- (NUBTreeLeaf *)leafNodeContainingKeyGreaterThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
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
            NUBTreeLeaf *aCandidateLeaf = self;
            
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

- (NUBTreeLeaf *)leafNodeContainingKeyLessThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex
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
            NUBTreeLeaf *aCandidateLeaf = self;
            
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
