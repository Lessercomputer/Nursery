//
//  NUMainBranchCodingContext.h
//  Nursery
//
//  Created by Akifumi Takata on 2014/03/23.
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
