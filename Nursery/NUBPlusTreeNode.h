//
//  NUBPlusTreeNode.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import "NUTypes.h"
#import "NUComparator.h"
#import "NUCoding.h"
#import "NUBPlusTree.h"

@class NUBPlusTreeLeaf, NUBell, NULazyMutableArray;

@interface NUBPlusTreeNode : NSObject
{
    NULazyMutableArray *keys;
    NULazyMutableArray *values;
    NUBPlusTree *tree;
    NUBPlusTreeNode *leftNode;
    NUBPlusTreeNode *rightNode;
    NUBPlusTreeNode *parentNode;
    NUBell *bell;
}

+ (id)nodeWithTree:(NUBPlusTree *)aTree;
+ (id)nodeWithTree:(NUBPlusTree *)aTree keys:(NULazyMutableArray *)aKeys values:(NULazyMutableArray *)aValues;

- (id)initWithTree:(NUBPlusTree *)aTree;
- (id)initWithTree:(NUBPlusTree *)aTree keys:(NULazyMutableArray *)aKeys values:(NULazyMutableArray *)aValues;

- (id)objectForKey:(id)aKey;
- (NUBPlusTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey;
- (BOOL)removeObjectForKey:(id)aKey;

- (NULazyMutableArray *)keys;
- (NULazyMutableArray *)values;

- (NUBPlusTreeNode *)leftNode;
- (NUBPlusTreeNode *)rightNode;
- (NUBPlusTreeNode *)parentNode;

- (NUBPlusTree *)tree;

- (id)firstKey;
- (id)lastKey;
- (id)keyAt:(NUUInt64)anIndex;
- (NUUInt64)keyCount;
- (NUUInt64)minKeyCount;
- (id)valueAt:(NUUInt64)anIndex;
- (NUUInt64)valueCount;

- (BOOL)isBranch;
- (BOOL)isLeaf;

- (BOOL)isMin;
- (BOOL)isUnderflow;
- (BOOL)isOverflow;

- (id <NUComparator>)comparator;

- (BOOL)getKeyIndexLessThanOrEqualTo:(id)aKey keyIndexInto:(NUUInt64 *)aKeyIndex;
- (BOOL)getKeyIndexGreaterThanOrEqualTo:(id)aKey keyIndexInto:(NUUInt64 *)aKeyIndex;

- (NUBPlusTreeNode *)split;
- (void)shuffleLeftNode;
- (void)shuffleRightNode;
- (void)mergeLeftNode;
- (void)mergeRightNode;

@end

@interface NUBPlusTreeNode (Coding) <NUCoding>
@end

@interface NUBPlusTreeNode (Private)

- (void)setKeys:(NULazyMutableArray *)aKeys;
- (void)setValues:(NULazyMutableArray *)aValues;

- (void)setLeftNode:(NUBPlusTreeNode *)aLeftNode;
- (void)setRightNode:(NUBPlusTreeNode *)aRightNode;
- (void)setParentNode:(NUBPlusTreeNode *)aParentNode;

- (void)insertRightSiblingNode:(NUBPlusTreeNode *)aNode;

- (void)setTree:(NUBPlusTree *)aTree;

- (void)updateKey:(id)aKey;

- (NUBPlusTreeLeaf *)firstLeaf;
- (NUBPlusTreeLeaf *)lastLeaf;

- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex;
- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex;
- (NUBPlusTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex;
- (NUBPlusTreeLeaf *)leafNodeContainingKeyLessThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex;

@end
