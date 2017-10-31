//
//  NUMainBranchCodingContext.m
//  Nursery
//
//  Created by Akifumi Takata on 2014/03/23.
//
//

#import "NUMainBranchCodingContext.h"
#import "NUPages.h"

@implementation NUMainBranchCodingContext

+ (id)contextWithObjectLocation:(NUUInt64)anObjectLocation pages:(NUPages *)aPages
{
    return [[[self alloc] initWithObjectLocation:anObjectLocation pages:aPages] autorelease];
}

- (id)initWithObjectLocation:(NUUInt64)anObjectLocation pages:(NUPages *)aPages
{
    if (self = [super initWithObjectLocation:anObjectLocation])
    {
        pages = aPages;
    }
    
    return self;
}

- (id<NUCodingNote>)codingNote
{
    return pages;
}

@end
