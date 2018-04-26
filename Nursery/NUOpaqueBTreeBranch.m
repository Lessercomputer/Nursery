//
//  NUOpaqueBTreeBranch.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/27.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSException.h>

#import "NUOpaqueBTreeBranch.h"
#import "NUIndexArray.h"
#import "NUOpaqueBTree.h"
#import "NURegionTree.h"
#import "NUSpaces.h"

NSString *NUBtreeNodeIsNotChildNodeException = @"NUBtreeNodeIsNotChildNodeException";

@implementation NUOpaqueBTreeBranch
@end

@implementation NUOpaqueBTreeBranch (Accessing)

- (NUUInt32)lastNodeIndex
{
	return [self valueCount] - 1;
}

- (NUOpaqueBTreeBranch *)leftBranch
{
	return (NUOpaqueBTreeBranch *)[self leftNode];
}

- (NUOpaqueBTreeBranch *)rightBranch
{
	return  (NUOpaqueBTreeBranch *)[self rightNode];
}

- (NUOpaqueBTreeBranch *)parentNodeOf:(NUOpaqueBTreeNode *)aNode
{
    if ([self isEqual:aNode]) return nil;
    
    NUOpaqueBTreeNode *aChildNode = [self nodeAt:[self insertionTargetNodeIndexFor:[aNode mostLeftKey]]];
    
    if ([aChildNode isEqual:aNode]) return self;
    
    return [aChildNode parentNodeOf:aNode];
}

- (NUOpaqueBTreeNode *)nodeAt:(NUUInt32)anIndex
{
	return [[self tree] nodeFor:[self nodeLocationAt:anIndex]];
}

- (NUUInt64)nodeLocationAt:(NUUInt32)anIndex
{
	return [[self nodeLocations] indexAt:anIndex];
}

- (NUUInt32)leftKeyIndexForNodeAt:(NUUInt32)anIndex
{
	return anIndex != 0 ? anIndex - 1 : NUNotFound32;
}

- (NUUInt32)rightKeyIndexForNodeAt:(NUUInt32)anIndex
{
	return anIndex != [self lastNodeIndex] ? anIndex : NUNotFound32;
}

- (NUIndexArray *)nodeLocations
{
	return (NUIndexArray *)[self values];
}

- (NUUInt32)insertionTargetNodeIndexFor:(NUUInt8 *)aKey
{
	return [self keyIndexLessThanOrEqualToKey:aKey] + 1;
}

- (NUOpaqueBTreeLeaf *)leafNodeContainingKey:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return [[self nodeAt:[self insertionTargetNodeIndexFor:aKey]] leafNodeContainingKey:aKey keyIndex:aKeyIndex];
}

- (NUOpaqueBTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return [[self nodeAt:[self insertionTargetNodeIndexFor:aKey]] leafNodeContainingKeyGreaterThanOrEqualTo:aKey keyIndex:aKeyIndex];
}

- (NUOpaqueBTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return [[self nodeAt:[self insertionTargetNodeIndexFor:aKey]] leafNodeContainingKeyLessThanOrEqualTo:aKey keyIndex:aKeyIndex];
}

- (NUUInt8 *)mostLeftKey
{
	return [[self nodeAt:0] mostLeftKey];
}

- (NUOpaqueBTreeLeaf *)mostLeftNode
{
	return [[self nodeAt:0] mostLeftNode];
}

- (NUOpaqueBTreeLeaf *)mostRightNode
{
	return [[self nodeAt:[self valueCount] - 1] mostRightNode];
}

- (NUOpaqueArray *)makeValueArray
{
	return [[[NUIndexArray alloc] initWithCapacity:[self valueCapacity] comparator:[[self tree] comparator]] autorelease];
}

- (NUUInt8 *)valueFor:(NUUInt8 *)aKey
{
	NUUInt32 aNodeIndex = [self insertionTargetNodeIndexFor:aKey];
	NUOpaqueBTreeNode *aNode = [self nodeAt:aNodeIndex];
	return [aNode valueFor:aKey];
}

- (NUOpaqueBTreeNode *)setOpaqueValue:(NUUInt8 *)aValue forKey:(NUUInt8 *)aKey
{
	NUUInt32 aChildNodeIndex = [self insertionTargetNodeIndexFor:aKey];
	NUOpaqueBTreeNode *aChildNode = [self nodeAt:aChildNodeIndex];
	NUOpaqueBTreeNode *aSiblingNodeOfChildNode = [aChildNode setOpaqueValue:aValue forKey:aKey];
	
	if (aSiblingNodeOfChildNode)
		return [self insertChildNode:aSiblingNodeOfChildNode at:aChildNodeIndex + 1];
	
	return nil;
}

- (void)removeValueFor:(NUUInt8 *)aKey
{
	NUUInt32 aNodeIndex = [self insertionTargetNodeIndexFor:aKey];
	NUOpaqueBTreeNode *aNode = [self nodeAt:aNodeIndex];
    
	[aNode removeValueFor:aKey];
    
//#ifdef DEBUG
//    if ([self isUnderflow])
//        [[NSException exceptionWithName:@"underflow" reason:nil userInfo:nil] raise];
//#endif
	
    if (![aNode isUnderflow]) return;
        
    if (aNodeIndex != 0 && ![[aNode leftNode] isMin])
    {
        [aNode shuffleLeftNode];
        [self replaceKeyAt:[self leftKeyIndexForNodeAt:aNodeIndex] with:[aNode mostLeftKey]];
    }
    else if (aNodeIndex != [self valueCount] - 1 && ![[aNode rightNode] isMin])
    {
        [aNode shuffleRightNode];
        [self replaceKeyAt:[self rightKeyIndexForNodeAt:aNodeIndex] with:[[aNode rightNode] mostLeftKey]];
    }
    else if (aNodeIndex != 0 && [aNode leftNode])
    {
        [[aNode leftNode] mergeRightNode];
        [self removeKeyAt:aNodeIndex - 1];
        [self removeNodeAt:aNodeIndex];
        
#ifdef DEBUG
        if ([self isUnderflow])
            NSLog(@"[self isUnderflow]");
#endif
    }
    else if (aNodeIndex != [self valueCount] - 1 && [aNode rightNode])
    {
        [[aNode rightNode] mergeLeftNode];
        [self removeKeyAt:aNodeIndex];
        [self removeNodeAt:aNodeIndex];
        
#ifdef DEBUG
        if ([self isUnderflow])
            NSLog(@"[self isUnderflow]");
#endif
    }
}

@end

@implementation NUOpaqueBTreeBranch (Modifying)

- (void)addNode:(NUUInt64)aNodeLocation
{
	[self insertNode:aNodeLocation at:[self valueCount]];
}

- (void)insertNode:(NUUInt64)aNodeLocation at:(NUUInt32)anIndex
{
#ifdef DEBUG
    if (aNodeLocation == 0)
        NSLog(@"aNodeLocation == 0");
#endif
    
	[self primitiveInsertNodes:(NUUInt8 *)&aNodeLocation at:anIndex count:1];
    [self nodeDidInsertValues:(NUUInt8 *)&aNodeLocation at:anIndex count:1];
}

- (void)insertNodes:(NUIndexArray *)aNodeLocations at:(NUUInt32)anIndex startAt:(NUUInt32)aStartIndex count:(NUUInt32)aCount
{
	[self primitiveInsertNodes:[aNodeLocations at:aStartIndex] at:anIndex count:aCount];
    [self nodeDidInsertValues:[aNodeLocations at:aStartIndex] at:anIndex count:aCount];
}

- (void)primitiveInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[self primitiveInsertValues:aNodeLocations at:anIndex count:aCount];
}

- (void)removeNodeAt:(NUUInt32)anIndex
{
	[self removeNodesAt:anIndex count:1];
}

- (void)removeNodesAt:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[self removeValuesAt:anIndex count:aCount];
}

- (void)replaceNodeAt:(NUUInt32)anIndex with:(NUUInt64)aNodeLocation
{
	[self replaceValueAt:anIndex with:(NUUInt8 *)&aNodeLocation];
}

- (NUOpaqueBTreeNode *)insertChildNode:(NUOpaqueBTreeNode *)aChildNode at:(NUUInt32)aChildNodeIndex
{
    NUUInt64 aChildNodePageLocation = [aChildNode pageLocation];
    NUOpaqueArray *aNewValues = [self insertOpaqueValue:(NUUInt8 *)&aChildNodePageLocation at:aChildNodeIndex];
    NUOpaqueArray *aNewKeys = [self insertOpaqueKey:[aChildNode mostLeftKey] at:aChildNodeIndex - 1];
    NUOpaqueBTreeBranch *aNewNode = nil;
    
    if (aChildNodeIndex < [self valueCount]) [self nodeDidInsertValues:[self valueAt:aChildNodeIndex] at:aChildNodeIndex count:1];
    
    if (aNewKeys)
    {
        aNewNode = [[self tree] makeBranchNodeWithKeys:aNewKeys values:aNewValues];
        [self insertRightNode:aNewNode];
        return aNewNode;
    }
    
    return nil;
}

- (NUOpaqueArray *)insertOpaqueKey:(NUUInt8 *)aKey at:(NUUInt32)anIndex
{
    if ([self isFull])
    {
        NUOpaqueArray *aTemporaryKeys = [[[self keys] copyWithCapacity:[self keyCapacity] + 1] autorelease];
        [aTemporaryKeys insert:aKey to:anIndex];
        [[self keys] setOpaqueValues:[aTemporaryKeys at:0] count:[self minKeyCount]];
        NUOpaqueArray *aNewKeys = [[self keys] copyWithoutValues];
        [aNewKeys setOpaqueValues:[aTemporaryKeys at:[self minKeyCount] + 1] count:[aTemporaryKeys count] - 1 - [self minKeyCount]];
        return aNewKeys;
    }
    else
    {
        [[self keys] insert:aKey to:anIndex];
        return nil;
    }
}

- (void)nodeDidInsertValues:(NUUInt8 *)aValues at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[super nodeDidInsertValues:aValues at:anIndex count:aCount];
	[self branchDidInsertNodes:aValues at:anIndex count:aCount];
}

- (void)branchDidInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[[self tree] branch:self didInsertNodes:aNodeLocations at:anIndex count:aCount];
}

- (void)setFirstNode:(NUOpaqueBTreeNode *)aFirstNode secondNode:(NUOpaqueBTreeNode *)aSecondNode key:(NUUInt8 *)aKey
{	
	[self addKey:aKey];
	[self addNode:[aFirstNode pageLocation]];
	[self addNode:[aSecondNode pageLocation]];
}

@end

@implementation NUOpaqueBTreeBranch (Balancing)

- (void)shuffleLeftNode
{
	NUUInt32 aKeyShuffleCount = [[self leftNode] shufflableKeyCount];
	NUUInt32 aKeyShuffleLocation = [[self leftNode] keyCount] - aKeyShuffleCount;
	
	[self insertKey:[self mostLeftKey] at:0];
	if (aKeyShuffleLocation + 1 != [[self leftNode] keyCount])
		[self insertKeys:[[self leftNode] keyAt:aKeyShuffleLocation + 1] at:0 count:aKeyShuffleCount - 1];
	[[self leftBranch] removeKeysAt:aKeyShuffleLocation count:aKeyShuffleCount];
		
//	[self insertNodes:[[self leftBranch] nodeLocations] at:0 startAt:aKeyShuffleLocation + 1 count:aKeyShuffleCount + 1];
//	[[self leftBranch] removeNodesAt:aKeyShuffleLocation + 1 count:aKeyShuffleCount + 1];
    
    [self insertNodes:[[self leftBranch] nodeLocations] at:0 startAt:aKeyShuffleLocation + 1 count:aKeyShuffleCount];
	[[self leftBranch] removeNodesAt:aKeyShuffleLocation + 1 count:aKeyShuffleCount];
    
    if ([[self leftBranch] isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
    if ([self isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
}

- (void)shuffleRightNode
{
	NUUInt32 aKeyShuffleCount = [[self rightNode] shufflableKeyCount];
	
	[self insertKey:[[self rightNode] mostLeftKey] at:[self keyCount]];
	[self insertKeys:[[self rightNode] keyAt:0] at:[self keyCount] count:aKeyShuffleCount - 1];
	[[self rightBranch] removeKeysAt:0 count:aKeyShuffleCount];
		
//	[self insertNodes:[[self rightBranch] nodeLocations] at:[self valueCount] startAt:0 count:aKeyShuffleCount + 1];
//	[[self rightBranch] removeNodesAt:0 count:aKeyShuffleCount + 1];
    
    [self insertNodes:[[self rightBranch] nodeLocations] at:[self valueCount] startAt:0 count:aKeyShuffleCount];
	[[self rightBranch] removeNodesAt:0 count:aKeyShuffleCount];
    
    if ([[self rightBranch] isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
    if ([self isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
}

- (void)mergeRightNode
{
	NUOpaqueBTreeBranch *aRightNode = [self rightBranch];
	[self insertKey:[aRightNode mostLeftKey] at:[self keyCount]];
	[self insertKeys:[aRightNode firstkey] at:[self keyCount] count:[aRightNode keyCount]];
	[aRightNode removeAllKeys];
	
	[self insertNodes:[aRightNode nodeLocations] at:[self valueCount] startAt:0 count:[aRightNode valueCount]];
	[aRightNode removeAllValues];
    
    [super mergeRightNode];
    
    if ([self isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
}

- (void)mergeLeftNode
{
	NUOpaqueBTreeBranch *aLeftNode = [self leftBranch];
	[self insertKey:[self mostLeftKey] at:0];
	[self insertKeys:[aLeftNode firstkey] at:0 count:[aLeftNode keyCount]];
	[aLeftNode removeAllKeys];
	
	[self insertNodes:[aLeftNode nodeLocations] at:0 startAt:0 count:[aLeftNode valueCount]];
	[aLeftNode removeAllValues];
    
    [super mergeLeftNode];
    
    if ([self isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
}

@end

@implementation NUOpaqueBTreeBranch (Testing)

- (BOOL)isBranch { return YES; }

@end

@implementation NUOpaqueBTreeBranch (ManagingPage)

- (void)changeNodePageWith:(NUUInt64)aPageLocation of:(NUOpaqueBTreeNode *)aNode
{
    NUUInt32 aNodeIndex = [self insertionTargetNodeIndexFor:[aNode firstkey]];
    NUOpaqueBTreeNode *aChildNode = [self nodeAt:aNodeIndex];
    
    if (![aChildNode isEqual:aNode])
        [[NSException exceptionWithName:@"NUBtreeNodeIsNotChildNodeException" reason:nil userInfo:nil] raise];
    
    [self replaceNodeAt:aNodeIndex with:aPageLocation];
}


- (void)fixVirtualNodes
{
	NUUInt32 i = 0;
	for (; i < [self valueCount]; i++)
	{
		NUUInt64 aNodePageLocation = [self nodeLocationAt:i];
		if ([[self spaces] nodePageLocationIsVirtual:aNodePageLocation])
		{
			NUUInt64 aRealNodePageLocation = [[self spaces] nodePageLocationForVirtualNodePageLocation:aNodePageLocation];
			[self replaceNodeAt:i with:aRealNodePageLocation];
		}
	}
}

@end
