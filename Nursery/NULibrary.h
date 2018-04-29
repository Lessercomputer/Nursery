//
//  NULibrary.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/01/20.
//
//

#import <Nursery/NUTypes.h>
#import <Nursery/NUComparator.h>
#import <Nursery/NUCoding.h>

@class NUBTree, NUBell;

@interface NULibrary : NSObject
{
    NUBTree *tree;
    NUBell *bell;
}

+ (id)library;
+ (id)libraryWithComparator:(id <NUComparator>)aComparator;

- (id)init;
- (id)initWithComparator:(id <NUComparator>)aComparator;

- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;

- (id)firstKey;
- (id)lastKey;

- (id)keyGreaterThanOrEqualTo:(id)aKey;
- (id)keyGreaterThan:(id)aKey;
- (id)keyLessThanOrEqualTo:(id)aKey;
- (id)keyLessThan:(id)aKey;

- (NUUInt64)count;

- (id <NUComparator>)comparator;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;
- (void)enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;
- (void)enumerateKeysAndObjectsWithKeyGreaterThan:(id)aKey orEqual:(BOOL)anOrEqualFlag options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock;
- (void)enumerateKeysAndObjectsWithKeyLessThan:(id)aKey orEqual:(BOOL)anOrEqualFlag options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock;
- (void)enumerateKeysAndObjectsWithKeyGreaterThan:(id)aKey1 orEqual:(BOOL)anOrEqualFlag1 andKeyLessThan:(id)aKey2 orEqual:(BOOL)anOrEqualFlag2 options:(NSEnumerationOptions)anOpts usingBlock:(void (^)(id, id, BOOL *))aBlock;

- (BOOL)isEqualToLibrary:(NULibrary *)aLibrary;

@end

@interface NULibrary (Coding) <NUCoding>
@end

