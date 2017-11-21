//
//  NUOpaqueBTreeLeaf.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/27.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUOpaqueBTreeLeaf.h"
#import "NUOpaqueArray.h"
#import "NUOpaqueBTree.h"

@implementation NUOpaqueBTreeLeaf
@end

@implementation NUOpaqueBTreeLeaf (Accessing)

- (NUUInt8 *)valueFor:(NUUInt8 *)aKey
{
	NUUInt32 aKeyIndex = [self keyIndexGreaterThanOrEqualToKey:aKey];
	
	if (aKeyIndex >= [self keyCount] || ![self keyAt:aKeyIndex isEqual:aKey])
		return NULL;
	else
		return [self valueAt:aKeyIndex];
}

- (NUOpaqueBTreeNode *)setOpaqueValue:(NUUInt8 *)aValue forKey:(NUUInt8 *)aKey
{
	NUUInt32 anIndexToInsert = [[self keys] indexToInsert:aKey];
	
	if (anIndexToInsert < [self keyCount] && [self keyAt:anIndexToInsert isEqual:aKey])
	{
		[self replaceValueAt:anIndexToInsert with:aValue];
		return nil;
	}
	
    NUOpaqueArray *aNewValues = [self insertOpaqueValue:aValue at:anIndexToInsert];
    NSArray *anExtraValues = [self insertNewExtraValueTo:anIndexToInsert];
    NUOpaqueArray *aNewKeys = [self insertOpaqueKey:aKey at:anIndexToInsert];
    NUOpaqueBTreeLeaf *aNewNode = nil;

    if (aNewKeys)
    {
        aNewNode = [[self tree] makeLeafNodeWithKeys:aNewKeys values:aNewValues];
		[aNewNode setExtraValues:anExtraValues];
		[self insertRightNode:aNewNode];
    }
    
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

- (void)removeValueFor:(NUUInt8 *)aKey
{
	NUUInt32 aKeyIndex = [self keyIndexGreaterThanOrEqualToKey:aKey];
	
	if (aKeyIndex >= [self keyCount] || ![self keyAt:aKeyIndex isEqual:aKey])
		return;
	
	[self removeKeyAt:aKeyIndex];
	[self removeValueAt:aKeyIndex];
    [self removeExtraValueAt:aKeyIndex];
    
//    if ([self keyCount]  < [self minKeyCount])
//        [[NSException exceptionWithName:@"underflow" reason:nil userInfo:nil] raise];
}

- (void)removeExtraValueAt:(NUUInt32)anIndex
{
}

- (NUOpaqueBTreeLeaf *)leafNodeContainingKey:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	NUUInt32 aCandidateKeyIndex = [self keyIndexEqualTo:aKey];
	
	if (aCandidateKeyIndex != NUUInt32Max)
	{
		if (aKeyIndex) *aKeyIndex = aCandidateKeyIndex;
		return self;
	}
	
	return nil;
}

- (NUOpaqueBTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
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

- (NUOpaqueBTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
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

- (NUOpaqueBTreeLeaf *)mostLeftNode
{
	return self;
}

- (NUOpaqueBTreeLeaf *)mostRightNode
{
	return self;
}

@end

@implementation NUOpaqueBTreeLeaf (Balancing)

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
    NUOpaqueBTreeLeaf *aRightNode = (NUOpaqueBTreeLeaf *)[self rightNode];
    [self addKeys:[aRightNode keys]];
	[self addValues:[aRightNode values]];
	[self mergeExtraValuesOfRightNode:aRightNode];
	[aRightNode removeAllKeys];
	[aRightNode removeAllValues];
    
    [super mergeRightNode];
}

- (void)mergeLeftNode
{	
    NUOpaqueBTreeLeaf *aLeftNode = (NUOpaqueBTreeLeaf *)[self leftNode];
    [self insertKeys:[aLeftNode keys] at:0];
	[self insertValues:[aLeftNode values] at:0];
	[self mergeExtraValuesOfLeftNode:aLeftNode];
	[aLeftNode removeAllKeys];
	[aLeftNode removeAllValues];
    
    [super mergeLeftNode];
}

- (void)mergeNode:(NUOpaqueBTreeLeaf *)aNode
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

- (void)mergeExtraValuesOfLeftNode:(NUOpaqueBTreeLeaf *)aNode
{
}

- (void)mergeExtraValuesOfRightNode:(NUOpaqueBTreeLeaf *)aNode
{
}

@end

@implementation NUOpaqueBTreeLeaf (Testing)

- (BOOL)isLeaf { return YES; }

@end
