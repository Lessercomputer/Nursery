//
//  NUNodeDictionary.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/03/21.
//

#import "NUPageLocationODictionary.h"
#import "NUPages.h"

@implementation NUPageLocationODictionary

NUUInt64 NUNodeDictionaryKeyHash(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary, void *aContext);

NUUInt64 NUNodeDictionaryKeyHash(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary, void *aContext)
{
    NUUInt64 aPageSize = *(NUUInt64 *)aContext;
    NUUInt64 aNodeLocation = *(NUUInt64 *)aKey;
    
    return aNodeLocation / aPageSize;
}

- (instancetype)initWithPages:(NUPages *)aPages
{
    if (self = [super initWithKeySize:sizeof(NUUInt64)
                          keyHash:NUNodeDictionaryKeyHash
                         keyEqual:NUU64ODictionaryKeyEqual
                           setKey:NUU64ODictionarySetKey
                allocAssociations:NUOpaqueODictionaryDefaultAllocAssociations
              reallocAssociations:NUOpaqueODictionaryDefaultReallocAssociations
                   getAssociation:NUOpaqueODictionaryDefaultGetAssociation
                  moveAssociation:NUOpaqueODictionaryDefaultMoveAssociation
                          context:NULL])
    {
        pageSize = [aPages pageSize];
        context = &pageSize;
    }
    
    return self;
}

@end
