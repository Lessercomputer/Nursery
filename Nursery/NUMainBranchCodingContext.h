//
//  NUMainBranchCodingContext.h
//  Nursery
//
//  Created by P,T,A on 2014/03/23.
//
//

#import "NUCodingContext.h"

@class NUPages;

@interface NUMainBranchCodingContext : NUCodingContext
{
    NUPages *pages;
}

+ (id)contextWithObjectLocation:(NUUInt64)anObjectLocation pages:(NUPages *)aPages;

- (id)initWithObjectLocation:(NUUInt64)anObjectLocation pages:(NUPages *)aPages;

@end
