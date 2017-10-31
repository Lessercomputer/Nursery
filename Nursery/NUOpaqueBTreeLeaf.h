//
//  NUOpaqueBTreeLeaf.h
//  Nursery
//
//  Created by Akifumi Takata on 10/10/27.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUOpaqueBTreeNode.h>


@interface NUOpaqueBTreeLeaf : NUOpaqueBTreeNode
{

}
@end

@interface NUOpaqueBTreeLeaf (Accessing)

- (NSArray *)insertNewExtraValueTo:(NUUInt32)anIndex;
- (void)setExtraValues:(NSArray *)anExtraValues;

- (void)removeExtraValueAt:(NUUInt32)anIndex;

@end

@interface NUOpaqueBTreeLeaf (Balancing)

- (void)shuffleLeftNodeKeysOrValues:(NUOpaqueArray *)aLeftArray with:(NUOpaqueArray *)aRightArray;
- (void)shuffleRightNodeKeysOrValues:(NUOpaqueArray *)aLeftArray with:(NUOpaqueArray *)aRightArray;

- (void)mergeNode:(NUOpaqueBTreeLeaf *)aNode;

- (void)shuffleExtraValuesOfLeftNode;
- (void)shuffleExtraValuesOfRightNode;
- (void)mergeExtraValuesOfLeftNode:(NUOpaqueBTreeLeaf *)aNode;
- (void)mergeExtraValuesOfRightNode:(NUOpaqueBTreeLeaf *)aNode;

@end
