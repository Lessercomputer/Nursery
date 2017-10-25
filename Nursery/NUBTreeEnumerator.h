//
//  NUTreeEnumerator.h
//  Nursery
//
//  Created by P,T,A on 2013/02/14.
//
//

#import <Nursery/Nursery.h>

@class NUBTree, NUBTreeLeaf;

@interface NUBTreeEnumerator : NSEnumerator
{
    NUBTree *tree;
    NUBTreeLeaf *node;
    NUUInt64 nextValueIndex;
}

+ (id)enumeratorWithTree:(NUBTree *)aTree;

- (id)initWithTree:(NUBTree *)aTree;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;

@end
