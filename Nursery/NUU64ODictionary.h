//
//  NUU64ODictionary.h
//  Nursery
//
//  Created by Akifumi Takata on 2014/02/14.
//
//

#import "NUOpaqueODictionary.h"

@interface NUU64ODictionary : NUOpaqueODictionary

NUUInt64 NUU64ODictionaryKeyHash(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary, void *aContext);
BOOL NUU64ODictionaryKeyEqual(NUUInt8 *aKey1, NUUInt8 *aKey2, NUOpaqueODictionary *aDictionary);
void NUU64ODictionarySetKey(NUUInt8 *aDestinationKey, NUUInt8 *aSourceKey, NUOpaqueODictionary *aDictionary);

- (void)setObject:(id)anObject forKey:(NUUInt64)aKey;
- (id)objectForKey:(NUUInt64)aKey;
- (void)removeObjectForKey:(NUUInt64)aKey;

- (id)anyObject;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(NUUInt64 aKey, id anObject, BOOL *stop))aBlock;

@end
