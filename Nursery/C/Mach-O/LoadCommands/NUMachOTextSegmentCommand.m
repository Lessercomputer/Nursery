//
//  NUMachOTextSegmentCommand.m
//  Nursery
//
//  Created by akiha on 2025/09/27.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOTextSegmentCommand.h"
#import <string.h>

@implementation NUMachOTextSegmentCommand

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        struct segment_command_64 aSegmentCommand64 = {};
        aSegmentCommand64.cmd = LC_SEGMENT_64;
        aSegmentCommand64.nsects = 0;
        aSegmentCommand64.cmdsize = sizeof(struct segment_command_64) + sizeof(struct section_64) * aSegmentCommand64.nsects;
        strcpy(aSegmentCommand64.segname, SEG_TEXT);
        aSegmentCommand64.vmaddr = 0;
        aSegmentCommand64.vmsize = 0;
        aSegmentCommand64.fileoff = 0;
        aSegmentCommand64.filesize = 0;
        aSegmentCommand64.maxprot = VM_PROT_READ | VM_PROT_EXECUTE;
        aSegmentCommand64.initprot = VM_PROT_READ | VM_PROT_EXECUTE;
        
        _segmentCommand64 = aSegmentCommand64;
    }
    return self;
}
@end
