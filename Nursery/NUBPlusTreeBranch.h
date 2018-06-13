//
//  NUBPlusTreeBranch.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import "NUBPlusTreeNode.h"

@interface NUBPlusTreeBranch : NUBPlusTreeNode

+ (id)nodeWithTree:(NUBPlusTree *)aTree key:(id)aKey leftChildNode:(NUBPlusTreeNode *)aLeftChildNode rightChildNode:(NUBPlusTreeNode *)aRightChildNode;

- (id)initWithTree:(NUBPlusTree *)aTree key:(id)aKey leftChildNode:(NUBPlusTreeNode *)aLeftChildNode rightChildNode:(NUBPlusTreeNode *)aRightChildNode;

- (NUBPlusTreeNode *)nodeForKey:(id)aKey;
- (NUUInt64)nodeIndexForKey:(id)aKey;

- (void)addNode:(NUBPlusTreeNode *)aNode;
- (void)insertNode:(NUBPlusTreeNode *)aNode at:(NUUInt64)anIndex;
- (void)removeNodeAt:(NUUInt64)anIndex;

@end
