//
//  NUNodeDictionary.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/03/21.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUNodeDictionary.h"
#import "NUSpaces.h"
#import "NUPages.h"

@implementation NUNodeDictionary

NUUInt64 NUNodeDictionaryKeyHash(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary, void *aContext);

NUUInt64 NUNodeDictionaryKeyHash(NUUInt8 *aKey, NUOpaqueODictionary *aDictionary, void *aContext)
{
    NUSpaces *aSpaces = aContext;
    NUUInt64 aPageSize = [[aSpaces pages] pageSize];
    NUUInt64 aNodeLocation = *(NUUInt64 *)aKey;
    
    return aNodeLocation / aPageSize;
}

- (instancetype)initWithSpaces:(NUSpaces *)aSpaces
{
    return  [super initWithKeySize:sizeof(NUUInt64)
                          keyHash:NUNodeDictionaryKeyHash
                         keyEqual:NUU64ODictionaryKeyEqual
                           setKey:NUU64ODictionarySetKey
                allocAssociations:NUOpaqueODictionaryDefaultAllocAssociations
              reallocAssociations:NUOpaqueODictionaryDefaultReallocAssociations
                   getAssociation:NUOpaqueODictionaryDefaultGetAssociation
                  moveAssociation:NUOpaqueODictionaryDefaultMoveAssociation
                          context:aSpaces];
}

@end
