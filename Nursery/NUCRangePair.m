//
//  NUCRangePair.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2020/04/27.
//  Copyright © 2020年 Nursery-Framework. All rights reserved.
//

#import "NUCRangePair.h"

@implementation NUCRangePair

+ (instancetype)rangePairWithRangeFrom:(NURegion)aRangeFrom rangeTo:(NURegion)aRangeTo
{
    return [[[self alloc] initWithRangeFrom:aRangeFrom rangeTo:aRangeTo] autorelease];
}

- (instancetype)initWithRangeFrom:(NURegion)aRangeFrom rangeTo:(NURegion)aRangeTo
{
    if (self = [super init])
    {
        rangeFrom = aRangeFrom;
        rangeTo = aRangeTo;
    }
    
    return self;
}

- (NURegion)rangeFrom
{
    return rangeFrom;
}

- (void)setRangeFrom:(NURegion)aRangeFrom
{
    rangeFrom = aRangeFrom;
}

- (NURegion)rangeTo
{
    return rangeTo;
}

- (void)setRangeTo:(NURegion)aRangeTo
{
    rangeTo = aRangeTo;
}

@end

@implementation NUCRangePairFromComparator

+ (instancetype)comparator
{
    return [[self new] autorelease];
}

- (NSComparisonResult)compareObject:(NUCRangePair *)aRangePair1 toObject:(NUCRangePair *)aRangePair2
{
    if ([aRangePair1 rangeFrom].location == [aRangePair2 rangeFrom].location)
        return NSOrderedSame;
    else if ([aRangePair1 rangeFrom].location < [aRangePair2 rangeFrom].location)
        return NSOrderedAscending;
    else
        return NSOrderedDescending;
}

@end

@implementation NUCRangePairToComparator

+ (instancetype)comparator
{
    return [[self new] autorelease];
}

- (NSComparisonResult)compareObject:(NUCRangePair *)aRangePair1 toObject:(NUCRangePair *)aRangePair2
{
    if ([aRangePair1 rangeTo].location == [aRangePair2 rangeTo].location)
        return NSOrderedSame;
    else if ([aRangePair1 rangeTo].location < [aRangePair2 rangeTo].location)
        return NSOrderedAscending;
    else
        return NSOrderedDescending;
}

@end
