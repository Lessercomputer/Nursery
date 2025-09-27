//
//  NUMachOPageZeroSegmentCommand.m
//  Nursery
//
//  Created by akiha on 2025/09/27.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOPageZeroSegmentCommand.h"
#import <string.h>

@implementation NUMachOPageZeroSegmentCommand

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        struct segment_command_64 aSegmentCommand64 = {};
        aSegmentCommand64.cmd = LC_SEGMENT_64;
        aSegmentCommand64.nsects = 0;
        aSegmentCommand64.cmdsize = sizeof(struct segment_command_64) + sizeof(struct section_64) * aSegmentCommand64.nsects;
        strcpy(aSegmentCommand64.segname, SEG_PAGEZERO);
        aSegmentCommand64.vmaddr = 0;
        aSegmentCommand64.vmsize = 0x0000000100000000;//[NUMachO pageSize];
        aSegmentCommand64.fileoff = 0;
        aSegmentCommand64.filesize = 0;
        aSegmentCommand64.maxprot = VM_PROT_NONE;
        aSegmentCommand64.initprot = VM_PROT_NONE;
        aSegmentCommand64.flags = 0;
        _segmentCommand64 = aSegmentCommand64;
    }
    return self;
}

@end
