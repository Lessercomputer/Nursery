//
//  NUTreeEnumerator.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/02/14.
//
//

#import "NUTypes.h"

@class NUBTree, NUBTreeLeaf;

@interface NUBTreeEnumerator : NSEnumerator
{
    NUBTree *tree;
    id keyFrom;
    id keyTo;
    NUBTreeLeaf *node;
    NUInt64 nextValueIndex;
    NSEnumerationOptions options;
}

+ (id)enumeratorWithTree:(NUBTree *)aTree keyGreaterThanOrEqualTo:(id)aKey1 keyLessThanOrEqualTo:(id)aKey2 options:(NSEnumerationOptions)anOpts;

- (id)initWithTree:(NUBTree *)aTree keyGreaterThanOrEqualTo:(id)aKey1 keyLessThanOrEqualTo:(id)aKey2 options:(NSEnumerationOptions)anOpts;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;

@end
