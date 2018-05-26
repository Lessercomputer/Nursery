//
//  NUBTreeNode.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import "NUTypes.h"
#import "NUComparator.h"
#import "NUCoding.h"

@class NUBTree, NUBTreeLeaf, NUBell, NULazyMutableArray;

typedef enum NUBTreeSetObjectResult
{
    NUBTreeSetObjectResultReplace,
    NUBTreeSetObjectResultAdd
} NUBTreeSetObjectResult;

@interface NUBTreeNode : NSObject
{
    NULazyMutableArray *keys;
    NULazyMutableArray *values;
    NUBTree *tree;
    NUBTreeNode *leftNode;
    NUBTreeNode *rightNode;
    NUBTreeNode *parentNode;
    NUBell *bell;
}

+ (id)nodeWithTree:(NUBTree *)aTree;
+ (id)nodeWithTree:(NUBTree *)aTree keys:(NULazyMutableArray *)aKeys values:(NULazyMutableArray *)aValues;

- (id)initWithTree:(NUBTree *)aTree;
- (id)initWithTree:(NUBTree *)aTree keys:(NULazyMutableArray *)aKeys values:(NULazyMutableArray *)aValues;

- (id)objectForKey:(id)aKey;
- (NUBTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey;
- (BOOL)removeObjectForKey:(id)aKey;

- (NULazyMutableArray *)keys;
- (NULazyMutableArray *)values;

- (NUBTreeNode *)leftNode;
- (NUBTreeNode *)rightNode;
- (NUBTreeNode *)parentNode;

- (NUBTree *)tree;

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

- (NUBTreeNode *)split;
- (void)shuffleLeftNode;
- (void)shuffleRightNode;
- (void)mergeLeftNode;
- (void)mergeRightNode;

@end

@interface NUBTreeNode (Coding) <NUCoding>
@end

@interface NUBTreeNode (Private)

- (void)setKeys:(NULazyMutableArray *)aKeys;
- (void)setValues:(NULazyMutableArray *)aValues;

- (void)setLeftNode:(NUBTreeNode *)aLeftNode;
- (void)setRightNode:(NUBTreeNode *)aRightNode;
- (void)setParentNode:(NUBTreeNode *)aParentNode;

- (void)insertRightSiblingNode:(NUBTreeNode *)aNode;

- (void)setTree:(NUBTree *)aTree;

- (void)updateKey:(id)aKey;

- (NUBTreeLeaf *)firstLeaf;
- (NUBTreeLeaf *)lastLeaf;

- (NUBTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex;
- (NUBTreeLeaf *)leafNodeContainingKeyGreaterThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex;
- (NUBTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex;
- (NUBTreeLeaf *)leafNodeContainingKeyLessThan:(id)aKey orEqualToKey:(BOOL)anOrEqualToKeyFlag keyIndex:(NUUInt64 *)aKeyIndex;

@end
