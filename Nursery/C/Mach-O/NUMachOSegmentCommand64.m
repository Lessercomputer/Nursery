//
//  NUMachOSegmentCommand64.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSegmentCommand64.h"
#import "NUMachOSection.h"
#import <Foundation/NSData.h>
#import <Foundation/NSArray.h>
#import <string.h>

//const int pageSize;

@implementation NUMachOSegmentCommand64

+ (instancetype)pageZeroSegmentCommand
{
    struct segment_command_64 aSegmentCommand64;
    aSegmentCommand64.cmd = LC_SEGMENT_64;
    aSegmentCommand64.nsects = 0;
    aSegmentCommand64.cmdsize = sizeof(struct segment_command_64) + sizeof(struct section_64) * aSegmentCommand64.nsects;
    strcpy(aSegmentCommand64.segname, SEG_PAGEZERO);
    aSegmentCommand64.vmaddr = 0;
    aSegmentCommand64.vmsize = 4294967296;
    aSegmentCommand64.fileoff = 0;
    aSegmentCommand64.filesize = 0;
    aSegmentCommand64.maxprot = VM_PROT_NONE;
    aSegmentCommand64.initprot = VM_PROT_NONE;
    aSegmentCommand64.flags = 0;
    
    NUMachOSegmentCommand64 *aPageZeroSegmentCommand = [[self new] autorelease];
    [aPageZeroSegmentCommand setSegmentCommand64:aSegmentCommand64];
    return aPageZeroSegmentCommand;
}

+ (instancetype)textSegmentCommand
{
    struct segment_command_64 aSegmentCommand64;
    aSegmentCommand64.cmd = LC_SEGMENT_64;
    aSegmentCommand64.nsects = 0;
    aSegmentCommand64.cmdsize = sizeof(struct segment_command_64) + sizeof(struct section_64) * aSegmentCommand64.nsects;
    strcpy(aSegmentCommand64.segname, SEG_TEXT);
    aSegmentCommand64.vmaddr = 4294967296;
    aSegmentCommand64.vmsize = 16384;//PAGE_SIZE;
    aSegmentCommand64.fileoff = 0;
    aSegmentCommand64.filesize = 4096;//16384;
    aSegmentCommand64.maxprot = VM_PROT_READ | VM_PROT_EXECUTE;
    aSegmentCommand64.initprot = VM_PROT_READ | VM_PROT_EXECUTE;
    aSegmentCommand64.flags = 0;
    
    NUMachOSegmentCommand64 *aTextSegmentCommand = [[self new] autorelease];
    [aTextSegmentCommand setSegmentCommand64:aSegmentCommand64];
    return aTextSegmentCommand;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sections = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_sections release];
    [super dealloc];
}

- (uint32_t)size
{
//    return _segmentCommand64.cmdsize;
    uint32_t aSize = sizeof(struct segment_command_64);
    aSize += sizeof(struct section_64) * [[self sections] count];
    return aSize;
}

- (uint32_t)sectionSize
{
    __block uint32_t aSectionSize = 0;
    
    [[self sections] enumerateObjectsUsingBlock:^(NUMachOSection * _Nonnull aSection, NSUInteger idx, BOOL * _Nonnull stop) {
        aSectionSize += sizeof(struct section_64);
        aSectionSize += [aSection size];
    }];
    
    return aSectionSize;
}

- (NSData *)serializedData
{
    NSMutableData *aData = [NSMutableData dataWithLength:sizeof(struct segment_command_64)];
    
    struct segment_command_64 *aSegmentCommand = [aData mutableBytes];
    aSegmentCommand->cmd = _segmentCommand64.cmd;
    aSegmentCommand->nsects = (uint32_t)[[self sections] count];
    aSegmentCommand->cmdsize = [self size];
    strcpy(aSegmentCommand->segname, _segmentCommand64.segname);
    aSegmentCommand->vmaddr = _segmentCommand64.vmaddr;
    aSegmentCommand->vmsize = _segmentCommand64.vmsize;
    aSegmentCommand->fileoff = _segmentCommand64.fileoff;
    aSegmentCommand->filesize = _segmentCommand64.filesize;
    aSegmentCommand->maxprot = _segmentCommand64.maxprot;
    aSegmentCommand->initprot = _segmentCommand64.initprot;
    aSegmentCommand->flags = _segmentCommand64.flags;
    
    [[self sections] enumerateObjectsUsingBlock:^(NUMachOSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [aData appendData:[obj serializedData]];
    }];
    
    return aData;
}

- (void)add:(NUMachOSection *)aSection
{
    [[self sections] addObject:aSection];
}

@end
