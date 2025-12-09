//
//  NUMachODataSegmentCommand.m
//  Nursery
//
//  Created by akiha on 2025/09/27.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachODataSegmentCommand.h"
#import <string.h>

@implementation NUMachODataSegmentCommand

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        struct segment_command_64 aSegmentCommand64 = {};
        aSegmentCommand64.cmd = LC_SEGMENT_64;
        aSegmentCommand64.nsects = 0;
        aSegmentCommand64.cmdsize = sizeof(struct segment_command_64) + sizeof(struct section_64) * aSegmentCommand64.nsects;
        strcpy(aSegmentCommand64.segname, SEG_DATA);
        aSegmentCommand64.maxprot = VM_PROT_READ | VM_PROT_WRITE;
        aSegmentCommand64.initprot = aSegmentCommand64.maxprot;
        
        _segmentCommand64 = aSegmentCommand64;
    }
    return self;
}

@end
