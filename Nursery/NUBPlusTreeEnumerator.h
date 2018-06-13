//
//  NUTreeEnumerator.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/02/14.
//
//

#import <Foundation/NSEnumerator.h>
#import "NUTypes.h"

@class NUBPlusTree, NUBPlusTreeLeaf;

@interface NUBPlusTreeEnumerator : NSEnumerator
{
    NUBPlusTree *tree;
    id key1;
    id key2;
    NUBPlusTreeLeaf *node;
    NUInt64 nextValueIndex;
    NSEnumerationOptions options;
    BOOL orEqualFlag1;
    BOOL orEqualFlag2;
}

+ (id)enumeratorWithTree:(NUBPlusTree *)aTree keyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 keyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts;

- (id)initWithTree:(NUBPlusTree *)aTree keyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 keyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;

@end
