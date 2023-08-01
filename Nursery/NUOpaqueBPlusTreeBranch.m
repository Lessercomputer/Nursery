//
//  NUOpaqueBPlusTreeBranch.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/27.
//

#import <Foundation/NSException.h>

#import "NUOpaqueBPlusTreeBranch.h"
#import "NUIndexArray.h"
#import "NUOpaqueBPlusTree.h"
#import "NURegionTree.h"
#import "NUSpaces.h"

NSString *NUBPlusTreeNodeIsNotChildNodeException = @"NUBPlusTreeNodeIsNotChildNodeException";

@implementation NUOpaqueBPlusTreeBranch
@end

@implementation NUOpaqueBPlusTreeBranch (Accessing)

- (NUUInt32)lastNodeIndex
{
	return [self valueCount] - 1;
}

- (NUOpaqueBPlusTreeBranch *)leftBranch
{
	return (NUOpaqueBPlusTreeBranch *)[self leftNode];
}

- (NUOpaqueBPlusTreeBranch *)rightBranch
{
	return  (NUOpaqueBPlusTreeBranch *)[self rightNode];
}

- (NUOpaqueBPlusTreeBranch *)parentNodeOf:(NUOpaqueBPlusTreeNode *)aNode
{
    if ([self isEqual:aNode]) return nil;
    
    NUOpaqueBPlusTreeNode *aChildNode = [self nodeAt:[self targetNodeIndexFor:[aNode mostLeftKeyInSubTree]]];
    
    if ([aChildNode isEqual:aNode]) return self;
    
    return [aChildNode parentNodeOf:aNode];
}

- (NUOpaqueBPlusTreeNode *)nodeAt:(NUUInt32)anIndex
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

- (NUUInt32)targetNodeIndexFor:(NUUInt8 *)aKey
{
	return [self keyIndexLessThanOrEqualToKey:aKey] + 1;
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKey:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return [[self nodeAt:[self targetNodeIndexFor:aKey]] leafNodeContainingKey:aKey keyIndex:aKeyIndex];
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return [[self nodeAt:[self targetNodeIndexFor:aKey]] leafNodeContainingKeyGreaterThanOrEqualTo:aKey keyIndex:aKeyIndex];
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return [[self nodeAt:[self targetNodeIndexFor:aKey]] leafNodeContainingKeyLessThanOrEqualTo:aKey keyIndex:aKeyIndex];
}

- (NUUInt8 *)mostLeftKeyInSubTree
{
    return [[self nodeAt:0] mostLeftKeyInSubTree];
}

- (NUOpaqueBPlusTreeLeaf *)mostLeftNode
{
	return [[self nodeAt:0] mostLeftNode];
}

- (NUOpaqueBPlusTreeLeaf *)mostRightNode
{
	return [[self nodeAt:[self valueCount] - 1] mostRightNode];
}

- (NUOpaqueArray *)makeValueArray
{
	return [[[NUIndexArray alloc] initWithCapacity:[self valueCapacity] comparator:[[self tree] comparator]] autorelease];
}

- (NUUInt8 *)valueFor:(NUUInt8 *)aKey
{
	NUUInt32 aNodeIndex = [self targetNodeIndexFor:aKey];
	NUOpaqueBPlusTreeNode *aNode = [self nodeAt:aNodeIndex];
	return [aNode valueFor:aKey];
}

- (NUOpaqueBPlusTreeNode *)setOpaqueValue:(NUUInt8 *)aValue forKey:(NUUInt8 *)aKey
{
	NUUInt32 aChildNodeIndex = [self targetNodeIndexFor:aKey];
	NUOpaqueBPlusTreeNode *aChildNode = [self nodeAt:aChildNodeIndex];
	NUOpaqueBPlusTreeNode *aSiblingNodeOfChildNode = [aChildNode setOpaqueValue:aValue forKey:aKey];
	
    if ([aChildNode isUnderflow] || [aSiblingNodeOfChildNode isUnderflow])
        @throw [NSException exceptionWithName:NUUnderflowNodeFoundException reason:nil userInfo:nil];
    
	if (aSiblingNodeOfChildNode)
		return [self insertChildNode:aSiblingNodeOfChildNode at:aChildNodeIndex + 1];
	
	return nil;
}

- (BOOL)removeValueFor:(NUUInt8 *)aKey
{
    BOOL aRemoved;
	NUUInt32 aNodeIndex = [self targetNodeIndexFor:aKey];
	NUOpaqueBPlusTreeNode *aNode = [self nodeAt:aNodeIndex];
    
	aRemoved = [aNode removeValueFor:aKey];
	
    if ([aNode isUnderflow])
    {
        if (aNodeIndex != 0 && ![[aNode leftNode] isMin])
        {
            [aNode shuffleLeftNode];
            [self replaceKeyAt:[self leftKeyIndexForNodeAt:aNodeIndex] with:[aNode mostLeftKeyInSubTree]];
        }
        else if (aNodeIndex != [self valueCount] - 1 && ![[aNode rightNode] isMin])
        {
            [aNode shuffleRightNode];
            [self replaceKeyAt:[self rightKeyIndexForNodeAt:aNodeIndex] with:[[aNode rightNode] mostLeftKeyInSubTree]];
        }
        else if (aNodeIndex != 0)
        {
            [[aNode leftNode] mergeRightNode];
            [self removeKeyAt:[self leftKeyIndexForNodeAt:aNodeIndex]];
            [self removeNodeAt:aNodeIndex];
        }
        else if (aNodeIndex != [self valueCount] - 1)
        {
            [[aNode rightNode] mergeLeftNode];
            [self removeKeyAt:[self rightKeyIndexForNodeAt:aNodeIndex]];
            [self removeNodeAt:aNodeIndex];
        }
        else
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil];
    }
    
    return aRemoved;
}

- (void)enumerateNodesUsingBlock:(void (^)(NUOpaqueBPlusTreeNode *aNode, BOOL *aStop))aBlock stopFlag:(BOOL *)aStop
{
    [super enumerateNodesUsingBlock:aBlock stopFlag:aStop];
    
    for (NUUInt32 i = 0; i < [self valueCount]; i++)
        [[self nodeAt:i] enumerateNodesUsingBlock:aBlock stopFlag:aStop];
}

@end

@implementation NUOpaqueBPlusTreeBranch (Modifying)

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

- (NUOpaqueBPlusTreeNode *)insertChildNode:(NUOpaqueBPlusTreeNode *)aChildNode at:(NUUInt32)aChildNodeIndex
{
    NUUInt64 aChildNodePageLocation = [aChildNode pageLocation];
    NUOpaqueArray *aNewValues = [self insertOpaqueValue:(NUUInt8 *)&aChildNodePageLocation at:aChildNodeIndex];
    NUOpaqueArray *aNewKeys = [self insertOpaqueKey:[aChildNode mostLeftKeyInSubTree] at:aChildNodeIndex - 1];
    NUOpaqueBPlusTreeBranch *aNewNode = nil;
    
    if (aChildNodeIndex < [self valueCount]) [self nodeDidInsertValues:[self valueAt:aChildNodeIndex] at:aChildNodeIndex count:1];
    
    if (aNewKeys)
    {
        aNewNode = [[self tree] makeBranchNodeWithKeys:aNewKeys values:aNewValues];
        [self insertRightNode:aNewNode];
        
        if ([aNewNode isUnderflow])
            @throw [NSException exceptionWithName:NUUnderflowNodeFoundException reason:nil userInfo:nil];
        if ([aNewKeys count] == [aNewValues count])
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil];
        
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
        NUOpaqueArray *aNewKeys = [[[self keys] copyWithoutValues] autorelease];
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

- (void)setFirstNode:(NUOpaqueBPlusTreeNode *)aFirstNode secondNode:(NUOpaqueBPlusTreeNode *)aSecondNode key:(NUUInt8 *)aKey
{	
	[self addKey:aKey];
	[self addNode:[aFirstNode pageLocation]];
	[self addNode:[aSecondNode pageLocation]];
    [aFirstNode setRightNodeLocation:[aSecondNode pageLocation]];
    [aSecondNode setLeftNodeLocation:[aFirstNode pageLocation]];
}

@end

@implementation NUOpaqueBPlusTreeBranch (Balancing)

- (void)shuffleLeftNode
{
	NUUInt32 aKeyShuffleCount = [[self leftNode] shufflableKeyCount];
	NUUInt32 aKeyShuffleLocation = [[self leftNode] keyCount] - aKeyShuffleCount;
	
	[self insertKey:[self mostLeftKeyInSubTree] at:0];
	if (aKeyShuffleLocation + 1 != [[self leftNode] keyCount])
		[self insertKeys:[[self leftNode] keyAt:aKeyShuffleLocation + 1] at:0 count:aKeyShuffleCount - 1];
	[[self leftBranch] removeKeysAt:aKeyShuffleLocation count:aKeyShuffleCount];
    
    [self insertNodes:[[self leftBranch] nodeLocations] at:0 startAt:aKeyShuffleLocation + 1 count:aKeyShuffleCount];
	[[self leftBranch] removeNodesAt:aKeyShuffleLocation + 1 count:aKeyShuffleCount];
    
    if ([[self leftBranch] isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:nil userInfo:nil] raise];
    if ([self isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:nil userInfo:nil] raise];
}

- (void)shuffleRightNode
{
	NUUInt32 aKeyShuffleCount = [[self rightNode] shufflableKeyCount];
	
	[self insertKey:[[self rightNode] mostLeftKeyInSubTree] at:[self keyCount]];
	[self insertKeys:[[self rightNode] firstkey] at:[self keyCount] count:aKeyShuffleCount - 1];
	[[self rightBranch] removeKeysAt:0 count:aKeyShuffleCount];
    
    [self insertNodes:[[self rightBranch] nodeLocations] at:[self valueCount] startAt:0 count:aKeyShuffleCount];
	[[self rightBranch] removeNodesAt:0 count:aKeyShuffleCount];
    
    if ([[self rightBranch] isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:nil userInfo:nil] raise];
    if ([self isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:nil userInfo:nil] raise];
}

- (void)mergeRightNode
{
	NUOpaqueBPlusTreeBranch *aRightNode = [self rightBranch];
	[self insertKey:[aRightNode mostLeftKeyInSubTree] at:[self keyCount]];
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
	NUOpaqueBPlusTreeBranch *aLeftNode = [self leftBranch];
	[self insertKeys:[aLeftNode firstkey] at:0 count:[aLeftNode keyCount]];
    [self insertKey:[self mostLeftKeyInSubTree] at:[aLeftNode keyCount]];
	[aLeftNode removeAllKeys];
	
	[self insertNodes:[aLeftNode nodeLocations] at:0 startAt:0 count:[aLeftNode valueCount]];
	[aLeftNode removeAllValues];
    
    [super mergeLeftNode];
    
    if ([self isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
}

@end

@implementation NUOpaqueBPlusTreeBranch (Testing)

- (BOOL)isBranch { return YES; }

- (BOOL)nodeIsMostLeftNodeInDepthOf:(NUOpaqueBPlusTreeNode *)aNode
{
    return aNode == self || [[self nodeAt:0] nodeIsMostLeftNodeInDepthOf:aNode];
}

- (BOOL)nodeIsMostRightNodeInDepthOf:(NUOpaqueBPlusTreeNode *)aNode
{
    return aNode == self || [[self nodeAt:[self valueCount] - 1] nodeIsMostRightNodeInDepthOf:aNode];
}

@end

@implementation NUOpaqueBPlusTreeBranch (ManagingPage)

- (void)changeNodePageWith:(NUUInt64)aPageLocation of:(NUOpaqueBPlusTreeNode *)aNode
{
    NUUInt32 aNodeIndex = [self targetNodeIndexFor:[aNode mostLeftKeyInSubTree]];
    NUOpaqueBPlusTreeNode *aChildNode = [self nodeAt:aNodeIndex];
    
    if (![aChildNode isEqual:aNode])
        [[NSException exceptionWithName:NUBPlusTreeNodeIsNotChildNodeException reason:nil userInfo:nil] raise];
    
    [self replaceNodeAt:aNodeIndex with:aPageLocation];
}

@end
