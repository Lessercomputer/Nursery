//
//  NUMachOSegment.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSegment.h"
#import "NUMachOSection.h"
#import <Foundation/NSArray.h>

@implementation NUMachOSegment

- (void)add:(NUMachOSection *)aSection
{
    [[self sections] addObject:aSection];
    [aSection setSegment:self];
}

@end
