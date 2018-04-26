//
//  NUOpaqueArray.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/08.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#include <stdlib.h>
#include <string.h>
#include <math.h>
#import <Foundation/NSException.h>

#import "NUOpaqueArray.h"
#import "NUPages.h"

NSString *NUOpaqueArrayOutOfRangeException = @"NUOpaqueArrayOutOfRangeException";
NSString *NUOpaqueArrayCannotGrowException = @"NUOpaqueArrayCannotGrowException";

@implementation NUOpaqueArray
@end

@implementation NUOpaqueArray (InitializingAndRelease)

- (id)initWithValueLength:(NUUInt32)aValueLength capacity:(NUUInt32)aCapacity
{
	return [self initWithValueLength:aValueLength capacity:aCapacity comparator:NULL];
}

- (id)initWithValueLength:(NUUInt32)aValueLength capacity:(NUUInt32)aCapacity comparator:(NUInt (*)(NUUInt8 *, NUUInt8 *))aComparator
{
	[super init];
	
	valueLength = aValueLength;
	capacity = aCapacity;
	values = malloc(valueLength * capacity);
	[self setComparator:aComparator];
	
	return self;
}

- (NUOpaqueArray *)copyWithCapacity:(NUUInt32)aCapacity
{
    NUOpaqueArray *aCopy = [[[self class] alloc] initWithValueLength:valueLength capacity:aCapacity comparator:comparator];
    [aCopy setOpaqueValues:[self at:0] count:[self count]];
    return aCopy;
}

- (NUOpaqueArray *)copyWithoutValues
{
	return [[[self class] alloc] initWithValueLength:valueLength capacity:capacity comparator:comparator];
}

- (void)dealloc
{
	free(values);
	values = NULL;
	
	[super dealloc];
}

@end

@implementation NUOpaqueArray (Accessing)

- (NUUInt8 *)first
{
	return [self at:0];
}

- (NUUInt8 *)at:(NUUInt32)anIndex
{
	if (anIndex >= count)
        [[NSException exceptionWithName:NUOpaqueArrayOutOfRangeException reason:nil userInfo:nil] raise];
	
	return &values[valueLength * anIndex];
}

- (NUUInt32)valueLength
{
	return valueLength;
}

- (NUUInt32)capacity
{
	return capacity;
}

- (NUUInt32)size
{
	return [self valueLength] * [self capacity];
}

- (NUUInt8 *)values
{
	return values;
}

- (NUUInt32)count
{
	return count;
}

- (NUUInt32)indexEqualTo:(NUUInt8 *)aValue
{
	NUUInt32 anIndex = [self indexGreaterThanOrEqualTo:aValue];
	return anIndex < [self count] && [self at:anIndex isEqual:aValue] ? anIndex : NUUInt32Max;
}

- (NUUInt32)indexGreaterThanOrEqualTo:(NUUInt8 *)aValue
{
	NUInt32 aLeftIndex = 0, aRightIndex = [self count] - 1;
	
	while (aLeftIndex <= aRightIndex)
	{
		NUUInt32 aPivotIndex = (aLeftIndex + aRightIndex) / 2;
		NSComparisonResult aComparisonResult = comparator([self at:aPivotIndex], aValue);
		
		if (aComparisonResult == NSOrderedSame)
			return aPivotIndex;
		if (aComparisonResult == NSOrderedAscending)
			aLeftIndex = aPivotIndex + 1;
		else
			aRightIndex = aPivotIndex - 1;
	}
	
	return aLeftIndex;
}

- (NUInt32)indexLessThanOrEqualTo:(NUUInt8 *)aValue
{
	NUInt32 aLeftIndex = 0, aRightIndex = [self count] - 1;
	
	while (aLeftIndex <= aRightIndex)
	{
		NUUInt32 aPivotIndex = (aLeftIndex + aRightIndex) / 2;
		NSComparisonResult aComparisonResult = comparator([self at:aPivotIndex], aValue);
		
		if (aComparisonResult == NSOrderedSame)
			return aPivotIndex;
		if (aComparisonResult == NSOrderedAscending)
			aLeftIndex = aPivotIndex + 1;
		else
			aRightIndex = aPivotIndex - 1;
	}
	
	return --aLeftIndex;
}

- (NUUInt32)indexToInsert:(NUUInt8 *)aValue
{
	NUInt32 anIndexToInsert = [self indexLessThanOrEqualTo:aValue];
	
	if (anIndexToInsert == -1)
		return 0;
	else
		return [self at:anIndexToInsert isEqual:aValue] ? anIndexToInsert : anIndexToInsert + 1;
}

- (void)setComparator:(NUInt (*)(NUUInt8 *, NUUInt8 *))aComparator
{
	comparator = aComparator;
}

@end

@implementation NUOpaqueArray (Modifying)

- (void)add:(NUUInt8 *)aValue
{
	[self insert:aValue to:[self count]];
}

- (void)addValues:(NUOpaqueArray *)aValues
{
	[self insert:[aValues values] to:[self count] count:[aValues count]];
}

- (void)insert:(NUUInt8 *)aValue to:(NUUInt32)anIndex
{
	[self primitiveInsert:aValue to:anIndex];
}

- (void)insert:(NUUInt8 *)aValue to:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	[self primitiveInsert:aValue to:anIndex count:aCount];
}

- (void)replaceAt:(NUUInt32)anIndex with:(NUUInt8 *)aValue
{
	memcpy(&values[valueLength * anIndex], aValue, valueLength);
}

- (void)removeFirst
{
	[self removeAt:0];
}

- (void)removeAll
{
	[self removeAt:0 count:[self count]];
}

- (void)removeAt:(NUUInt32)anIndex
{
	[self removeAt:anIndex count:1];
}

- (void)removeAt:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	if (anIndex >= count || count - anIndex < aCount)
        [[NSException exceptionWithName:NUOpaqueArrayOutOfRangeException reason:nil userInfo:nil] raise];
    	
	if (anIndex == 0 && count == aCount)
	{
		count = 0;
		return;
	}
	
	int anIndexToMove = anIndex + aCount;

	for (; anIndexToMove < count; anIndexToMove++)
		memcpy(&values[valueLength * anIndexToMove - aCount * valueLength], &values[valueLength * anIndexToMove], valueLength);

	count -= aCount;
}

- (void)setOpaqueValues:(NUUInt8 *)aValues count:(NUUInt32)aCount
{
    if (aCount > capacity)
        [[NSException exceptionWithName:NUOpaqueArrayOutOfRangeException reason:nil userInfo:nil] raise];
	
	memcpy(values, aValues, valueLength * aCount);
	count = aCount;
}

@end

@implementation NUOpaqueArray (Testing)

- (BOOL)isFull
{
	return count == capacity;
}

- (BOOL)isEmpty
{
	return [self count] == 0;
}

- (BOOL)at:(NUUInt32)anIndex isEqual:(NUUInt8 *)aValue
{
	return comparator([self at:anIndex], aValue) == NSOrderedSame;
}

- (BOOL)at:(NUUInt32)anIndex isLessThan:(NUUInt8 *)aValue
{
    return comparator([self at:anIndex], aValue) == NSOrderedAscending;
}

- (BOOL)at:(NUUInt32)anIndex isGreaterThan:(NUUInt8 *)aValue
{
    return comparator([self at:anIndex], aValue) == NSOrderedDescending;
}

- (BOOL)isFixed
{
	return YES;
}

@end

@implementation NUOpaqueArray (SupportForBTree)

- (NUOpaqueArray *)insert:(NUUInt8 *)aValue to:(NUUInt32)anIndex insertedTo:(NUOpaqueArray **)aValues at:(NUUInt32 *)anInsertedIndex
{
	if (![self isFull])
	{
		[self primitiveInsert:aValue to:anIndex];
		return nil;
	}
	else
	{
		NUUInt32 aSplitIndex = ceil(count / (double)2);
		NUOpaqueArray *aSplitValues = [[self copyWithoutValues] autorelease];

		if (anIndex < aSplitIndex)
		{
			[aSplitValues primitiveInsert:[self at:aSplitIndex - 1] to:0 count:count - aSplitIndex - 1];
			count = aSplitIndex;
			[self primitiveInsert:aValue to:anIndex];
			if (aValues) *aValues = self;
			if (anInsertedIndex) *anInsertedIndex = anIndex;
		}
		else
		{
			[aSplitValues primitiveInsert:[self at:aSplitIndex] to:0 count:anIndex - aSplitIndex];
			[aSplitValues primitiveInsert:aValue to:[aSplitValues count]];
			if (aValues) *aValues = aSplitValues;
			if (anInsertedIndex) *anInsertedIndex = [aSplitValues count] - 1;
			if (anIndex < count) [aSplitValues primitiveInsert:[self at:anIndex] to:[aSplitValues count] count:count - anIndex];
			count = aSplitIndex;
		}
		
		return aSplitValues;
	}
}

- (NUOpaqueArray *)insert:(NUUInt8 *)aValue to:(NUUInt32)anIndex indexOfValueToPromote:(NUUInt32)anIndexToPromote into:(NUOpaqueArray **)aValueToPromote
{
	NUOpaqueArray *aSplitValues = [[self copyWithoutValues] autorelease];
	if (aValueToPromote) *aValueToPromote = [self copyWithoutValues];
	
	if (anIndex < anIndexToPromote)
	{
		[*aValueToPromote primitiveInsert:[self at:anIndexToPromote - 1] to:0];
		[aSplitValues primitiveInsert:[self at:anIndexToPromote] to:0 count:count - anIndexToPromote];
		count = anIndexToPromote - 1;
		[self primitiveInsert:aValue to:anIndex];
	}
	else if (anIndex > anIndexToPromote)
	{
		[*aValueToPromote primitiveInsert:[self at:anIndexToPromote] to:0];
		[aSplitValues primitiveInsert:[self at:anIndexToPromote + 1] to:[aSplitValues count] count:anIndex - anIndexToPromote - 1];
		[aSplitValues primitiveInsert:aValue to:[aSplitValues count]];
		if (anIndex < count) [aSplitValues primitiveInsert:[self at:anIndex] to:[aSplitValues count] count:count - anIndex];
		count = anIndexToPromote;
	}
	else
	{
		[*aValueToPromote primitiveInsert:aValue to:0];
		[aSplitValues primitiveInsert:[self at:anIndexToPromote] to:0 count:count - anIndexToPromote];
		count = anIndexToPromote;
	}
	
	return aSplitValues;
}

@end

@implementation NUOpaqueArray (SavingAndLoading)

- (void)writeTo:(NUPages *)aPages at:(NUUInt64)anOffset
{
	[aPages write:[self values] length:[self capacity] at:anOffset];
}

- (void)readFrom:(NUPages *)aPages at:(NUUInt64)anOffset capacity:(NUUInt32)aCapacity count:(NUUInt32)aCount
{
	[aPages read:[self values] length:aCapacity at:anOffset];
	count = aCount;
}

- (void)setDataFrom:(NUUInt8 *)aValues count:(NUUInt32)aCount
{
	if (aCount > capacity)
        [[NSException exceptionWithName:NUOpaqueArrayOutOfRangeException reason:nil userInfo:nil] raise];
	
	memcpy(values, aValues, valueLength * aCount);
	count = aCount;
}

@end

@implementation NUOpaqueArray (Primitives)

- (void)primitiveInsert:(NUUInt8 *)aValue to:(NUUInt32)anIndex
{
	[self primitiveInsert:aValue to:anIndex count:1];
}

- (void)primitiveInsert:(NUUInt8 *)aValues to:(NUUInt32)anIndex count:(NUUInt32)aCount
{
	if (anIndex > count)
        [[NSException exceptionWithName:NUOpaqueArrayOutOfRangeException reason:nil userInfo:nil] raise];
	if (!aCount) return;
	if (aCount > capacity - count)
	{
		if ([self isFixed]) [[NSException exceptionWithName:NUOpaqueArrayOutOfRangeException reason:nil userInfo:nil] raise];
		else [self growWithNewValuesCount:aCount];
	}
	
	NUUInt32 aCountToMove = count - anIndex;
	
	while (aCountToMove)
	{
		NUUInt32 anIndexToMove = anIndex + aCountToMove - 1;
		memcpy(&values[valueLength * anIndexToMove + valueLength * aCount], &values[valueLength * anIndexToMove], valueLength);
		aCountToMove--;
	}
	
	memcpy(&values[valueLength * anIndex], aValues, valueLength * aCount);
	count += aCount;	
}

- (void)growWithNewValuesCount:(NUUInt32)aCount
{
	if (NUUInt32Max - count < aCount)
        [[NSException exceptionWithName:NUOpaqueArrayOutOfRangeException reason:nil userInfo:nil] raise];
	
	NUUInt32 aNewCapacity = capacity * (NUUInt32)ceil(count + aCount / (double)capacity);
	void *aNewValues = realloc(values, aNewCapacity);
	if (!aNewValues)
        [[NSException exceptionWithName:NUOpaqueArrayCannotGrowException reason:nil userInfo:nil] raise];
	values = aNewValues;
	capacity = aNewCapacity;
}

@end
