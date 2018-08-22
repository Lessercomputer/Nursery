//
//  NUOpaqueBPlusTreeLeaf.h
//  Nursery
//
//  Created by Akifumi Takata on 10/10/27.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUOpaqueBPlusTreeNode.h"


@interface NUOpaqueBPlusTreeLeaf : NUOpaqueBPlusTreeNode
{
}
@end

@interface NUOpaqueBPlusTreeLeaf (Accessing)

- (NSArray *)insertNewExtraValueTo:(NUUInt32)anIndex;
- (void)setExtraValues:(NSArray *)anExtraValues;

- (void)removeExtraValueAt:(NUUInt32)anIndex;

@end

@interface NUOpaqueBPlusTreeLeaf (Balancing)

- (void)shuffleLeftNodeKeysOrValues:(NUOpaqueArray *)aLeftArray with:(NUOpaqueArray *)aRightArray;
- (void)shuffleRightNodeKeysOrValues:(NUOpaqueArray *)aLeftArray with:(NUOpaqueArray *)aRightArray;

- (void)mergeNode:(NUOpaqueBPlusTreeLeaf *)aNode;

- (void)shuffleExtraValuesOfLeftNode;
- (void)shuffleExtraValuesOfRightNode;
- (void)mergeExtraValuesOfLeftNode:(NUOpaqueBPlusTreeLeaf *)aNode;
- (void)mergeExtraValuesOfRightNode:(NUOpaqueBPlusTreeLeaf *)aNode;

@end
