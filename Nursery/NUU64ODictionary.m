//
//  NUU64ODictionary.m
//  Nursery
//
//  Created by P,T,A on 2014/02/14.
//
//

#import "NUU64ODictionary.h"

NUUInt64 NUU64ODictionary2KeyHash(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary);
BOOL NUU64ODictionary2KeyEqual(NUUInt8 *aKey1, NUUInt8 *aKey2, NUOpaqueODictionary *aDictionary);
void NUU64ODictionary2SetKey(NUUInt8 *aDestinationKey, NUUInt8 *aSourceKey, NUOpaqueODictionary *aDictionary);

NUUInt64 NUU64ODictionary2KeyHash(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary)
{
    return *(NUUInt64 *)aKey;
}

BOOL NUU64ODictionary2KeyEqual(NUUInt8 *aKey1, NUUInt8 *aKey2, NUOpaqueODictionary *aDictionary)
{
    return *(NUUInt64 *)aKey1 == *(NUUInt64 *)aKey2;
}

void NUU64ODictionary2SetKey(NUUInt8 *aDestinationKey, NUUInt8 *aSourceKey, NUOpaqueODictionary *aDictionary)
{
    *(NUUInt64 *)aDestinationKey = *(NUUInt64 *)aSourceKey;
}

@implementation NUU64ODictionary

- (id)init
{
    self = [super initWithKeySize:sizeof(NUUInt64)
                          keyHash:NUU64ODictionary2KeyHash
                         keyEqual:NUU64ODictionary2KeyEqual
                           setKey:NUU64ODictionary2SetKey
                allocAssociations:NUOpaqueODictionaryDefaultAllocAssociations
              reallocAssociations:NUOpaqueODictionaryDefaultReallocAssociations
                   getAssociation:NUOpaqueODictionaryDefaultGetAssociation
                  moveAssociation:NUOpaqueODictionaryDefaultMoveAssociation];
    
    return self;
}

- (void)setObject:(id)anObject forKey:(NUUInt64)aKey
{
    [self setObject:anObject forOpaqueKey:(NUUInt8 *)&aKey];
}

- (id)objectForKey:(NUUInt64)aKey
{
    return [self objectForOpaqueKey:(NUUInt8 *)&aKey];
}

- (void)removeObjectForKey:(NUUInt64)aKey
{
    [self removeObjectForOpaqueKey:(NUUInt8 *)&aKey];
}

- (id)anyObject
{
    NUUInt64 aBucketIndex = 0;
    NUUInt64 anAssociationIndex = 0;
    NUOpaqueOAssociation *anAssociation = NULL;
    
    while(!anAssociation && aBucketIndex < bucketCount)
    {
        while (!anAssociation && anAssociationIndex < buckets[aBucketIndex].count)
        {
            anAssociation = getAssociation(anAssociationIndex, &buckets[aBucketIndex], self);
            anAssociationIndex++;
        }
        
        if (anAssociationIndex >= buckets[aBucketIndex].count)
        {
            aBucketIndex++;
            anAssociationIndex = 0;
        }
    }
    
    return anAssociation ? anAssociation->object : nil;
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(NUUInt64, id, BOOL *))aBlock
{
    NUOpaqueODictionaryEnumerator *anEnumerator = (NUOpaqueODictionaryEnumerator *)[self objectEnumerator];
    NUOpaqueOAssociation *anAssociation;
    BOOL aStopFlag = NO;
    
    while (!aStopFlag && (anAssociation = [anEnumerator nextAssociation]))
        aBlock(*(NUUInt64 *)anAssociation->key, anAssociation->object, &aStopFlag);
}

@end
