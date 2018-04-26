//
//  NUTreeEnumerator.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/02/14.
//
//

#import <Foundation/NSEnumerator.h>
#import "NUTypes.h"

@class NUBTree, NUBTreeLeaf;

@interface NUBTreeEnumerator : NSEnumerator
{
    NUBTree *tree;
    id key1;
    id key2;
    NUBTreeLeaf *node;
    NUInt64 nextValueIndex;
    NSEnumerationOptions options;
    BOOL orEqualFlag1;
    BOOL orEqualFlag2;
}

+ (id)enumeratorWithTree:(NUBTree *)aTree keyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 keyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts;

- (id)initWithTree:(NUBTree *)aTree keyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 keyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;

@end
