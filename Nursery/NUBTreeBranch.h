//
//  NUBTreeBranch.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import <Nursery/NUBTreeNode.h>

@interface NUBTreeBranch : NUBTreeNode

+ (id)nodeWithTree:(NUBTree *)aTree key:(id)aKey leftChildNode:(NUBTreeNode *)aLeftChildNode rightChildNode:(NUBTreeNode *)aRightChildNode;

- (id)initWithTree:(NUBTree *)aTree key:(id)aKey leftChildNode:(NUBTreeNode *)aLeftChildNode rightChildNode:(NUBTreeNode *)aRightChildNode;

- (NUBTreeNode *)nodeForKey:(id)aKey;
- (NUUInt64)nodeIndexForKey:(id)aKey;

- (void)addNode:(NUBTreeNode *)aNode;
- (void)insertNode:(NUBTreeNode *)aNode at:(NUUInt64)anIndex;
- (void)removeNodeAt:(NUUInt64)anIndex;

@end
