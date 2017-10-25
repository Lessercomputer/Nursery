//
//  NUOpaqueODictionary.h
//  Nursery
//
//  Created by P,T,A on 2014/02/11.
//
//

#import <Nursery/NUTypes.h>

typedef struct NUOpaqueOAssociation {
    id object;
    NUUInt8 key[0];
} NUOpaqueOAssociation;

typedef struct NUOpaqueOBucket {
    NUUInt64 count;
    NUUInt64 capacity;
    NUOpaqueOAssociation *associations;
} NUOpaqueOBucket;

@class NUOpaqueODictionary;

typedef NUUInt64 (*NUOpaqueODictionaryKeyHash)(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary);
typedef BOOL (*NUOpaqueODictionaryKeyEqual)(NUUInt8 *aKey1, NUUInt8 *aKey2, NUOpaqueODictionary *aDictionary);
typedef void (*NUOpaqueODictionarySetKey)(NUUInt8 *aDestinationKey, NUUInt8 *aSourceKey, NUOpaqueODictionary *aDictionary);
typedef NUOpaqueOAssociation *(*NUOpaqueODictionaryGetAssociation)(NUUInt64 anIndex, NUOpaqueOBucket *aBucket, NUOpaqueODictionary *aDictionary);
typedef void (*NUOpaqueODictionaryMoveAssociation)(NUUInt64 aSourceIndex, NUUInt64 aDestinationIndex, NUOpaqueOBucket *aBucket, NUOpaqueODictionary *aDictionary);
typedef NUOpaqueOAssociation *(*NUOpaqueODictionaryAllocAssociations)(NUUInt64 anAssociationCapacity, NUOpaqueODictionary *aDictionary);
typedef NUOpaqueOAssociation *(*NUOpaqueODictionaryReallocAssociations)(NUOpaqueOAssociation *anAssociations, NUUInt64 anAssociationCapacity, NUUInt64 aNewAssociationCapacity, NUOpaqueODictionary *aDictionary);

NUOpaqueOAssociation *NUOpaqueODictionaryDefaultGetAssociation(NUUInt64 anIndex, NUOpaqueOBucket *aBucket, NUOpaqueODictionary *aDictionary);
void NUOpaqueODictionaryDefaultMoveAssociation(NUUInt64 aSourceIndex, NUUInt64 aDestinationIndex, NUOpaqueOBucket *aBucket, NUOpaqueODictionary *aDictionary);
NUOpaqueOAssociation *NUOpaqueODictionaryDefaultAllocAssociations(NUUInt64 anAssociationCapacity, NUOpaqueODictionary *aDictionary);
NUOpaqueOAssociation *NUOpaqueODictionaryDefaultReallocAssociations(NUOpaqueOAssociation *anAssociations, NUUInt64 anAssociationCapacity, NUUInt64 aNewAssociationCapacity, NUOpaqueODictionary *aDictionary);

@interface NUOpaqueODictionary : NSObject
{
    NUUInt64 count;
    NUUInt64 bucketCount;
    NUUInt64 bucketLoadCount;
    NUUInt64 bucketLoadCountLimit;
    NUOpaqueOBucket *buckets;
    NUUInt64 keySize;
    NUOpaqueODictionaryKeyHash keyHash;
    NUOpaqueODictionaryKeyEqual keyEqual;
    NUOpaqueODictionarySetKey setKey;
    NUOpaqueODictionaryAllocAssociations allocAssociations;
    NUOpaqueODictionaryReallocAssociations reallocAssociations;
    NUOpaqueODictionaryGetAssociation getAssociation;
    NUOpaqueODictionaryMoveAssociation moveAssociation;
}

+ (id)dictionary;

- (id)initWithKeySize:(NUUInt64)aKeySize keyHash:(NUOpaqueODictionaryKeyHash)aKeyHash keyEqual:(NUOpaqueODictionaryKeyEqual)aKeyEqual setKey:(NUOpaqueODictionarySetKey)aSetKey allocAssociations:(NUOpaqueODictionaryAllocAssociations)anAllocAssociations reallocAssociations:(NUOpaqueODictionaryReallocAssociations)aReallocAssociations getAssociation:(NUOpaqueODictionaryGetAssociation) aGetAssociation moveAssociation:(NUOpaqueODictionaryMoveAssociation)aMoveAssociation;

- (id)objectForOpaqueKey:(NUUInt8 *)aKey;
- (void)setObject:(id)anObject forOpaqueKey:(NUUInt8 *)aKey;

- (void)removeObjectForOpaqueKey:(NUUInt8 *)aKey;

- (NUUInt64)count;
- (NUUInt64)keySize;

- (NUOpaqueODictionaryGetAssociation)getAssociation;

- (NSEnumerator *)objectEnumerator;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(NUUInt8 *aKey, id anObject, BOOL *stop))aBlock;

@end

@interface NUOpaqueODictionary (Private)

- (NUUInt64)bucketIndexForKey:(NUUInt8 *)aKey;
- (void)rehash;
- (void)growBucket:(NUOpaqueOBucket *)aBucket;
- (void)releaseBuckets:(NUOpaqueOBucket *)aBuckets count:(NUUInt64)aCount  releaseObject:(BOOL)aReleaseObject;
- (NUOpaqueOBucket *)buckets;
- (NUUInt64)bucketCount;

@end

@interface NUOpaqueODictionaryEnumerator : NSEnumerator
{
    NUOpaqueODictionary *dictionary;
    NUUInt64 bucketCount;
    NUOpaqueOBucket *buckets;
    NUUInt64 bucketIndex;
    NUUInt64 associationIndex;
    NUOpaqueODictionaryGetAssociation getAssociation;
}

+ (id)enumeratorWithDictionary:(NUOpaqueODictionary *)aDictionary;
- (id)initWithDictionary:(NUOpaqueODictionary *)aDictionary;

- (NUOpaqueOAssociation *)nextAssociation;

@end