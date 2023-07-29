//
//  NUOpaqueBPlusTreeBranch.h
//  Nursery
//
//  Created by Akifumi Takata on 10/10/27.
//

#import "NUOpaqueBPlusTreeNode.h"

@class NUIndexArray;

extern NSString *NUBPlusTreeNodeIsNotChildNodeException;

@interface NUOpaqueBPlusTreeBranch : NUOpaqueBPlusTreeNode
{
}
@end

@interface NUOpaqueBPlusTreeBranch (Accessing)

- (NUUInt32)lastNodeIndex;
- (NUUInt32)targetNodeIndexFor:(NUUInt8 *)aKey;
- (NUOpaqueBPlusTreeNode *)nodeAt:(NUUInt32)anIndex;
- (NUUInt64)nodeLocationAt:(NUUInt32)anIndex;
- (NUIndexArray *)nodeLocations;

- (NUUInt32)leftKeyIndexForNodeAt:(NUUInt32)anIndex;
- (NUUInt32)rightKeyIndexForNodeAt:(NUUInt32)anIndex;

- (NUOpaqueBPlusTreeBranch *)leftBranch;
- (NUOpaqueBPlusTreeBranch *)rightBranch;

- (NUOpaqueBPlusTreeBranch *)parentNodeOf:(NUOpaqueBPlusTreeNode *)aNode;

@end

@interface NUOpaqueBPlusTreeBranch (Modifying)

- (void)addNode:(NUUInt64)aNodeLocation;
- (void)insertNode:(NUUInt64)aNodeLocation at:(NUUInt32)anIndex;
- (void)insertNodes:(NUIndexArray *)aNodeLocations at:(NUUInt32)anIndex startAt:(NUUInt32)aStartIndex count:(NUUInt32)aCount;
- (void)primitiveInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)removeNodeAt:(NUUInt32)anIndex;
- (void)removeNodesAt:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)replaceNodeAt:(NUUInt32)anIndex with:(NUUInt64)aNodeLocation;

- (NUOpaqueBPlusTreeNode *)insertChildNode:(NUOpaqueBPlusTreeNode *)aChildNode at:(NUUInt32)aChildNodeIndex;

- (void)branchDidInsertNodes:(NUUInt8 *)aNodeLocations at:(NUUInt32)anIndex count:(NUUInt32)aCount;

- (void)setFirstNode:(NUOpaqueBPlusTreeNode *)aFirstNode secondNode:(NUOpaqueBPlusTreeNode *)aSecondNode key:(NUUInt8 *)aKey;

@end

@interface NUOpaqueBPlusTreeBranch (ManagingPage)

@end
