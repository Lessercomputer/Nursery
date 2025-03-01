//
//  NUMachOHeader64.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOHeader64.h"
#import "NUMachO.h"
#import <Foundation/NSData.h>

@implementation NUMachOHeader64

- (instancetype)init
{
    self = [super init];
    if (self) {
        _machHeader.magic = MH_MAGIC_64;
        _machHeader.cputype = CPU_TYPE_ARM64;
        _machHeader.cpusubtype = CPU_SUBTYPE_ARM64_ALL;
        _machHeader.filetype = MH_EXECUTE;
        _machHeader.ncmds = 0;
        _machHeader.sizeofcmds = 0;
//        _machHeader.flags = MH_NOUNDEFS | MH_DYLDLINK | MH_TWOLEVEL | MH_PIE;
        _machHeader.flags = MH_PIE;
    }
    return self;
}

- (NSData *)serializedBinaryData
{
    NSMutableData *aData = [NSMutableData dataWithLength:sizeof(struct mach_header_64)];
    struct mach_header *aMachHeaderPointer = [aData mutableBytes];
    aMachHeaderPointer->magic = _machHeader.magic;
    aMachHeaderPointer->cputype = _machHeader.cputype;
    aMachHeaderPointer->cpusubtype = _machHeader.cpusubtype;
    aMachHeaderPointer->filetype = _machHeader.filetype;
    _machHeader.ncmds = [[self machO] commandCount];
    aMachHeaderPointer->ncmds = _machHeader.ncmds;
    aMachHeaderPointer->sizeofcmds = [[self machO] commandSize];
    aMachHeaderPointer->flags = _machHeader.flags;
    
    return aData;
}

@end
