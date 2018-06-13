//
//  NUOpaqueArray.h
//  Nursery
//
//  Created by Akifumi Takata on 10/10/08.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

#import "NUTypes.h"

@class NSString;
@class NUPages;

extern NSString *NUOpaqueArrayOutOfRangeException;
extern NSString *NUOpaqueArrayCannotGrowException;

@interface NUOpaqueArray : NSObject
{
	NUUInt32 valueLength;
	NUUInt32 capacity;
	NUUInt32 count;
	NUUInt8 *values;
	NUInt (*comparator)(NUUInt8 *value1, NUUInt8 *value2);
}
@end

@interface NUOpaqueArray (InitializingAndRelease)

- (id)initWithValueLength:(NUUInt32)aValueLength capacity:(NUUInt32)aCapacity;
- (id)initWithValueLength:(NUUInt32)aValueLength capacity:(NUUInt32)aCapacity comparator:(NUInt (*)(NUUInt8 *, NUUInt8 *))aComparator;

- (NUOpaqueArray *)copyWithCapacity:(NUUInt32)aCapacity;
- (NUOpaqueArray *)copyWithoutValues;

@end

@interface NUOpaqueArray (Accessing)

- (NUUInt8 *)first;
- (NUUInt8 *)at:(NUUInt32)anIndex;

- (NUUInt32)valueLength;
- (NUUInt32)capacity;
- (NUUInt32)size;
- (NUUInt8 *)values;
- (NUUInt32)count;

- (NUUInt32)indexEqualTo:(NUUInt8 *)aValue;
- (NUUInt32)indexGreaterThanOrEqualTo:(NUUInt8 *)aValue;
- (NUInt32)indexLessThanOrEqualTo:(NUUInt8 *)aValue;

- (NUUInt32)indexToInsert:(NUUInt8 *)aValue;

- (void)setComparator:(NUInt (*)(NUUInt8 *, NUUInt8 *))aComparator;

@end

@interface NUOpaqueArray (Modifying)

- (void)add:(NUUInt8 *)aValue;
- (void)addValues:(NUOpaqueArray *)aValues;
- (void)insert:(NUUInt8 *)aValue to:(NUUInt32)anIndex;
- (void)insert:(NUUInt8 *)aValue to:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)replaceAt:(NUUInt32)anIndex with:(NUUInt8 *)aValue;
- (void)removeFirst;
- (void)removeAll;
- (void)removeAt:(NUUInt32)anIndex;
- (void)removeAt:(NUUInt32)anIndex count:(NUUInt32)aCount;
- (void)setOpaqueValues:(NUUInt8 *)aValues count:(NUUInt32)aCount;

@end

@interface NUOpaqueArray (Testing)

- (BOOL)isFull;
- (BOOL)isEmpty;

- (BOOL)at:(NUUInt32)anIndex isEqual:(NUUInt8 *)aValue;
- (BOOL)at:(NUUInt32)anIndex isLessThan:(NUUInt8 *)aValue;
- (BOOL)at:(NUUInt32)anIndex isGreaterThan:(NUUInt8 *)aValue;

- (BOOL)isFixed;

@end

@interface NUOpaqueArray (SupportForBPlusTree)

- (NUOpaqueArray *)insert:(NUUInt8 *)aValue to:(NUUInt32)anIndex insertedTo:(NUOpaqueArray **)aValues at:(NUUInt32 *)anInsertedIndex;
- (NUOpaqueArray *)insert:(NUUInt8 *)aValue to:(NUUInt32)anIndex indexOfValueToPromote:(NUUInt32)anIndexToPromote into:(NUOpaqueArray **)aValueToPromote;



@end

@interface NUOpaqueArray (SavingAndLoading)

- (void)writeTo:(NUPages *)aPages at:(NUUInt64)anOffset;
- (void)readFrom:(NUPages *)aPages at:(NUUInt64)anOffset capacity:(NUUInt32)aCapacity count:(NUUInt32)aCount;

- (void)setDataFrom:(NUUInt8 *)aValues count:(NUUInt32)aCount;

@end

@interface NUOpaqueArray (Primitives)

- (void)primitiveInsert:(NUUInt8 *)aValue to:(NUUInt32)anIndex;
- (void)primitiveInsert:(NUUInt8 *)aValues to:(NUUInt32)anIndex count:(NUUInt32)aCount;

- (void)growWithNewValuesCount:(NUUInt32)aCount;

@end
