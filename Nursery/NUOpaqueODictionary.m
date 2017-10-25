//
//  NUOpaqueODictionary.m
//  Nursery
//
//  Created by P,T,A on 2014/02/11.
//
//

#import "NUOpaqueODictionary.h"

const NUUInt64 NUOpaqueODictionaryInitialBucketCount = 17;
const NUUInt64 NUOpaqueODictionaryInitialBucketLoadCountLimit = 8;

NUOpaqueOAssociation *NUOpaqueODictionaryDefaultGetAssociation(NUUInt64 anIndex, NUOpaqueOBucket *aBucket, NUOpaqueODictionary *aDictionary)
{
    return (NUOpaqueOAssociation *)((NUUInt8 *)aBucket->associations + ((sizeof(NUOpaqueOAssociation) + [aDictionary keySize]) * anIndex));
}

void NUOpaqueODictionaryDefaultMoveAssociation(NUUInt64 aSourceIndex, NUUInt64 aDestinationIndex, NUOpaqueOBucket *aBucket, NUOpaqueODictionary *aDictionary)
{
    NUOpaqueOAssociation *aSourceAssociation = NUOpaqueODictionaryDefaultGetAssociation(aSourceIndex, aBucket, aDictionary);
    NUOpaqueOAssociation *aDestinationAssociation = NUOpaqueODictionaryDefaultGetAssociation(aDestinationIndex, aBucket, aDictionary);
    memcpy(aDestinationAssociation, aSourceAssociation, sizeof(NUOpaqueOAssociation) + [aDictionary keySize]);
}

NUOpaqueOAssociation *NUOpaqueODictionaryDefaultAllocAssociations(NUUInt64 anAssociationCapacity, NUOpaqueODictionary *aDictionary)
{
    return calloc(anAssociationCapacity, sizeof(NUOpaqueOAssociation) + [aDictionary keySize]);
}

NUOpaqueOAssociation *NUOpaqueODictionaryDefaultReallocAssociations(NUOpaqueOAssociation *anAssociations, NUUInt64 anAssociationCapacity, NUUInt64 aNewAssociationCapacity, NUOpaqueODictionary *aDictionary)
{
    NUUInt64 anAssociationSize = sizeof(NUOpaqueOAssociation) + [aDictionary keySize];
    anAssociations = realloc(anAssociations, anAssociationSize * aNewAssociationCapacity);
    memset((NUUInt8 *)anAssociations + anAssociationSize * anAssociationCapacity, 0, anAssociationSize * aNewAssociationCapacity - anAssociationSize * anAssociationCapacity);
    return anAssociations;
}

@implementation NUOpaqueODictionary

+ (id)dictionary
{
    return [[self new] autorelease];
}

- (id)init
{
    return [self initWithKeySize:0 keyHash:NULL keyEqual:NULL setKey:NULL];
}

- (id)initWithKeySize:(NUUInt64)aKeySize keyHash:(NUOpaqueODictionaryKeyHash)aKeyHash keyEqual:(NUOpaqueODictionaryKeyEqual)aKeyEqual setKey:(NUOpaqueODictionarySetKey)aSetKey
{
    return [self initWithKeySize:aKeySize keyHash:aKeyHash keyEqual:aKeyEqual setKey:aSetKey allocAssociations:NUOpaqueODictionaryDefaultAllocAssociations reallocAssociations:NUOpaqueODictionaryDefaultReallocAssociations getAssociation:NUOpaqueODictionaryDefaultGetAssociation moveAssociation:NUOpaqueODictionaryDefaultMoveAssociation];
}

- (id)initWithKeySize:(NUUInt64)aKeySize keyHash:(NUOpaqueODictionaryKeyHash)aKeyHash keyEqual:(NUOpaqueODictionaryKeyEqual)aKeyEqual setKey:(NUOpaqueODictionarySetKey)aSetKey allocAssociations:(NUOpaqueODictionaryAllocAssociations)anAllocAssociations reallocAssociations:(NUOpaqueODictionaryReallocAssociations)aReallocAssociations getAssociation:(NUOpaqueODictionaryGetAssociation) aGetAssociation moveAssociation:(NUOpaqueODictionaryMoveAssociation)aMoveAssociation
{
    if (self = [super init])
    {
        if (aKeySize < 1 || !aKeyHash ||!aKeyEqual || !aSetKey
            || !anAllocAssociations || !aReallocAssociations || !aGetAssociation || !aMoveAssociation)
        {
            [self release];
            self = nil;
        }
        else
        {
            bucketCount = NUOpaqueODictionaryInitialBucketCount;
            bucketLoadCount = 0;
            bucketLoadCountLimit = NUOpaqueODictionaryInitialBucketLoadCountLimit;
            buckets = calloc(bucketCount, sizeof(NUOpaqueOBucket));
            keySize = aKeySize;
            keyHash = aKeyHash;
            keyEqual = aKeyEqual;
            setKey = aSetKey;
            allocAssociations = anAllocAssociations;
            reallocAssociations = aReallocAssociations;
            getAssociation = aGetAssociation;
            moveAssociation = aMoveAssociation;
        }
    }
    
    return self;
}

- (void)dealloc
{
    [self releaseBuckets:buckets count:bucketCount releaseObject:YES];
    
    [super dealloc];
}

- (id)objectForOpaqueKey:(NUUInt8 *)aKey
{
    NUUInt64 aBucketIndex = [self bucketIndexForKey:aKey];
    NUOpaqueOBucket *aBucket =  &buckets[aBucketIndex];
    
    for (NUUInt64 i = 0; i < aBucket->count; i++)
    {
        NUOpaqueOAssociation *anAssociation = getAssociation(i, aBucket, self);
        if (keyEqual(anAssociation->key, aKey, self))
            return anAssociation->object;
    }
    
    return nil;
}

- (void)setObject:(id)anObject forOpaqueKey:(NUUInt8 *)aKey
{
    if (!anObject)
        [[NSException exceptionWithName:NSInvalidArgumentException reason:NSInvalidArgumentException userInfo:nil] raise];
    
    if (bucketLoadCount + 1 > bucketLoadCountLimit)
        [self rehash];
    
    NUUInt64 aBucketIndex = [self bucketIndexForKey:aKey];
    NUOpaqueOBucket *aBucket =  &buckets[aBucketIndex];
    NUUInt64 i = 0;
    NUOpaqueOAssociation *anAssociation = NULL;
    
    for (; i < aBucket->count; i++)
    {
        anAssociation = getAssociation(i, aBucket, self);
        if (keyEqual(anAssociation->key, aKey, self))
            break;
    }
    
    if (i < aBucket->count)
    {
        if (anAssociation->object != anObject)
        {
            [anAssociation->object release];
            anAssociation->object = [anObject retain];
        }
    }
    else
    {
        if (aBucket->count == aBucket->capacity)
        {
            if (aBucket->count == 0)
                bucketLoadCount++;
                
            [self growBucket:aBucket];
        }
        
        anAssociation = getAssociation(aBucket->count, aBucket, self);
        setKey(anAssociation->key, aKey, self);
        anAssociation->object = [anObject retain];
        aBucket->count++;
        
        count++;
    }
}

- (void)removeObjectForOpaqueKey:(NUUInt8 *)aKey
{
    NUUInt64 aBucketIndex = [self bucketIndexForKey:aKey];
    NUOpaqueOBucket *aBucket =  &buckets[aBucketIndex];
    
    for (NUUInt64 i = 0; i < aBucket->count; i++)
    {
        NUOpaqueOAssociation *anAssociation = getAssociation(i, aBucket, self);
        
        if (keyEqual(anAssociation->key, aKey, self))
        {
            [anAssociation->object release];
            aBucket->count--;
            if (aBucket->count == 0)
            {
                bucketLoadCount--;
                free(aBucket->associations);
                aBucket->associations = NULL;
                aBucket->capacity = 0;
            }
            
            for (NUUInt64 aMoveIndex = i; aMoveIndex < aBucket->count; aMoveIndex++)
            {
                moveAssociation(aMoveIndex + 1, aMoveIndex, aBucket, self);
            }
            
            count--;
            
            break;
        }
    }
}

- (NUUInt64)count
{
    return count;
}

- (NUUInt64)keySize
{
    return keySize;
}

- (NUOpaqueODictionaryGetAssociation)getAssociation
{
    return getAssociation;
}

- (NSEnumerator *)objectEnumerator
{
    return [NUOpaqueODictionaryEnumerator enumeratorWithDictionary:self];
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(NUUInt8 *, id, BOOL *))aBlock
{
    NUOpaqueODictionaryEnumerator *anEnumerator = (NUOpaqueODictionaryEnumerator *)[self objectEnumerator];
    NUOpaqueOAssociation *anAssociation;
    BOOL aStopFlag = NO;
    
    while (!aStopFlag && (anAssociation = [anEnumerator nextAssociation]))
        aBlock(anAssociation->key, anAssociation->object, &aStopFlag);
}

@end

@implementation NUOpaqueODictionary (Private)

- (NUUInt64)bucketIndexForKey:(NUUInt8 *)aKey
{
    return keyHash(aKey, self) % bucketCount;
}

- (void)rehash
{
    NUUInt64 aNewBucketCount = bucketCount * 2;
    NUOpaqueOBucket *aNewBuckets = calloc(aNewBucketCount, sizeof(NUOpaqueOBucket));
    NUUInt64 aNewBucketLoadCountLimit = bucketLoadCountLimit * 2;
    NUUInt64 aNewBucketLoadCount = 0;
    
    for (NUUInt64 i = 0; i < bucketCount; i++)
    {
        for (NUUInt64 j = 0; j < buckets[i].count; j++)
        {
            NUUInt64 aNewBucketIndex = keyHash(getAssociation(j, &buckets[i], self)->key, self) % aNewBucketCount;
            
            if (aNewBuckets[aNewBucketIndex].count == aNewBuckets[aNewBucketIndex].capacity)
            {
                if (aNewBuckets[aNewBucketIndex].count == 0)
                    aNewBucketLoadCount++;
                
                [self growBucket:&aNewBuckets[aNewBucketIndex]];
            }
            
            NUOpaqueOAssociation *aNewAssociation = getAssociation(aNewBuckets[aNewBucketIndex].count, &aNewBuckets[aNewBucketIndex], self);
            setKey(aNewAssociation->key,  getAssociation(j, &buckets[i], self)->key, self);
            aNewAssociation->object = [getAssociation(j, &buckets[i], self)->object retain];
            aNewBuckets[aNewBucketIndex].count++;
            
            [getAssociation(j, &buckets[i], self)->object release];
        }
    }
    
    [self releaseBuckets:buckets count:bucketCount releaseObject:NO];
    buckets = aNewBuckets;
    bucketCount = aNewBucketCount;
    bucketLoadCount = aNewBucketLoadCount;
    bucketLoadCountLimit = aNewBucketLoadCountLimit;
}

- (void)growBucket:(NUOpaqueOBucket *)aBucket
{
    NUUInt64 aNewAssociationCapacity = aBucket->capacity * 2;
    
    if (aNewAssociationCapacity == 0)
    {
        aNewAssociationCapacity = 1;
        aBucket->associations = allocAssociations(aNewAssociationCapacity, self);
    }
    else
    {
        aBucket->associations = reallocAssociations(aBucket->associations, aBucket->capacity, aNewAssociationCapacity, self);
    }
    
    aBucket->capacity = aNewAssociationCapacity;
}

- (void)releaseBuckets:(NUOpaqueOBucket *)aBuckets count:(NUUInt64)aCount  releaseObject:(BOOL)aReleaseObject
{
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        if (aBuckets[i].count)
        {
            if (aReleaseObject)
            {
                for (NUUInt64 j = 0; j < aBuckets[i].count; j++)
                    [getAssociation(j, &aBuckets[i], self)->object release];
            }
            
            free(aBuckets[i].associations);
            aBuckets[i].associations = NULL;
        }
    }
    
    free(aBuckets);
    aBuckets = NULL;
}

- (NUOpaqueOBucket *)buckets
{
    return buckets;
}

- (NUUInt64)bucketCount
{
    return bucketCount;
}

@end

@implementation NUOpaqueODictionaryEnumerator

+ (id)enumeratorWithDictionary:(NUOpaqueODictionary *)aDictionary
{
    return [[(NUOpaqueODictionaryEnumerator *)[self alloc] initWithDictionary:aDictionary] autorelease];
}

- (id)initWithDictionary:(NUOpaqueODictionary *)aDictionary
{
    [super init];
    
    dictionary = [aDictionary retain];
    bucketCount = [aDictionary bucketCount];
    buckets = [aDictionary buckets];
    getAssociation = [aDictionary getAssociation];
    
    return self;
}

- (void)dealloc
{
    [dictionary release];
    dictionary = nil;
    
    [super dealloc];
}

- (NUOpaqueOAssociation *)nextAssociation
{
    NUOpaqueOAssociation *anAssociation = NULL;
    
    while(!anAssociation && bucketIndex < bucketCount)
    {
        while (!anAssociation && associationIndex < buckets[bucketIndex].count)
        {
            anAssociation = getAssociation(associationIndex, &buckets[bucketIndex], dictionary);
            associationIndex++;
        }
        
        if (associationIndex >= buckets[bucketIndex].count)
        {
            bucketIndex++;
            associationIndex = 0;
        }
    }
    
    return anAssociation;
}

- (id)nextObject
{
    NUOpaqueOAssociation *anAssociation = [self nextAssociation];
    
    return anAssociation ? anAssociation->object : nil;
}

@end