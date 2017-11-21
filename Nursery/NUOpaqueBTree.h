//
//  NUOpaqueBTree.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUTypes.h"

@class NUOpaqueBTreeNode, NUOpaqueBTreeBranch, NUOpaqueBTreeLeaf, NUMainBranchNursery, NUPages, NUPage, NUOpaqueArray, NUSpaces, NUU64ODictionary;

@interface NUOpaqueBTree : NSObject
{
	NUOpaqueBTreeNode *root;
	NUUInt32 level;
	NUUInt32 keyLength;
	NUUInt32 leafValueLength;
	NUSpaces *spaces;
	NUUInt64 rootLocation;
	NUU64ODictionary *nodeDictionary;
}
@end

@interface NUOpaqueBTree (InitializingAndRelease)

- (id)initWithKeyLength:(NUUInt32)aKeyLength leafValueLength:(NUUInt32)aLeafValueLength rootLocation:(NUUInt64)aRootLocation on:(NUSpaces *)aSpaces;

@end

@interface NUOpaqueBTree (Accessing)

- (NUOpaqueBTreeNode *)root;
- (void)setRoot:(NUOpaqueBTreeNode *)aRoot;
- (NUOpaqueBTreeNode *)loadRoot;

- (NUMainBranchNursery *)nursery;
- (NUSpaces *)spaces;
- (NUPages *)pages;

- (NUUInt32)level;
- (NUUInt32)nodeHeaderLength;
- (NUUInt32)keyLength;
- (NUUInt32)branchValueLength;
- (NUUInt32)leafValueLength;
- (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator;
- (Class)branchNodeClass;
- (Class)leafNodeClass;
+ (NUUInt64)rootLocationOffset;

@end

@interface NUOpaqueBTree (GettingNode)

- (NUOpaqueBTreeLeaf *)leafNodeContainingKey:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex;
- (NUOpaqueBTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex;
- (NUOpaqueBTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(NUUInt8 *)aKey keyIndex:(NUUInt32 *)aKeyIndex;
- (NUOpaqueBTreeLeaf *)mostLeftNode;
- (NUOpaqueBTreeLeaf *)mostRightNode;

- (NUOpaqueBTreeBranch *)parentNodeOf:(NUOpaqueBTreeNode *)aNode;

@end

@interface NUOpaqueBTree (GettingAndSettingValue)

- (NUUInt8 *)valueFor:(NUUInt8 *)aKey;
- (void)setOpaqueValue:(NUUInt8 *)aValue forKey:(NUUInt8 *)aKey;
- (void)removeValueFor:(NUUInt8 *)aKey;

- (NUUInt8 *)firstKey;
- (NUUInt8 *)firstValue;

- (NUOpaqueBTreeLeaf *)getNextKeyIndex:(NUUInt32 *)aKeyIndex node:(NUOpaqueBTreeLeaf *)aNode;

@end

@interface NUOpaqueBTree (ManagingNodes)

- (NUOpaqueBTreeNode *)nodeFor:(NUUInt64)aNodeLocation;
- (NUOpaqueBTreeNode *)loadNodeFor:(NUUInt64)aNodeLocation;
- (NUOpaqueBTreeNode *)makeNodeFromPageAt:(NUUInt64)aPageLocation;
- (NUU64ODictionary *)nodeDictionary;

- (NUOpaqueBTreeBranch *)makeBranchNode;
- (NUOpaqueBTreeBranch *)makeBranchNodeWithKeys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aNodes;
- (NUOpaqueBTreeLeaf *)makeLeafNode;
- (NUOpaqueBTreeLeaf *)makeLeafNodeWithKeys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aValues;
- (NUOpaqueBTreeNode *)makeNodeOf:(Class)aNodeClass;
- (NUOpaqueBTreeNode *)makeNodeOf:(Class)aNodeClass keys:(NUOpaqueArray *)aKeys values:(NUOpaqueArray *)aValues;

- (NUUInt64)allocateNodePage;
- (void)releaseNodePage:(NUUInt64)aNodePage;

- (void)addNode:(NUOpaqueBTreeNode *)aNode;
- (void)removeNodeAt:(NUUInt64)aPageLocation;

- (void)updateRootLocationIfNeeded;

- (void)save;
- (void)load;
- (void)saveNodes;

@end

@interface NUOpaqueBTree (NodeDelegate)

- (void)branch:(NUOpaqueBTreeBranch *)aBranch didInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount;

@end

@interface NUOpaqueBTree (Debug)

- (void)validateAllNodeLocations;

@end
