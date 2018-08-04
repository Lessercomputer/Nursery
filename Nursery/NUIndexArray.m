//
//  NUIndexArray.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/24.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSException.h>
#import <Foundation/NSByteOrder.h>

#import "NUIndexArray.h"
#import "NUPages.h"


@implementation NUIndexArray

static NUComparisonResult compareIndex(NUUInt8 *anIndex1Pointer, NUUInt8 *anIndex2Pointer)
{
	NUUInt64 anIndex1 = *(NUUInt64 *)anIndex1Pointer;
	NUUInt64 anIndex2 = *(NUUInt64 *)anIndex2Pointer;
	
	if (anIndex1 == anIndex2)
		return NUOrderedSame;
	else if (anIndex1 < anIndex2)
		return NUOrderedAscending;
	else
		return NUOrderedDescending;
}

+ (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator
{
	return compareIndex;
}

- (id)initWithCapacity:(NUUInt32)aCapacity comparator:(NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))aComparator
{
	return [super initWithValueLength:sizeof(NUUInt64) capacity:aCapacity comparator:aComparator];
}

- (void)setDataFrom:(NUUInt8 *)aValues count:(NUUInt32)aCount
{
	if (aCount > capacity)
        [[NSException exceptionWithName:NUOpaqueArrayOutOfRangeException reason:nil userInfo:nil] raise];
	
	NUUInt64 *aDestinationIndexes = (NUUInt64 *)values;
	NUUInt64 *anIndexes = (NUUInt64 *)aValues;
	NUUInt32 i = 0;
	for (; i < aCount; i++)
		aDestinationIndexes[i] = NSSwapBigLongLongToHost(anIndexes[i]);
	
	count = aCount;
}

- (void)insertIndex:(NUUInt64)aValue to:(NUUInt32)anIndex
{
	[self insert:(NUUInt8 *)&aValue to:anIndex];
}

- (NUIndexArray *)insertIndex:(NUUInt64)aValue to:(NUUInt32)anIndex insertedTo:(NUIndexArray **)aValues at:(NUUInt32 *)anInsertedIndex
{
	return (NUIndexArray *)[self insert:(NUUInt8 *)&aValue to:anIndex insertedTo:aValues at:anInsertedIndex];
}

- (NUUInt64)indexAt:(NUUInt32)anIndex
{
	return *(NUUInt64 *)[self at:anIndex];
}

- (void)addIndex:(NUUInt64)aValue
{
	[self insertIndex:aValue to:[self count]];
}

- (NSString *)description
{
	NSMutableString *aString = [NSMutableString string];
	[aString appendFormat:@"<%@:%p> count: %d (", NSStringFromClass([self class]), self, [self count]];
	
	NUUInt32 i = 0;
	for (; i < [self count]; i++)
	{
		[aString appendFormat:@"%llu", [self indexAt:i]];
		if (i != [self count] - 1) [aString appendString:@", "];
	}
	
	[aString appendString:@")"];
	
	return aString;
}

@end

@implementation NUIndexArray (SavingAndLoading)

- (void)writeTo:(NUPages *)aPages at:(NUUInt64)anOffset
{
	[aPages writeUInt64Array:(NUUInt64 *)[self values] ofCount:[self capacity] at:anOffset];
}

- (void)readFrom:(NUPages *)aPages at:(NUUInt64)anOffset capacity:(NUUInt32)aCapacity count:(NUUInt32)aCount
{
    if (aCount > aCapacity)
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil];
    
	[aPages readUInt64Array:(NUUInt64 *)[self values] ofCount:aCapacity at:anOffset];
	count = aCount;
}

@end
