//
//  NUIndexSetCoder.m
//  Nursery
//
//  Created by P,T,A on 2013/11/17.
//
//

#import "NUIndexSetCoder.h"
#import "NUNSIndexSet.h"
#import "NUCharacter.h"
#import "NUPlayLot.h"

@implementation NUIndexSetCoder

- (id)new
{
    return [NSMutableIndexSet new];
}

- (void)encode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    [self encodeIndexedIvarsOf:anObject withAliaser:anAliaser];
}

- (void)encodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
	NSIndexSet *anIndexSet = anObject;
	NUUInt64 aCount = [anIndexSet count];
    
	if (aCount)
	{
        NUUInt64 *aValues = malloc([anIndexSet indexedIvarsSize]);
        [[self class] getRangesInIndexSet:anIndexSet into:aValues];
        [anAliaser encodeUInt64Array:aValues count:[anIndexSet indexedIvarsSize] / sizeof(NUUInt64)];
        free(aValues);
	}
}

- (void)decode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    [self decodeIndexedIvarsOf:anObject withAliaser:anAliaser];
}

- (void)decodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    NSMutableIndexSet *anIndexSet = anObject;
    [self setIndexesToIndexSet:anIndexSet withAliaser:anAliaser];
}

- (id)decodeObjectWithAliaser:(NUAliaser *)anAliaser
{
    NSMutableIndexSet *anIndexSet = [NSMutableIndexSet indexSet];
    [self decodeIndexedIvarsOf:anIndexSet withAliaser:anAliaser];
    return [[anIndexSet copy] autorelease];
}

- (BOOL)canMoveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    return [[anAliaser character] isMutable];
}

- (void)moveUpObject:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    if (![[anAliaser character] isMutable]) return;
    
    NSMutableIndexSet *anIndexSet = anObject;
    [self setIndexesToIndexSet:anIndexSet withAliaser:anAliaser];
    [[anAliaser playLot] unmarkChangedObject:anIndexSet];
}

- (void)setIndexesToIndexSet:(NSMutableIndexSet *)anIndexSet withAliaser:(NUAliaser *)anAliaser
{
    NUUInt64 aSize = [anAliaser indexedIvarsSize];
    
    if (aSize)
    {
        NUUInt64 aRangeCount = aSize / sizeof(NUUInt64) / 2;
        NUUInt64 *aValues = malloc(aSize);
        
        [anAliaser decodeUInt64Array:aValues count:aRangeCount * 2];
        
        if ([anIndexSet count])
            [anIndexSet removeAllIndexes];
        
        for (NUUInt64 i = 0; i < aRangeCount; i++)
            [anIndexSet addIndexesInRange:NSMakeRange(aValues[i * 2], aValues[i * 2 + 1])];
        
        free(aValues);
    }
}

+ (NUUInt64)getRangeCountInIndexSet:(NSIndexSet *)anIndexSet
{
    NUUInt64 aRangeCount = 0;
    NSUInteger aPreviousIndex = [anIndexSet firstIndex];
    NSUInteger anIndex;
    
    while ((anIndex = [anIndexSet indexGreaterThanIndex:aPreviousIndex]) != NSNotFound)
    {
        if (aPreviousIndex + 1 != anIndex)
            aRangeCount++;
        
        aPreviousIndex = anIndex;
    }
    
    if (aPreviousIndex != NSNotFound)
        aRangeCount++;
    
    return aRangeCount;
}

+ (void)getRangesInIndexSet:(NSIndexSet *)anIndexSet into:(NUUInt64 *)aRanges
{
    if ([anIndexSet count] == 0) return;
    
    NUUInt64 aLocation = [anIndexSet firstIndex], aLength = 1;
    NSUInteger anIndex = aLocation;
    NUUInt64 aLocationIndex = 0;
    
    while (YES)
    {
        while (YES)
        {
            anIndex = [anIndexSet indexGreaterThanIndex:anIndex];
            
            if (aLocation + aLength == anIndex)
                aLength++;
            else
            {
                aRanges[aLocationIndex] = aLocation;
                aRanges[aLocationIndex + 1] = aLength;
                aLocationIndex += 2;
                aLocation = anIndex;
                aLength = 1;
                break;
            }
        }
        
        if (aLocation == NSNotFound)
            break;
    }
}

@end