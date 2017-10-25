//
//  NUBTreeNode.h
//  Nursery
//
//  Created by P,T,A on 2013/01/20.
//
//

#import <Nursery/NUTypes.h>
#import <Nursery/NUComparator.h>
#import <Nursery/NUCoding.h>

@class NUBTree, NUBTreeLeaf, NUBell;

typedef enum NUBTreeSetObjectResult
{
    NUBTreeSetObjectResultReplace,
    NUBTreeSetObjectResultAdd
} NUBTreeSetObjectResult;

@interface NUBTreeNode : NSObject
{
    NSMutableArray *keys;
    NSMutableArray *values;
    NUBTree *tree;
    NUBTreeNode *leftNode;
    NUBTreeNode *rightNode;
    NUBTreeNode *parentNode;
    NUBell *bell;
}

+ (id)nodeWithTree:(NUBTree *)aTree;
+ (id)nodeWithTree:(NUBTree *)aTree keys:(NSMutableArray *)aKeys values:(NSMutableArray *)aValues;

- (id)initWithTree:(NUBTree *)aTree;
- (id)initWithTree:(NUBTree *)aTree keys:(NSMutableArray *)aKeys values:(NSMutableArray *)aValues;

- (id)objectForKey:(id)aKey;
- (NUBTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey;
- (BOOL)removeObjectForKey:(id)aKey;

- (NSMutableArray *)keys;
- (NSMutableArray *)values;

- (NUBTreeNode *)leftNode;
- (NUBTreeNode *)rightNode;
- (NUBTreeNode *)parentNode;

- (NUBTree *)tree;

- (id)firstKey;
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

- (void)setKeys:(NSMutableArray *)aKeys;
- (void)setValues:(NSMutableArray *)aValues;

- (void)setLeftNode:(NUBTreeNode *)aLeftNode;
- (void)setRightNode:(NUBTreeNode *)aRightNode;
- (void)setParentNode:(NUBTreeNode *)aParentNode;

- (void)insertRightSiblingNode:(NUBTreeNode *)aNode;

- (void)setTree:(NUBTree *)aTree;

- (void)updateKey:(id)aKey;

- (NUBTreeLeaf *)firstLeaf;

@end