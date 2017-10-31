//
//  NUBTree.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import <Nursery/NUTypes.h>
#import <Nursery/NUComparator.h>
#import <Nursery/NUCoding.h>

@class NUBTreeNode, NUBTreeLeaf;

@interface NUBTree : NSObject
{
    NUBTreeNode *root;
    NUUInt64 count;
    NUUInt64 depth;
    NUUInt64 keyCapacity;
    id <NUComparator> comparator;
    NUBell *bell;
}

+ (id)treeWithKeyCapacity:(NUUInt64)aKeyCapacity comparator:(id <NUComparator>)aComparator;

- (id)initWithKeyCapacity:(NUUInt64)aKeyCapacity comparator:(id <NUComparator>)aComparator;

- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;

- (NUUInt64)count;
- (NUUInt64)depth;

- (NUBTreeNode *)root;
- (NUUInt64)keyCapacity;
- (NUUInt64)minKeyCount;

- (id <NUComparator>)comparator;

- (NSEnumerator *)objectEnumerator;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;

+ (NUUInt64)defaultKeyCapacity;
+ (Class)defaultComparatorClass;

@end

@interface NUBTree (Coding) <NUCoding>
@end

@interface NUBTree (Private)

- (void)setRoot:(NUBTreeNode *)aRoot;
- (void)setComparator:(id <NUComparator>)aComparator;
- (void)updateKey:(id)aKey;

- (NUBTreeLeaf *)firstLeaf;

@end
