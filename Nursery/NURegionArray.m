//
//  NURegionArray.m
//  Nursery
//
//  Created by Akifumi Takata on 10/10/19.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NURegionArray.h"
#import "NUPages.h"
#import "NURegion.h"


@implementation NURegionArray

- (id)initWithCapacity:(NUUInt32)aCapacity comparator:(NUInt (*)(NUUInt8 *, NUUInt8 *))aComparator
{
	return [super initWithValueLength:sizeof(NURegion) capacity:aCapacity comparator:aComparator];
}

- (void)insertRegion:(NURegion)aRegion to:(NUUInt32)anIndex
{
	[super insert:(NUUInt8 *)&aRegion to:anIndex];
}

- (NURegion)regionAt:(NUUInt32)anIndex
{
	return *(NURegion *)[super at:anIndex];
}

- (void)replaceRegionAt:(NUUInt32)anIndex with:(NURegion)aRegion
{
	[self replaceAt:anIndex with:(NUUInt8 *)&aRegion];
}

- (NSString *)description
{
    NSMutableString *aDescription = [NSMutableString string];
    
    [aDescription appendFormat:@"<%@:%p> {count: %u, ", [self class], self, [self count]];
    
    BOOL aFirstFlag = YES;
    
    for (NUUInt32 i = 0; i < [self count]; i++)
    {
        if (!aFirstFlag)
            [aDescription appendString:@", "];
        else
            aFirstFlag = NO;
        
        [aDescription appendString:NUStringFromRegion([self regionAt:i])];
    }
    
    [aDescription appendString:@"}"];

    return aDescription;
}
@end

@implementation NURegionArray (SavingAndLoading)

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
