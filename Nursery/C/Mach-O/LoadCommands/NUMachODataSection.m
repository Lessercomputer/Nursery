//
//  NUMachODataSection.m
//  Nursery
//
//  Created by akiha on 2025/09/24.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachODataSection.h"
#import <Foundation/NSData.h>
#import <string.h>

@implementation NUMachODataSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        strcpy(_section.sectname, SECT_DATA);
        strcpy(_section.segname, SEG_DATA);
        _section.addr = 0;
        _section.size = 0;
        _section.offset = 0;
        _section.align = 0;
        _section.reloff = 0;
        _section.nreloc = 0;
        _section.flags = S_REGULAR;
        _section.reserved1 = 0;
        _section.reserved2 = 0;
        _section.reserved3 = 0;
    }
    return self;
}

- (uint64_t)addUInt64:(uint64_t)aValue
{
    uint64_t anOffset = [[self data] length];
    [[self data] appendBytes:&aValue length:sizeof(aValue)];
    return anOffset;
}

- (uint64_t)addInt64:(int64_t)aValue
{
    uint64_t anOffset = [[self data] length];
    [[self data] appendBytes:&aValue length:sizeof(aValue)];
    return anOffset;
}

@end
