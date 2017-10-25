//
//  NUBellBallODictionary.m
//  Nursery
//
//  Created by P,T,A on 2014/02/14.
//
//

#import "NUBellBallODictionary.h"
#import "NUBellBall.h"

NUUInt64 NUBellBallODictionaryKeyHash(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary);
BOOL NUBellBallODictionaryKeyEqual(NUUInt8 *aKey1, NUUInt8 *aKey2, NUOpaqueODictionary *aDictionary);
void NUBellBallODictionarySetKey(NUUInt8 *aDestinationKey, NUUInt8 *aSourceKey, NUOpaqueODictionary *aDictionary);

NUUInt64 NUBellBallODictionaryKeyHash(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary)
{
    return ((NUBellBall *)aKey)->oop ^ ((NUBellBall *)aKey)->grade;
}

BOOL NUBellBallODictionaryKeyEqual(NUUInt8 *aKey1, NUUInt8 *aKey2, NUOpaqueODictionary *aDictionary)
{
    return NUBellBallCompare(aKey1, aKey2) == NUOrderedSame;
}

void NUBellBallODictionarySetKey(NUUInt8 *aDestinationKey, NUUInt8 *aSourceKey, NUOpaqueODictionary *aDictionary)
{
    *(NUBellBall *)aDestinationKey = *(NUBellBall *)aSourceKey;
}

@implementation NUBellBallODictionary

- (id)init
{
    self = [super initWithKeySize:sizeof(NUBellBall)
                          keyHash:NUBellBallODictionaryKeyHash
                         keyEqual:NUBellBallODictionaryKeyEqual
                           setKey:NUBellBallODictionarySetKey
                allocAssociations:NUOpaqueODictionaryDefaultAllocAssociations
              reallocAssociations:NUOpaqueODictionaryDefaultReallocAssociations
                   getAssociation:NUOpaqueODictionaryDefaultGetAssociation
                  moveAssociation:NUOpaqueODictionaryDefaultMoveAssociation];
    
    return self;
}

- (void)setObject:(id)anObject forKey:(NUBellBall)aKey
{
    [self setObject:anObject forOpaqueKey:(NUUInt8 *)&aKey];
}

- (id)objectForKey:(NUBellBall)aKey
{
    return [self objectForOpaqueKey:(NUUInt8 *)&aKey];
}

- (void)removeObjectForKey:(NUBellBall)aKey
{
    [self removeObjectForOpaqueKey:(NUUInt8 *)&aKey];
}

@end
