//
//  NUCLineMapping.m
//  Nursery
//
//  Created by aki on 2023/08/29.
//

#import "NUCLineMapping.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>

@implementation NUCLineMapping

@synthesize lineRange;
@synthesize otherLineRange;

+ (instancetype)lineMapping
{
    return [[[self alloc] init] autorelease];
}

+ (instancetype)lineMappingWithLineRange:(NSRange)aRange
{
    return [[[self alloc] initWithLineRange:aRange] autorelease];
}

- (instancetype)initWithLineRange:(NSRange)aRange
{
    if (self = [super init])
    {
        lineRange = aRange;
    }
    
    return self;
}

- (void)dealloc
{
    [otherLineRange release];
    
    [super dealloc];
}

- (void)addOtherLineRange:(NSValue *)aLineRange
{
    id aRangeOrArray = [self otherLineRange];
    
    if (!aRangeOrArray)
    {
        [self setOtherLineRange:aLineRange];
    }
    else if ([aRangeOrArray isKindOfClass:[NSValue class]])
    {
        aRangeOrArray = [NSMutableArray arrayWithObject:aRangeOrArray];
        [aRangeOrArray addObject:aLineRange];
        [self setOtherLineRange:aRangeOrArray];
    }
    else
        [aRangeOrArray addObject:aLineRange];
}

- (NSComparisonResult)compare:(id)anObject
{
    NSRange aRange1 = [self lineRange], aRange2 = [anObject lineRange];
    
    if (aRange1.location > aRange2.location)
        return NSOrderedDescending;
    else if (aRange1.location < aRange2.location)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}

- (BOOL)containsLocation:(NSUInteger)aLocation
{
    return NSLocationInRange(aLocation, [self lineRange]);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> lineNumber: %lu lineRange: %@ otherLineRange:%@", [self class], self, [self lineNumber], NSStringFromRange([self lineRange]), [self otherLineRange]];
}

@end
