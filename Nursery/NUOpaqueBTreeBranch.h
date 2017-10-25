//
//  NUOpaqueBTreeBranch.h
//  Nursery
//
//  Created by P,T,A on 10/10/27.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUOpaqueBTreeNode.h>

@class NUIndexArray;

extern NSString *NUBtreeNodeIsNotChildNodeException;

@interface NUOpaqueBTreeBranch : NUOpaqueBTreeNode
{

}
@end

@interface NUOpaqueBTreeBranch (Accessing)

- (NUUInt32)lastNodeIndex;
- (NUUInt32)insertionTargetNodeIndexFor:(NUUInt8 *)aKey;
- (NUUInt32)nodeIndexForKeyLessThanOrEqualTo:(NUUInt8 *)aKey;
- (NUOpaqueBTreeNode *)nodeAt:(NUUInt32)anIndex;
- (NUUInt64)nodeLocationAt:(NUUInt32)anIndex;
- (NUIndexArray *)nodeLocations;

- (NUUInt32)leftKeyIndexForNodeAt:(NUUInt32)anIndex;
- (NUUInt32)rightKeyIndexForNodeAt:(NUUInt32)anIndex;

- (NUOpaqueBTreeBranch *)leftBranch;
- (NUOpaqueBTreeBranch *)rightBranch;

- (NUOpaqueBTreeBranch *)parentNodeOf:(NUOpaqueBTreeNode *)aNode;

@end

@interface NUOpaqueBTreeBranch (Modifying)

- (void)addNode:(NUUInt64)aNodeLocation;
- (void)insertNode:(NUUInt64)aNodeLocation at:(NUUInt32)anIndex;
- (void)insertNodes:(NUIndexArray *)aNodeLocations at:(NUUInt32)anIndex startAt:(NUUInt32)aStartIndex count:(NUUInt32)aCount;
- (void)primitiveInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)removeNodeAt:(NUUInt32)anIndex;
- (void)removeNodesAt:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)replaceNodeAt:(NUUInt32)anIndex with:(NUUInt64)aNodeLocation;

- (NUOpaqueBTreeNode *)insertChildNode:(NUOpaqueBTreeNode *)aChildNode at:(NUUInt32)aChildNodeIndex;

- (void)branchDidInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount;

- (void)setFirstNode:(NUOpaqueBTreeNode *)aFirstNode secondNode:(NUOpaqueBTreeNode *)aSecondNode key:(NUUInt8 *)aKey;

@end

@interface NUOpaqueBTreeBranch (ManagingPage)

- (void)fixVirtualNodes;

@end
