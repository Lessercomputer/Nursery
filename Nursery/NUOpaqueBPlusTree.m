//
//  NUOpaqueBPlusTree.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSException.h>

#import "NUOpaqueBPlusTree.h"
#import "NUOpaqueBPlusTreeNode.h"
#import "NUOpaqueBPlusTreeBranch.h"
#import "NUOpaqueBPlusTreeLeaf.h"
#import "NUPages.h"
#import "NUPage.h"
#import "NUOpaqueArray.h"
#import "NUSpaces.h"
#import "NUPageLocationODictionary.h"

@implementation NUOpaqueBPlusTree
@end

@implementation NUOpaqueBPlusTree (InitializingAndRelease)

- (id)initWithKeyLength:(NUUInt32)aKeyLength leafValueLength:(NUUInt32)aLeafValueLength rootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces
{
	[super init];
	
	keyLength = aKeyLength;
	leafValueLength = aLeafValueLength;
	spaces = aSpaces;
	rootLocation = aRootLocation;
	nodeDictionary = [[NUPageLocationODictionary alloc] initWithPages:[spaces pages]];
	
	return self;
}

- (void)dealloc
{
	[nodeDictionary release];
	
	[super dealloc];
}

@end

@implementation NUOpaqueBPlusTree (Accessing)

- (NUOpaqueBPlusTreeNode *)root
{
	if (!root) [self setRoot:[self loadRoot]];
	return root;
}

- (void)setRoot:(NUOpaqueBPlusTreeNode *)aRoot
{
	[root autorelease];
	root = [aRoot retain];
}

- (NUOpaqueBPlusTreeNode *)loadRoot
{
	NUOpaqueBPlusTreeNode *aRoot = [self nodeFor:rootLocation];
	return aRoot ? aRoot : [self makeLeafNode];
}

- (NUMainBranchNursery *)nursery
{
    return [[self spaces] nursery];
}

- (NUSpaces *)spaces
{
	return spaces;
}

- (NUPages *)pages
{
	return [[self spaces] pages];
}

- (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator
{
	return NULL;
}

- (NUUInt32)level
{
	return level;
}

- (NUUInt32)nodeHeaderLength
{
	return sizeof(NUUInt64) * 3 + sizeof(NUUInt32);
}

- (NUUInt32)keyLength
{
	return keyLength;
}

- (NUUInt32)branchValueLength
{
	return sizeof(NUUInt64);
}

- (NUUInt32)leafValueLength
{
	return leafValueLength;
}

- (Class)branchNodeClass
{
	return Nil;
}

- (Class)leafNodeClass
{
	return Nil;
}

+ (NUUInt64)rootLocationOffset
{
	return 0;
}

@end

@implementation NUOpaqueBPlusTree (GettingNode)

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKey:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return [[self root] leafNodeContainingKey:aKey keyIndex:aKeyIndex];
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return [[self root] leafNodeContainingKeyGreaterThanOrEqualTo:aKey keyIndex:aKeyIndex];
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
	return [[self root] leafNodeContainingKeyLessThanOrEqualTo:aKey keyIndex:aKeyIndex];
}

- (NUOpaqueBPlusTreeLeaf *)mostLeftNode
{
	return [[self root] mostLeftNode];
}

- (NUOpaqueBPlusTreeLeaf *)mostRightNode
{
	return [[self root] mostRightNode];
}

- (NUOpaqueBPlusTreeBranch *)parentNodeOf:(NUOpaqueBPlusTreeNode *)aNode
{
    if ([[self root] isLeaf]) return nil;
    
    return [[self root] parentNodeOf:aNode];
}

@end

@implementation NUOpaqueBPlusTree (GettingAndSettingValue)

- (NUUInt8 *)valueFor:(NUUInt8 *)aKey
{
	return [[self root] valueFor:aKey];
}

- (void)setOpaqueValue:(NUUInt8 *)aValue forKey:(NUUInt8 *)aKey
{
	NUOpaqueBPlusTreeNode *aSplitNode = [[self root] setOpaqueValue:aValue forKey:aKey];
	if (!aSplitNode) return;
	
    if ([[self root] isUnderflow] || [aSplitNode isUnderflow])
        [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
    
	NUOpaqueBPlusTreeBranch *aNewRootNode = [self makeBranchNode];
	[aNewRootNode setFirstNode:[self root] secondNode:aSplitNode key:[aSplitNode mostLeftKey]];
	[self setRoot:aNewRootNode];
}

- (void)removeValueFor:(NUUInt8 *)aKey
{
	[[self root] removeValueFor:aKey];
	
	if ([[self root] isBranch] && [[self root] valueCount] == 1)
	{
		[[self root] releaseNodePageAndCache];
		[self setRoot:[(NUOpaqueBPlusTreeBranch *)[self root] nodeAt:0]];
	}
}

- (NUUInt8 *)firstKey
{
	return [[self mostLeftNode] firstkey];
}

- (NUUInt8 *)firstValue
{
	return [[self mostLeftNode] firstValue];
}

- (NUOpaqueBPlusTreeLeaf *)getNextKeyIndex:(NUUInt32 *)aKeyIndex node:(NUOpaqueBPlusTreeLeaf *)aNode
{
    if (!aKeyIndex)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:NSInvalidArgumentException userInfo:nil];
    
    if (!aNode)
        return nil;
    
    if (*aKeyIndex == NUNotFound32)
    {
        if ([aNode isEmpty])
            return nil;
        else
        {
            *aKeyIndex = 0;
            return (NUOpaqueBPlusTreeLeaf *)aNode;
        }
    }
    
    if (*aKeyIndex + 1 < [aNode keyCount])
    {
        (*aKeyIndex)++;
        return (NUOpaqueBPlusTreeLeaf *)aNode;
    }
    else
    {
        *aKeyIndex = 0;
        return (NUOpaqueBPlusTreeLeaf *)[aNode rightNode];
    }
}

@end

@implementation NUOpaqueBPlusTree (ManagingNodes)

- (NUOpaqueBPlusTreeNode *)nodeFor:(NUUInt64)aNodeLocation
{
	if (!aNodeLocation) return nil;
	
	NUOpaqueBPlusTreeNode *aNode = [[self nodeDictionary] objectForKey:aNodeLocation];
	
	if (!aNode && ![[self spaces] nodePageLocationIsVirtual:aNodeLocation])
	{
		aNode = [self loadNodeFor:aNodeLocation];
		[[self nodeDictionary] setObject:aNode forKey:aNodeLocation];
	}
	
	return aNode;
}

- (NUOpaqueBPlusTreeNode *)loadNodeFor:(NUUInt64)aNodeLocation
{
	return [self makeNodeFromPageAt:aNodeLocation];
}

- (NUOpaqueBPlusTreeNode *)makeNodeFromPageAt:(NUUInt64)aPageLocation
{
	NUUInt64 aNodeOOP = [[self pages] readUInt64At:0 of:aPageLocation];
	NUOpaqueBPlusTreeNode *aNode = nil;
	
	if (aNodeOOP == [[self leafNodeClass] nodeOOP])
		aNode = [[self leafNodeClass] nodeWithTree:self pageLocation:aPageLocation];
	else if (aNodeOOP == [[self branchNodeClass] nodeOOP])
		aNode = [[self branchNodeClass] nodeWithTree:self pageLocation:aPageLocation];

	return aNode;
}

- (NUU64ODictionary *)nodeDictionary
{
	return nodeDictionary;
}

- (NUOpaqueBPlusTreeBranch *)makeBranchNode
{
	return (NUOpaqueBPlusTreeBranch *)[self makeNodeOf:[self branchNodeClass]];
}

- (NUOpaqueBPlusTreeBranch *)makeBranchNodeWithKeys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aNodes
{
	return (NUOpaqueBPlusTreeBranch *)[self makeNodeOf:[self branchNodeClass] keys:aKeys values:aNodes];
}

- (NUOpaqueBPlusTreeLeaf *)makeLeafNode
{
	return (NUOpaqueBPlusTreeLeaf *)[self makeNodeOf:[self leafNodeClass]];
}

- (NUOpaqueBPlusTreeLeaf *)makeLeafNodeWithKeys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aValues
{
	return (NUOpaqueBPlusTreeLeaf *)[self makeNodeOf:[self leafNodeClass] keys:aKeys values:aValues];
}

- (NUOpaqueBPlusTreeNode *)makeNodeOf:(Class)aNodeClass
{
	return [self makeNodeOf:aNodeClass keys:nil values:nil];
}

- (NUOpaqueBPlusTreeNode *)makeNodeOf:(Class)aNodeClass keys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aValues
{
	NUOpaqueBPlusTreeNode *aNode = [aNodeClass nodeWithTree:self pageLocation:[self allocateNodePage] keys:aKeys values:aValues];
	[self addNode:aNode];
	return aNode;
}

- (NUUInt64)allocateNodePage
{
	return [[self spaces] allocateNodePage];
}

- (void)releaseNodePage:(NUUInt64)aNodePage
{
	[[self spaces] releaseNodePage:aNodePage];
}

- (void)addNode:(NUOpaqueBPlusTreeNode *)aNode
{
	[[self nodeDictionary] setObject:aNode forKey:[aNode pageLocation]];
}

- (void)removeNodeAt:(NUUInt64)aPageLocation
{
	[[self nodeDictionary] removeObjectForKey:aPageLocation];
}

- (void)updateRootLocationIfNeeded
{
    NUUInt64 aRootLocation = [[self root] pageLocation];
    
    if (rootLocation != aRootLocation)
        rootLocation = aRootLocation;
}

- (void)save
{
	if (root) rootLocation = [[self root] pageLocation];
	[[self pages] writeUInt64:rootLocation at:[[self class] rootLocationOffset]];
	[self saveNodes];
    
#ifdef DEBUG
    NSLog(@"%@ #save rootLocation:%llu", [self class], rootLocation);
#endif
}

- (void)load
{
	if (rootLocation == 0) rootLocation = [[self pages] readUInt64At:[[self class] rootLocationOffset]];
}

- (void)saveNodes
{
	NSEnumerator *anEnumerator = [[self nodeDictionary] objectEnumerator];
	NUOpaqueBPlusTreeNode *aNode;
	
	while (aNode = [anEnumerator nextObject])
		if ([aNode isChanged]) [aNode save];
}

@end

@implementation NUOpaqueBPlusTree (NodeDelegate)

- (void)branch:(NUOpaqueBPlusTreeBranch *)aBranch didInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
}

@end

@implementation NUOpaqueBPlusTree (Debug)

- (void)validateAllNodeLocations
{
    if (rootLocation % [[self pages] pageSize] != 0)
        [[NSException exceptionWithName:NUInvalidPageLocationException reason:NUInvalidPageLocationException userInfo:nil] raise];
    
    [[self root] validateAllNodeLocations];
}

@end
