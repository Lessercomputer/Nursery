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

- (NUUInt64)count;

- (id <NUComparator>)comparator;

- (NSEnumerator *)objectEnumerator;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id aKey, id anObj, BOOL *aStop))aBlock;

- (BOOL)isEqualToLibrary:(NULibrary *)aLibrary;

@end

@interface NULibrary (Coding) <NUCoding>
@end

@interface NULibrary (Private)

- (NUBTree *)tree;
- (void)setTree:(NUBTree *)aTree;

@end
