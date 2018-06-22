//
//  NUBPlusTree.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import "NUTypes.h"
#import "NUComparator.h"
#import "NUCoding.h"
#import "NUMovingUp.h"

@class NSMutableArray;

@class NUBPlusTreeNode, NUBPlusTreeLeaf;

typedef enum NUBPlusTreeSetObjectResult
{
    NUBPlusTreeSetObjectResultReplace,
    NUBPlusTreeSetObjectResultAdd
} NUBPlusTreeSetObjectResult;

@interface NUBPlusTree : NSObject
{
    NUBPlusTreeNode *root;
    NUUInt64 count;
    NUUInt64 depth;
    NUUInt64 keyCapacity;
    id <NUComparator> comparator;
    NUBell *bell;
}

+ (id)treeWithKeyCapacity:(NUUInt64)aKeyCapacity comparator:(id <NUComparator>)aComparator;

- (id)initWithKeyCapacity:(NUUInt64)aKeyCapacity comparator:(id <NUComparator>)aComparator;

- (id)objectForKey:(id)aKey;
- (NUBPlusTreeSetObjectResult)setObject:(id)anObject forKey:(id)aKey;
- (BOOL)removeObjectForKey:(id)aKey;

- (id)firstKey;
- (id)lastKey;

- (id)keyGreaterThanOrEqualTo:(id)aKey;
- (id)keyGreaterThan:(id)aKey;
- (id)keyLessThanOrEqualTo:(id)aKey;
- (id)keyLessThan:(id)aKey;

- (NUUInt64)count;
- (NUUInt64)depth;

- (NUBPlusTreeNode *)root;
- (NUUInt64)keyCapacity;
- (NUUInt64)minKeyCount;

- (id <NUComparator>)comparator;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;
- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;
- (void)enumerateKeysAndObjectsWithKeyGreaterThan:(id)aKey orEqual:(BOOL)anOrEqualFlag options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock;
- (void)enumerateKeysAndObjectsWithKeyLessThan:(id)aKey orEqual:(BOOL)anOrEqualFlag options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock;
- (void)enumerateKeysAndObjectsWithKeyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 andKeyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock;

+ (NUUInt64)defaultKeyCapacity;
+ (Class)defaultComparatorClass;

@end

@interface NUBPlusTree (Coding) <NUCoding>
@end

@interface NUBPlusTree (MovingUp) <NUMovingUp>
@end

@interface NUBPlusTree (Private)

- (void)initIvarsWithAliaser:(NUAliaser *)anAliaser;

- (void)setRoot:(NUBPlusTreeNode *)aRoot;
- (void)setComparator:(id <NUComparator>)aComparator;
- (void)updateKey:(id)aKey;

- (NUBPlusTreeLeaf *)firstLeaf;
- (NUBPlusTreeLeaf *)lastLeaf;

- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex;
- (NUBPlusTreeLeaf *)leafNodeContainingKeyGreaterThan:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex;
- (NUBPlusTreeLeaf *)leafNodeContainingKeyLessThanOrEqualTo:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex;
- (NUBPlusTreeLeaf *)leafNodeContainingKeyLessThan:(id)aKey keyIndex:(NUUInt64 *)aKeyIndex;

- (NUBPlusTreeLeaf *)getNextKeyIndex:(NUUInt64 *)aKeyIndex node:(NUBPlusTreeLeaf *)aNode;
- (NUBPlusTreeLeaf *)getPreviousKeyIndex:(NUUInt64 *)aKeyIndex node:(NUBPlusTreeLeaf *)aNode;

- (NSMutableArray *)allLoadedNodes;

@end
