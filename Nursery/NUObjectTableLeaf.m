//
//  NUObjectTableLeaf.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/17.
//

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>

#import "NUObjectTableLeaf.h"
#import "NUObjectTable.h"
#import "NUOpaqueArray.h"
#import "NUIndexArray.h"
#import "NUBellBallArray.h"
#import "NUBellBall.h"


@implementation NUObjectTableLeaf

+ (NUUInt64)nodeOOP
{
	return NUObjectTableLeafNodeOOP;
}

- (NUOpaqueArray *)makeKeyArray
{
	return [[[NUBellBallArray alloc] initWithCapacity:[self keyCapacity] comparator:[[self tree] comparator]] autorelease];
}

- (NUOpaqueArray *)makeValueArray
{
	return [[[NUIndexArray alloc] initWithCapacity:[self valueCapacity] comparator:[[self tree] comparator]] autorelease];
}

- (NUOpaqueArray *)makeGCMarks
{
	return [[[NUOpaqueArray alloc] initWithValueLength:sizeof(NUUInt8) capacity:[self valueCapacity]] autorelease];
}

- (void)setNewExtraValues
{
	[self setGCMarks:[self makeGCMarks]];
}

- (NUUInt32)extraValueLength
{
	return sizeof(NUUInt8);
}

- (NUOpaqueArray *)gcMarks
{
	return gcMarks;
}

- (void)setGCMarks:(NUOpaqueArray *)aGCMarks
{
	[gcMarks autorelease];
	gcMarks = [aGCMarks retain];
}

- (NUUInt8)newGCMark
{
	return [(NUObjectTable *)[self tree] newGCMark];
}

- (NUUInt8)gcMarkAt:(NUUInt32)anIndex
{
	return *(NUUInt8 *)[[self gcMarks] at:anIndex];
}

- (void)setGCMark:(NUUInt8)aMark at:(NUUInt32)anIndex
{
	[[self gcMarks] replaceAt:anIndex with:(NUUInt8 *)&aMark];
    [self markChanged];
}

- (void)removeAllGCMarks
{
	[[self gcMarks] removeAll];
}

- (NSArray *)insertNewExtraValueTo:(NUUInt32)anIndex
{
	NUUInt8 aGCMark = [self newGCMark];
    
    if ([self isFull])
    {
        NUOpaqueArray *aTemporaryGCMarks = [[[self gcMarks] copyWithCapacity:[[self gcMarks] capacity] + 1] autorelease];
        [aTemporaryGCMarks insert:&aGCMark to:anIndex];
        [[self gcMarks] setOpaqueValues:[aTemporaryGCMarks at:0] count:[self minValueCount]];
        NUOpaqueArray *aNewGCMarks = [[[self gcMarks] copyWithoutValues] autorelease];
        [aNewGCMarks setOpaqueValues:[aTemporaryGCMarks at:[self minValueCount]] count:[aTemporaryGCMarks count] - [self minValueCount]];
        return [NSArray arrayWithObject:aNewGCMarks];
    }
    else
    {
        [[self gcMarks] insert:&aGCMark to:anIndex];
        return nil;
    }
}

- (NSArray *)extraValues
{
    return [NSArray arrayWithObject:[self gcMarks]];
}

- (void)setExtraValues:(NSArray *)anExtraValues
{
	[self setGCMarks:[anExtraValues objectAtIndex:0]];
}

- (void)removeExtraValueAt:(NUUInt32)anIndex
{
	[[self gcMarks] removeAt:anIndex];
}

- (void)shuffleExtraValuesOfLeftNode
{
    [self shuffleLeftNodeKeysOrValues:[(NUObjectTableLeaf *)[self leftNode] gcMarks] with:[self gcMarks]];
}

- (void)shuffleExtraValuesOfRightNode
{
    [self shuffleRightNodeKeysOrValues:[self gcMarks] with:[(NUObjectTableLeaf *)[self rightNode] gcMarks]];
}

- (void)mergeExtraValuesOfLeftNode:(NUOpaqueBPlusTreeLeaf *)aNode
{
    NUObjectTableLeaf *aLeaf = (NUObjectTableLeaf *)aNode;
	[[self gcMarks] insert:[[aLeaf gcMarks] at:0] to:0 count:[[aLeaf gcMarks] count]];
	[aLeaf removeAllGCMarks];
}

- (void)mergeExtraValuesOfRightNode:(NUOpaqueBPlusTreeLeaf *)aNode
{
	NUObjectTableLeaf *aLeaf = (NUObjectTableLeaf *)aNode;
	[[self gcMarks] addValues:[aLeaf gcMarks]];
	[aLeaf removeAllGCMarks];
}

- (void)readExtraValuesFromPages:(NUPages *)aPages at:(NUUInt64)aLocation count:(NUUInt32)aCount
{
	NUOpaqueArray *aGCMarks = [[[NUOpaqueArray alloc] initWithValueLength:sizeof(NUUInt8) capacity:[self valueCapacity]] autorelease];
	[aGCMarks readFrom:aPages at:aLocation capacity:[self valueCapacity] count:aCount];
	[self setGCMarks:aGCMarks];
}

- (void)writeExtraValuesToPages:(NUPages *)aPages at:(NUUInt64)aLocation
{
	[[self gcMarks] writeTo:aPages at:aLocation];
}

- (NSString *)description
{
	NSMutableString *aString = [NSMutableString stringWithFormat:
				@"<%@:%p>{", NSStringFromClass([self class]), self];
	NUUInt32 i = 0;
	
	for (; i < [self keyCount]; i++)
	{
		[aString appendFormat:@"(%@, %llu}",
			NUStringFromBellBall([(NUBellBallArray *)[self keys] bellBallAt:i]),
			[(NUIndexArray *)[self values] indexAt:i]];
		if (i != [self keyCount] - 1)
			[aString appendString:@", "];
	}
	
	[aString appendString:@")"];
	
	return aString;
}

- (void)dealloc
{
	[self setGCMarks:nil];
	
	[super dealloc];
}

@end
