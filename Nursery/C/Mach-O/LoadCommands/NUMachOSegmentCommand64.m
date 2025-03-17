//
//  NUMachOSegmentCommand64.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSegmentCommand64.h"
#import "NUMachOSection.h"
#import "NUMachOHeader64.h"
#import "NUMachO.h"
#import "NUMachOSegmentData.h"
#import "NUMachOSectionData.h"
#import <Foundation/NSData.h>
#import <Foundation/NSArray.h>
#import <string.h>

@implementation NUMachOSegmentCommand64

+ (instancetype)pageZeroSegmentCommand
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
    
    NUMachOSegmentCommand64 *aPageZeroSegmentCommand = [[self new] autorelease];
    [aPageZeroSegmentCommand setSegmentCommand64:aSegmentCommand64];
    return aPageZeroSegmentCommand;
}

+ (instancetype)textSegmentCommand
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
    
    NUMachOSegmentCommand64 *aTextSegmentCommand = [[self new] autorelease];
    [aTextSegmentCommand setSegmentCommand64:aSegmentCommand64];
    return aTextSegmentCommand;
}

+ (instancetype)linkeditCommand
{
    struct segment_command_64 aSegmentCommand = {};
    
    aSegmentCommand.cmd = LC_SEGMENT_64;
    aSegmentCommand.cmdsize = sizeof(aSegmentCommand);
    strcpy(aSegmentCommand.segname, SEG_LINKEDIT);
    aSegmentCommand.maxprot = VM_PROT_READ | VM_PROT_WRITE | VM_PROT_EXECUTE;
    aSegmentCommand.initprot = VM_PROT_READ | VM_PROT_EXECUTE;
    
    NUMachOSegmentCommand64 *aLinkeditCommand = [self loadCommand];
    [aLinkeditCommand setSegmentCommand64:aSegmentCommand];
    
    return aLinkeditCommand;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sections = [NSMutableArray new];
        _segmentData = [NUMachOSegmentData new];
        [_segmentData setSegmentCommand:self];
    }
    return self;
}

- (void)dealloc
{
    [_sections release];
    [_segmentData release];
    [super dealloc];
}

- (BOOL)isPageZero
{
    return strcmp(_segmentCommand64.segname, SEG_PAGEZERO) == 0;
}

- (BOOL)isText
{
    return strcmp(_segmentCommand64.segname, SEG_TEXT) == 0;
}

- (BOOL)isLinkedit
{
    return strcmp(_segmentCommand64.segname, SEG_LINKEDIT) == 0;
}

- (uint64_t)vmaddr
{
    return _segmentCommand64.vmaddr;
}

- (void)setVmaddr:(uint64_t)aVvmaddr
{
    _segmentCommand64.vmaddr = aVvmaddr;
}

- (uint64_t)vmsize
{
    return _segmentCommand64.vmsize;
}

- (void)setVmsize:(uint64_t)aVmsize
{
    _segmentCommand64.vmsize = aVmsize;
}

- (uint64_t)nextVMAddr
{
    return [self vmaddr] + [self vmsize];
}

- (uint64_t)fileoff
{
    return _segmentCommand64.fileoff;
}

- (void)setFileoff:(uint64_t)aFileoff
{
    _segmentCommand64.fileoff = aFileoff;
}

- (uint64_t)filesize
{
    return _segmentCommand64.filesize;
}

- (void)setFilesize:(uint64_t)aFilesize
{
    _segmentCommand64.filesize = aFilesize;
}

- (uint64_t)nextFileoff
{
    return [self fileoff] + [self filesize];
}

- (uint32_t)size
{
    return _segmentCommand64.cmdsize;
}

- (BOOL)isSegmentCommand
{
    return YES;
}

- (void)computeLayout
{
    [self computeLoadCommandSize];
    [self computeSegmentDataLayout];
}

- (void)computeLoadCommandSize
{
    _segmentCommand64.nsects = (uint32_t)[[self sections] count];
    _segmentCommand64.cmdsize = [self roundUpLoadCommandSize:sizeof(struct segment_command_64) + sizeof(struct section_64) * _segmentCommand64.nsects];
}

- (void)computeSegmentDataLayout
{
    NUMachOSegmentCommand64 *aPreviousLoadSegmentCommand = [self previousLoadSegmentCommand];
    
    if (aPreviousLoadSegmentCommand)
    {
        __block uint64_t aSegmentDataSize = 0;
        [self setVmaddr:[aPreviousLoadSegmentCommand nextVMAddr]];
        
        __block NUMachOSection *aPreviousSection = nil;
        [[self sections] enumerateObjectsUsingBlock:^(NUMachOSection * _Nonnull aSection, NSUInteger idx, BOOL * _Nonnull stop) {
            if (aPreviousSection)
            {
                [aSection setOffset:[aPreviousSection offset] + (uint32_t)[aPreviousSection size]];
                [aSection setAddr:[aPreviousSection addr] + [aPreviousSection size]];
                [aSection setSize:[[aSection sectionData] size]];
            }
            else
            {
                if ([aPreviousLoadSegmentCommand isPageZero])
                {
                    uint64_t aRoundedSectionDataSize = [self roundUpToPageSize:[[self macho] headerAndAllLoadCommandsSize] + [[aSection sectionData] size]];
                    uint64_t aPaddingSize = aRoundedSectionDataSize - [[self macho] headerAndAllLoadCommandsSize] - [[aSection sectionData] size];
                    
                    [aSection setPaddingSize:aPaddingSize];
                    [aSection setOffset:(uint32_t)([aPreviousLoadSegmentCommand nextFileoff] + [[self macho] headerAndAllLoadCommandsSize] + aPaddingSize)];
                    [aSection setAddr:[aPreviousLoadSegmentCommand nextVMAddr] + [[self macho] headerAndAllLoadCommandsSize] + aPaddingSize];
                    [aSection setSize:[[aSection sectionData] size]];
                }
                else
                {
                    [aSection setOffset:(uint32_t)[aPreviousLoadSegmentCommand nextFileoff]];
                    [aSection setAddr:[aPreviousLoadSegmentCommand nextVMAddr]];
                    [aSection setSize:[[aSection sectionData] size]];
                }
            }
            
            aSegmentDataSize += [aSection paddingSize] + [aSection size];
            aPreviousSection = aSection;
        }];
        
        uint64_t aRoundedSegmentDataSize = [self roundUpToPageSize:aSegmentDataSize];
        if (!aRoundedSegmentDataSize)
            aRoundedSegmentDataSize = [[self macho] pageSize];
        uint64_t aPaddingSize = aRoundedSegmentDataSize - aSegmentDataSize;
        [self setVmsize:aRoundedSegmentDataSize];
        [self setFileoff:[aPreviousLoadSegmentCommand nextFileoff]];
        [self setFilesize:aRoundedSegmentDataSize];
        [self setPaddingSize:aPaddingSize];
    }
}

- (void)writeToData:(NSMutableData *)aData
{
    [aData appendBytes:&_segmentCommand64 length:sizeof(_segmentCommand64)];
    [[self sections] makeObjectsPerformSelector:@selector(writeToData:) withObject:aData];
}

- (void)add:(NUMachOSection *)aSection
{
    [aSection setSegmentCommand:self];
    [aSection setPrevious:[[self sections] lastObject]];
    [[self sections] addObject:aSection];
    [[self segmentData] add:[aSection sectionData]];
}

@end
