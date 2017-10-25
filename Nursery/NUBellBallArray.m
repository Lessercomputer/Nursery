//
//  NUBellBallArray.m
//  Nursery
//
//  Created by P,T,A on 2013/08/17.
//
//

#import "NUBellBallArray.h"
#import "NUPages.h"
#import "NUBellBall.h"

@implementation NUBellBallArray

+ (NUComparisonResult (*)(NUUInt8 *, NUUInt8 *))comparator
{
	return NUBellBallCompare;
}

- (id)initWithCapacity:(NUUInt32)aCapacity comparator:(NUInt (*)(NUUInt8 *, NUUInt8 *))aComparator
{
	return [super initWithValueLength:sizeof(NUBellBall) capacity:aCapacity comparator:aComparator];
}

- (void)insertBellBall:(NUBellBall)aBellBall to:(NUUInt32)anIndex
{
    [super insert:(NUUInt8 *)&aBellBall to:anIndex];
}

- (NUBellBall)bellBallAt:(NUUInt32)anIndex
{
    return *(NUBellBall *)[super at:anIndex];
}

- (void)replaceBellBallAt:(NUUInt32)anIndex with:(NUBellBall)aBellBall
{
    [self replaceAt:anIndex with:(NUUInt8 *)&aBellBall];
}

- (NSString *)description
{
    NSMutableString *aDescription = [NSMutableString string];
    
    [aDescription appendFormat:@"<%@:%p> {count: %u, ", [self class], self, [self count]];
        
    for (NUUInt32 i = 0; i < [self count]; i++)
    {
        if (i != 0) [aDescription appendString:@", "];
        
        [aDescription appendString:NUStringFromBellBall([self bellBallAt:i])];
    }
    
    [aDescription appendString:@"}"];
    
    return aDescription;
}

@end

@implementation NUBellBallArray (SavingAndLoading)

- (void)writeTo:(NUPages *)aPages at:(NUUInt64)anOffset
{
	[aPages writeUInt64Array:(NUUInt64 *)[self values] ofCount:[self capacity] * 2 at:anOffset];
}

- (void)readFrom:(NUPages *)aPages at:(NUUInt64)anOffset capacity:(NUUInt32)aCapacity count:(NUUInt32)aCount
{
	[aPages readUInt64Array:(NUUInt64 *)[self values] ofCount:aCapacity * 2 at:anOffset];
	count = aCount;
}

@end