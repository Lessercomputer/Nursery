//
//  NUOpaqueBPlusTreeLeaf.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/27.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSException.h>

#import "NUOpaqueBPlusTreeLeaf.h"
#import "NUOpaqueArray.h"
#import "NUOpaqueBPlusTree.h"

@implementation NUOpaqueBPlusTreeLeaf
@end

@implementation NUOpaqueBPlusTreeLeaf (Accessing)

- (NUUInt8 *)valueFor:(NUUInt8 *)aKey
{
	NUUInt32 aKeyIndex = [self keyIndexGreaterThanOrEqualToKey:aKey];
	
	if (aKeyIndex >= [self keyCount] || ![self keyAt:aKeyIndex isEqual:aKey])
		return NULL;
	else
		return [self valueAt:aKeyIndex];
}

- (NUOpaqueBPlusTreeNode *)setOpaqueValue:(NUUInt8 *)aValue forKey:(NUUInt8 *)aKey
{
    if ([self pageLocation] == 36864)
        [self class];
    
	NUUInt32 anIndexToInsert = [[self keys] indexToInsert:aKey];
	
	if (anIndexToInsert < [self keyCount] && [self keyAt:anIndexToInsert isEqual:aKey])
	{
		[self replaceValueAt:anIndexToInsert with:aValue];
		return nil;
	}
	
    NUOpaqueArray *aNewValues = [self insertOpaqueValue:aValue at:anIndexToInsert];
    NSArray *anExtraValues = [self insertNewExtraValueTo:anIndexToInsert];
    NUOpaqueArray *aNewKeys = [self insertOpaqueKey:aKey at:anIndexToInsert];
    NUOpaqueBPlusTreeLeaf *aNewNode = nil;

    if (aNewKeys)
    {
        aNewNode = [[self tree] makeLeafNodeWithKeys:aNewKeys values:aNewValues];
		[aNewNode setExtraValues:anExtraValues];
		[self insertRightNode:aNewNode];
    }
    
    if (![self isRoot] && ([aNewNode isUnderflow] || [self isUnderflow]))
        @throw [NSException exceptionWithName:NUUnderflowNodeFoundException reason:nil userInfo:nil];
    
    return aNewNode;
}

- (NUOpaqueArray *)insertOpaqueKey:(NUUInt8 *)aKey at:(NUUInt32)anIndex
{
    if ([self isFull])
    {
        NUOpaqueArray *aTemporaryKeys = [[[self keys] copyWithCapacity:[self keyCapacity] + 1] autorelease];
        [aTemporaryKeys insert:aKey to:anIndex];
        [[self keys] setOpaqueValues:[aTemporaryKeys at:0] count:[self minKeyCount]];
        [self nodeDidInsertKeys:[aTemporaryKeys at:0] at:0 count:[self minKeyCount]];
        NUOpaqueArray *aNewKeys = [[[self keys] copyWithoutValues] autorelease];
        [aNewKeys setOpaqueValues:[aTemporaryKeys at:[self minKeyCount]] count:[aTemporaryKeys count] - [self minKeyCount]];
        return aNewKeys;
    }
    else
    {
        [[self keys] insert:aKey to:anIndex];
        [self nodeDidInsertKeys:aKey at:anIndex count:1];
        return nil;
    }
}

- (NSArray *)insertNewExtraValueTo:(NUUInt32)anIndex
{
	return nil;
}

- (NSArray *)extraValues
{
    return nil;
}

- (void)setExtraValues:(NSArray *)anExtraValues
{
}

- (NSArray *)newExtraValues
{
    return nil;
}

- (BOOL)removeValueFor:(NUUInt8 *)aKey
{
    if ([self pageLocation] == 36864)
        [self class];
    
	NUUInt32 aKeyIndex = [self keyIndexGreaterThanOrEqualToKey:aKey];
	
	if (aKeyIndex >= [self keyCount] || ![self keyAt:aKeyIndex isEqual:aKey])
		return NO;
	
	[self removeKeyAt:aKeyIndex];
	[self removeValueAt:aKeyIndex];
    [self removeExtraValueAt:aKeyIndex];
    
    return YES;
}

- (void)removeExtraValueAt:(NUUInt32)anIndex
{
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKey:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	NUUInt32 aCandidateKeyIndex = [self keyIndexEqualTo:aKey];
	
	if (aCandidateKeyIndex != NUUInt32Max)
	{
		if (aKeyIndex) *aKeyIndex = aCandidateKeyIndex;
		return self;
	}
	
	return nil;
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	NUUInt32 aCandidateKeyIndex = [self keyIndexGreaterThanOrEqualToKey:aKey];
	
	if (aCandidateKeyIndex < [self keyCount])
	{
		if (aKeyIndex) *aKeyIndex = aCandidateKeyIndex;
		return self;
	}
	else if ([self rightNode])
        return [[self rightNode] leafNodeContainingKeyGreaterThanOrEqualTo:aKey keyIndex:aKeyIndex];
    else
        return nil;
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
    NUUInt32 aCandidateKeyIndex = [self keyIndexLessThanOrEqualToKey:aKey];
    
    if (aCandidateKeyIndex < [self keyCount])
    {
        if (aKeyIndex) *aKeyIndex = aCandidateKeyIndex;
        return self;
    }
    else if ([self leftNode])
        return [[self leftNode] leafNodeContainingKeyLessThanOrEqualTo:aKey keyIndex:aKeyIndex];
    else
        return nil;
}

- (NUOpaqueBPlusTreeLeaf *)mostLeftNode
{
	return self;
}

- (NUOpaqueBPlusTreeLeaf *)mostRightNode
{
	return self;
}

@end

@implementation NUOpaqueBPlusTreeLeaf (Balancing)

- (void)shuffleLeftNode
{    
    [self shuffleLeftNodeKeysOrValues:[[self leftNode] values] with:[self values]];
	[self shuffleExtraValuesOfLeftNode];
    [self shuffleLeftNodeKeysOrValues:[[self leftNode] keys] with:[self keys]];
	[self markChanged];
	[[self leftNode] markChanged];
}

- (void)shuffleRightNode
{    
    [self shuffleRightNodeKeysOrValues:[self values] with:[[self rightNode] values]];
	[self shuffleExtraValuesOfRightNode];
    [self shuffleRightNodeKeysOrValues:[self keys] with:[[self rightNode] keys]];
	[self markChanged];
	[[self rightNode] markChanged];
}

- (void)shuffleLeftNodeKeysOrValues:(NUOpaqueArray *)aLeftArray with:(NUOpaqueArray *)aRightArray
{
    NUUInt32 aShuffleCount = [[self leftNode] shufflableKeyCount];
	NUUInt32 aShuffleLocation = [aLeftArray count] - aShuffleCount;
	
	[aRightArray insert:[aLeftArray at:aShuffleLocation] to:0 count:aShuffleCount];
	[aLeftArray removeAt:aShuffleLocation count:aShuffleCount];
}

- (void)shuffleRightNodeKeysOrValues:(NUOpaqueArray *)aLeftArray with:(NUOpaqueArray *)aRightArray
{
    NUUInt32 aShuffleCount = [[self rightNode] shufflableKeyCount];
	
	[aLeftArray primitiveInsert:[aRightArray at:0] to:[aLeftArray count] count:aShuffleCount];
	[aRightArray removeAt:0 count:aShuffleCount];
}

- (void)mergeRightNode
{
    if ([self pageLocation] == 36864)
        [self class];
    NUOpaqueBPlusTreeLeaf *aRightNode = (NUOpaqueBPlusTreeLeaf *)[self rightNode];
    [self addKeys:[aRightNode keys]];
	[self addValues:[aRightNode values]];
	[self mergeExtraValuesOfRightNode:aRightNode];
	[aRightNode removeAllKeys];
	[aRightNode removeAllValues];
    
    [super mergeRightNode];
}

- (void)mergeLeftNode
{
    if ([self pageLocation] == 36864)
        [self class];
    
    NUOpaqueBPlusTreeLeaf *aLeftNode = (NUOpaqueBPlusTreeLeaf *)[self leftNode];
    [self insertKeys:[aLeftNode keys] at:0];
	[self insertValues:[aLeftNode values] at:0];
	[self mergeExtraValuesOfLeftNode:aLeftNode];
	[aLeftNode removeAllKeys];
	[aLeftNode removeAllValues];
    
    [super mergeLeftNode];
}

- (void)mergeNode:(NUOpaqueBPlusTreeLeaf *)aNode
{
	[self addKeys:[aNode keys]];
	[self addValues:[aNode values]];
	[self mergeExtraValuesOfRightNode:aNode];
	[aNode removeAllKeys];
	[aNode removeAllValues];
}

- (void)shuffleExtraValuesOfLeftNode
{
}

- (void)shuffleExtraValuesOfRightNode
{
}

- (void)mergeExtraValuesOfLeftNode:(NUOpaqueBPlusTreeLeaf *)aNode
{
}

- (void)mergeExtraValuesOfRightNode:(NUOpaqueBPlusTreeLeaf *)aNode
{
}

@end

@implementation NUOpaqueBPlusTreeLeaf (Testing)

- (BOOL)isLeaf { return YES; }

@end
