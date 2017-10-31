//
//  NUU64ODictionary.h
//  Nursery
//
//  Created by Akifumi Takata on 2014/02/14.
//
//

#import "NUOpaqueODictionary.h"

@interface NUU64ODictionary : NUOpaqueODictionary

- (void)setObject:(id)anObject forKey:(NUUInt64)aKey;
- (id)objectForKey:(NUUInt64)aKey;
- (void)removeObjectForKey:(NUUInt64)aKey;

- (id)anyObject;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(NUUInt64 aKey, id anObject, BOOL *stop))aBlock;

@end
