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
    aSegmentCommand64.vmaddr = 0;//4294967296;
    aSegmentCommand64.vmsize = 0;//4096 * 4;
    aSegmentCommand64.fileoff = 0;
    aSegmentCommand64.filesize = 0;//8;//4096 * 4;//16384;
    aSegmentCommand64.maxprot = VM_PROT_READ | VM_PROT_EXECUTE;
    aSegmentCommand64.initprot = VM_PROT_READ | VM_PROT_EXECUTE;
    aSegmentCommand64.flags = SG_HIGHVM;
    
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

- (uint64_t)vmaddr
{
    return _segmentCommand64.vmaddr;
}

- (void)setVmaddr:(uint64_t)vmaddr
{
    _segmentCommand64.vmaddr = vmaddr;
}

- (uint64_t)vmsize
{
    return _segmentCommand64.vmsize;
}

- (void)setVmsize:(uint64_t)vmsize
{
    _segmentCommand64.vmsize = vmsize;
}

- (uint64_t)fileoff
{
    return _segmentCommand64.fileoff;
}

- (void)setFileoff:(uint64_t)fileoff
{
    _segmentCommand64.fileoff = fileoff;
}

- (uint64_t)filesize
{
    return _segmentCommand64.filesize;
}

- (void)setFilesize:(uint64_t)filesize
{
    _segmentCommand64.filesize = filesize;
}

- (uint32_t)size
{
    return _segmentCommand64.cmdsize;
}

- (BOOL)isSegmentCommand
{
    return YES;
}

//- (uint32_t)sectionSize
//{
//    __block uint32_t aSectionSize = 0;
//    
//    [[self sections] enumerateObjectsUsingBlock:^(NUMachOSection * _Nonnull aSection, NSUInteger idx, BOOL * _Nonnull stop) {
//        aSectionSize += sizeof(struct section_64);
//        aSectionSize += [aSection size];
//    }];
//    
//    return aSectionSize;
//}

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
        [self setVmaddr:[aPreviousLoadSegmentCommand vmaddr] + [aPreviousLoadSegmentCommand vmsize]];
        
        __block NUMachOSection *aPreviousSection = nil;
        [[self sections] enumerateObjectsUsingBlock:^(NUMachOSection * _Nonnull aSection, NSUInteger idx, BOOL * _Nonnull stop) {
            if (aPreviousSection)
            {
                [aSection setOffset:[aPreviousSection offset] + (uint32_t)[aPreviousSection size]];
                [aSection setAddress:[aPreviousSection address] + [aPreviousSection size]];
                [aSection setSize:[[aSection sectionData] size]];
            }
            else
            {
                if ([aPreviousLoadSegmentCommand isPageZero])
                {
                    uint64_t aRoundedSectionDataSize = [self roundUpToPageSize:[[self macho] headerAndAllLoadCommandsSize] + [[aSection sectionData] size]];
                    uint64_t aPaddingSize = aRoundedSectionDataSize - [[aSection sectionData] size];
                    
                    [aSection setPaddingSize:aPaddingSize];
                    [aSection setOffset:(uint32_t)([aPreviousLoadSegmentCommand fileoff] + [aPreviousLoadSegmentCommand filesize] + aPaddingSize)];
                    [aSection setAddress:[aPreviousLoadSegmentCommand vmaddr] + aPaddingSize];
                    [aSection setSize:[[aSection sectionData] size]];
                }
                else
                {
                    [aSection setOffset:(uint32_t)([aPreviousLoadSegmentCommand fileoff] + [aPreviousLoadSegmentCommand filesize])];
                    [aSection setAddress:[aPreviousLoadSegmentCommand vmaddr] + [aPreviousLoadSegmentCommand vmsize]];
                    [aSection setSize:[[aSection sectionData] size]];
                }
            }
            
            aSegmentDataSize += [aSection paddingSize] + [aSection size];
            aPreviousSection = aSection;
        }];
        
        uint64_t aRoundedSegmentDataSize = [self roundUpToPageSize:aSegmentDataSize];
        uint64_t aPaddingSize = aRoundedSegmentDataSize - aSegmentDataSize;
        [self setVmsize:aRoundedSegmentDataSize];
        [self setFileoff:[aPreviousLoadSegmentCommand fileoff] + [aPreviousLoadSegmentCommand filesize]];
        [self setFilesize:aRoundedSegmentDataSize];
        [self setPaddingSize:aPaddingSize];
    }
}

- (void)writeToData:(NSMutableData *)aData
{
    [aData appendBytes:&_segmentCommand64 length:sizeof(_segmentCommand64)];
    [[self sections] makeObjectsPerformSelector:@selector(writeToData:) withObject:aData];
    [aData increaseLengthBy:[self paddingSize]];
}

- (void)add:(NUMachOSection *)aSection
{
    [aSection setSegmentCommand:self];
    [aSection setPrevious:[[self sections] lastObject]];
    [[self sections] addObject:aSection];
    [[self segmentData] add:[aSection sectionData]];
}

- (void)addInstruction:(NUAArch64Instruction *)anInstruction
{
//    []
}

@end
