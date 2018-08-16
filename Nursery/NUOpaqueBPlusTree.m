//
//  NUOpaqueBPlusTree.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSException.h>
#import <Foundation/NSLock.h>

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
	if (self = [super init])
    {
        keyLength = aKeyLength;
        leafValueLength = aLeafValueLength;
        spaces = aSpaces;
        rootLocation = aRootLocation;
        nodeDictionary = [[NUPageLocationODictionary alloc] initWithPages:[spaces pages]];
        lock = [NSRecursiveLock new];
    }
    
	return self;
}

- (void)dealloc
{
	[nodeDictionary release];
    [lock release];

	[super dealloc];
}

@end

@implementation NUOpaqueBPlusTree (Accessing)

- (NUOpaqueBPlusTreeNode *)root
{
    [self lock];
    
	if (!root) [self setRoot:[self loadRoot]];
    
    [self unlock];
    
	return root;
}

- (void)setRoot:(NUOpaqueBPlusTreeNode *)aRoot
{
	[root autorelease];
	root = [aRoot retain];
}

- (NUOpaqueBPlusTreeNode *)loadRoot
{
    [self lock];
    
	NUOpaqueBPlusTreeNode *aRoot = [self nodeFor:rootLocation];
	if (!aRoot) aRoot = [self makeLeafNode];
    
    [self unlock];
    
    return aRoot;
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

- (void)lock
{
    [lock lock];
}

- (void)unlock
{
    [lock unlock];
}

@end

@implementation NUOpaqueBPlusTree (GettingNode)

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKey:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
    NUOpaqueBPlusTreeLeaf *aLeafNode;
    
    [self lock];
    
	aLeafNode = [[self root] leafNodeContainingKey:aKey keyIndex:aKeyIndex];
    
    [self unlock];
    
    return aLeafNode;
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
    NUOpaqueBPlusTreeLeaf *aLeafNode;
    
    [self lock];
    
	aLeafNode = [[self root] leafNodeContainingKeyGreaterThanOrEqualTo:aKey keyIndex:aKeyIndex];
    
    [self unlock];
    
    return aLeafNode;
}

- (NUOpaqueBPlusTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex
{
    NUOpaqueBPlusTreeLeaf *aLeafNode;
    
    [self lock];
    
	aLeafNode = [[self root] leafNodeContainingKeyLessThanOrEqualTo:aKey keyIndex:aKeyIndex];
    
    [self unlock];
    
    return aLeafNode;
}

- (NUOpaqueBPlusTreeLeaf *)mostLeftNode
{
    NUOpaqueBPlusTreeLeaf *aLeafNode;
    
    [self lock];
    
	aLeafNode = [[self root] mostLeftNode];
    
    [self unlock];
    
    return aLeafNode;
}

- (NUOpaqueBPlusTreeLeaf *)mostRightNode
{
    NUOpaqueBPlusTreeLeaf *aLeafNode;
    
    [self lock];
    
	aLeafNode = [[self root] mostRightNode];
    
    [self unlock];
    
    return aLeafNode;
}

- (NUOpaqueBPlusTreeBranch *)parentNodeOf:(NUOpaqueBPlusTreeNode *)aNode
{
    NUOpaqueBPlusTreeBranch *aParentNode = nil;
    
    [self lock];
    
    if (![aNode isRoot] && ![[self root] isLeaf])
        aParentNode = [[self root] parentNodeOf:aNode];
    
    [self unlock];
    
    return aParentNode;
}

@end

@implementation NUOpaqueBPlusTree (GettingAndSettingValue)

- (NUUInt8 *)valueFor:(NUUInt8 *)aKey
{
    [self lock];
    
    NUUInt8 *aValue = [[self root] valueFor:aKey];
    
    [self unlock];
    
    return aValue;
}

- (void)setOpaqueValue:(NUUInt8 *)aValue forKey:(NUUInt8 *)aKey
{
    @try
    {
        [self lock];
        
        NUOpaqueBPlusTreeNode *aSplitNode = [[self root] setOpaqueValue:aValue forKey:aKey];
        
        if (aSplitNode)
        {
            if ([aSplitNode isUnderflow])
                [[NSException exceptionWithName:NUUnderflowNodeFoundException reason:NUUnderflowNodeFoundException userInfo:nil] raise];
            
            NUOpaqueBPlusTreeBranch *aNewRootNode = [self makeBranchNode];
            [aNewRootNode setFirstNode:[self root] secondNode:aSplitNode key:[aSplitNode mostLeftKeyInSubTree]];
            [self setRoot:aNewRootNode];
            
            if ([[self mostLeftNode] leftNode])
                [self class];
        }
    }
    @finally
    {
        [self unlock];
    }
}

- (void)removeValueFor:(NUUInt8 *)aKey
{
    [self lock];

    [[self root] removeValueFor:aKey];
	
	if ([[self root] isBranch] && [[self root] valueCount] == 1)
	{
		[[self root] releaseNodePageAndCache];
        NUOpaqueBPlusTreeNode *aNewRoot = [(NUOpaqueBPlusTreeBranch *)[self root] nodeAt:0];
        [aNewRoot setLeftNodeLocation:0];
        [aNewRoot setRightNodeLocation:0];
		[self setRoot:aNewRoot];
	}
    
//    if ([[self mostLeftNode] leftNode])
//        [self class];
    
    [self unlock];
}

- (void)updateKey:(NUUInt8 *)aKey
{
    [[self root] updateKey:aKey];
}

- (NUUInt8 *)firstKey
{
    NUUInt8 *aFirstKey;
    
    [self lock];
    
	aFirstKey = [[self mostLeftNode] firstkey];
    
    [self unlock];
    
    return aFirstKey;
}

- (NUUInt8 *)firstValue
{
    NUUInt8 *aFirstValue;
    
    [self lock];
    
    aFirstValue = [[self mostLeftNode] firstValue];
    
    [self unlock];
    
    return aFirstValue;
}

- (NUOpaqueBPlusTreeLeaf *)getNextKeyIndex:(NUUInt32 *)aKeyIndex node:(NUOpaqueBPlusTreeLeaf *)aNode
{
    if (!aKeyIndex)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:NSInvalidArgumentException userInfo:nil];
    
    if (!aNode)
        return nil;
   
    NUOpaqueBPlusTreeLeaf *aLeafNode = nil;
    
    [self lock];
    
    if (*aKeyIndex == NUNotFound32)
    {
        if (![aNode isEmpty])
        {
            *aKeyIndex = 0;
            aLeafNode = (NUOpaqueBPlusTreeLeaf *)aNode;
        }
    }
    
    if (*aKeyIndex + 1 < [aNode keyCount])
    {
        (*aKeyIndex)++;
        aLeafNode = (NUOpaqueBPlusTreeLeaf *)aNode;
    }
    else
    {
        *aKeyIndex = 0;
        aLeafNode = (NUOpaqueBPlusTreeLeaf *)[aNode rightNode];
    }
    
    [self unlock];
    
    return aLeafNode;
}

@end

@implementation NUOpaqueBPlusTree (ManagingNodes)

- (NUOpaqueBPlusTreeNode *)nodeFor:(NUUInt64)aNodeLocation
{
    NUOpaqueBPlusTreeNode *aNode = nil;
    
    @try
    {
        [self lock];
        
        if (aNodeLocation)
        {
            if (aNodeLocation % [[self pages] pageSize])
                [NSException exceptionWithName:NUInvalidPageLocationException reason:NUInvalidPageLocationException userInfo:nil];
            
            if (aNodeLocation == 36864)
                [self class];
            
            aNode = [[self nodeDictionary] objectForKey:aNodeLocation];
            
            if (!aNode && ![[self spaces] nodePageLocationIsVirtual:aNodeLocation])
            {
                if (aNodeLocation == 36864)
                    [self class];
                aNode = [self loadNodeFor:aNodeLocation];
                if (aNode) [[self nodeDictionary] setObject:aNode forKey:aNodeLocation];
                else
                    [self class];
            }
        }
    }
	@finally
    {
        [self unlock];
    }
    
    return aNode;
}

- (NUOpaqueBPlusTreeNode *)loadNodeFor:(NUUInt64)aNodeLocation
{
    if (aNodeLocation == 36864)
        [self class];
	return [self makeNodeFromPageAt:aNodeLocation];
}

- (NUOpaqueBPlusTreeNode *)makeNodeFromPageAt:(NUUInt64)aPageLocation
{
    [self lock];
    [[self pages] lock];
    
	NUUInt64 aNodeOOP = [[self pages] readUInt64At:0 of:aPageLocation];
	NUOpaqueBPlusTreeNode *aNode = nil;
	
	if (aNodeOOP == [[self leafNodeClass] nodeOOP])
        aNode = [[self leafNodeClass] nodeWithTree:self pageLocation:aPageLocation loadFromPage:YES keys:nil values:nil];
	else if (aNodeOOP == [[self branchNodeClass] nodeOOP])
		aNode = [[self branchNodeClass] nodeWithTree:self pageLocation:aPageLocation loadFromPage:YES keys:nil values:nil];

    [[self pages] unlock];
    [self unlock];
    
	return aNode;
}

- (NUPageLocationODictionary *)nodeDictionary
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
    [self lock];
    
    NUOpaqueBPlusTreeNode *aNode = [aNodeClass nodeWithTree:self pageLocation:[self allocateNodePageLocation] loadFromPage:NO keys:aKeys values:aValues];
	[self addNode:aNode];
    
    [self unlock];
    
	return aNode;
}

- (NUUInt64)allocateNodePageLocation
{
	return [[self spaces] allocateNodePageLocation];
}

- (void)releaseNodePageLocation:(NUUInt64)aNodePage
{
    if (aNodePage == 36864)
        [self class];
	[[self spaces] releaseNodePageAt:aNodePage];
}

- (void)addNode:(NUOpaqueBPlusTreeNode *)aNode
{
    [self lock];
    
	[[self nodeDictionary] setObject:aNode forKey:[aNode pageLocation]];
    
    [self unlock];
}

- (void)removeNodeAt:(NUUInt64)aPageLocation
{
    [self lock];
    
    NSLog(@"removeNodeAt:%@", @(aPageLocation));
	[[self nodeDictionary] removeObjectForKey:aPageLocation];
    
    [self unlock];
}

- (void)updateRootLocationIfNeeded
{
    [self lock];
    
    NUUInt64 aRootLocation = [[self root] pageLocation];
    
    if (rootLocation != aRootLocation)
        rootLocation = aRootLocation;
    
    [self unlock];
}

- (void)save
{
    [self lock];
    
	if (root) rootLocation = [[self root] pageLocation];
	[[self pages] writeUInt64:rootLocation at:[[self class] rootLocationOffset]];
	[self saveNodes];
    
    [self unlock];
    
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
    [self lock];
    
	NSEnumerator *anEnumerator = [[self nodeDictionary] objectEnumerator];
	NUOpaqueBPlusTreeNode *aNode;
	
	while (aNode = [anEnumerator nextObject])
		if ([aNode isChanged]) [aNode save];
    
    [self unlock];
}

@end

@implementation NUOpaqueBPlusTree (NodeDelegate)

- (void)branch:(NUOpaqueBPlusTreeBranch *)aBranch didInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount
{
}

@end

@implementation NUOpaqueBPlusTree (Testing)

- (BOOL)nodeIsRoot:(NUOpaqueBPlusTreeNode *)aNode
{
    return [self root] == aNode;
}

- (BOOL)nodeIsMostLeftNodeInDepthOf:(NUOpaqueBPlusTreeNode *)aNode
{
    BOOL aNodeIsMostLeft;
    
    [self lock];
    
    aNodeIsMostLeft = [[self root] nodeIsMostLeftNodeInDepthOf:aNode];
    
    [self unlock];
    
    return aNodeIsMostLeft;
}

- (BOOL)nodeIsMostRightNodeInDepthOf:(NUOpaqueBPlusTreeNode *)aNode
{
    BOOL aNodeIsMostRight;
    
    [self lock];
    
    aNodeIsMostRight = [[self root] nodeIsMostRightNodeInDepthOf:aNode];
    
    [self unlock];
    
    return aNodeIsMostRight;
}

@end

@implementation NUOpaqueBPlusTree (Debug)

- (void)validate
{
    [self lock];
    
    if (rootLocation % [[self pages] pageSize] != 0)
        [[NSException exceptionWithName:NUInvalidPageLocationException reason:NUInvalidPageLocationException userInfo:nil] raise];
    
    [[self root] validate];
    
    [self unlock];
}

@end
