//
//  NUIndexArray.h
//  Nursery
//
//  Created by Akifumi Takata on 10/10/24.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUOpaqueArray.h"


@interface NUIndexArray : NUOpaqueArray
{

}

+ (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator;

- (id)initWithCapacity:(NUUInt32)aCapacity comparator:(NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))aComparator;

- (void)insertIndex:(NUUInt64)aValue to:(NUUInt32)anIndex;
- (NUIndexArray *)insertIndex:(NUUInt64)aValue to:(NUUInt32)anIndex insertedTo:(NUIndexArray **)aValues at:(NUUInt32 *)anInsertedIndex;
- (NUUInt64)indexAt:(NUUInt32)anIndex;

- (void)addIndex:(NUUInt64)aValue;

@end
