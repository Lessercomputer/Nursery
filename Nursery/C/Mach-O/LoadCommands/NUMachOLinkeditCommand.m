//
//  NUMachOLinkeditCommand.m
//  Nursery
//
//  Created by akiha on 2025/09/27.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLinkeditCommand.h"
#import <string.h>

@implementation NUMachOLinkeditCommand

- (instancetype)init
{
    self = [super init];
    if (self) {
        struct segment_command_64 aSegmentCommand = {};
        
        aSegmentCommand.cmd = LC_SEGMENT_64;
        aSegmentCommand.cmdsize = sizeof(aSegmentCommand);
        strcpy(aSegmentCommand.segname, SEG_LINKEDIT);
        aSegmentCommand.maxprot = VM_PROT_READ | VM_PROT_WRITE | VM_PROT_EXECUTE;
        aSegmentCommand.initprot = VM_PROT_READ | VM_PROT_EXECUTE;
        
        _segmentCommand64 = aSegmentCommand;
    }
    return self;
}

@end
