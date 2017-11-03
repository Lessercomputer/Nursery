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
    NUInt32 nextValueIndex;
    NSEnumerationOptions options;
}

+ (id)enumeratorWithTree:(NUBTree *)aTree from:(id)aKey1 to:(id)aKey2 options:(NSEnumerationOptions)anOpts;

- (id)initWithTree:(NUBTree *)aTree from:(id)aKey1 to:(id)aKey2 options:(NSEnumerationOptions)anOpts;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;

@end
