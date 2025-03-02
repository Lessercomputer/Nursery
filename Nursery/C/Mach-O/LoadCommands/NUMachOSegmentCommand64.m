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
    struct segment_command_64 aSegmentCommand64;
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
    struct segment_command_64 aSegmentCommand64;
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
    if ([self isPageZero])
        return;
    
    NUMachOSegmentCommand64 *aPreviousLoadSegmentCommand = [self previousLoadSegmentCommand];
    
    if (aPreviousLoadSegmentCommand)
    {
//        [[self sections] makeObjectsPerformSelector:@selector(computeLayout)];
        uint32_t aSegmentDataSize = (uint32_t)[[self segmentData] size];
        uint32_t aRoundupedSegmentDataSize = (uint32_t)[self roundUpToPageSize:aSegmentDataSize];
        
        struct segment_command_64 aPreviousSegmentCommand = aPreviousLoadSegmentCommand.segmentCommand64;
        _segmentCommand64.vmaddr = aPreviousSegmentCommand.vmaddr + aPreviousSegmentCommand.vmsize;
        _segmentCommand64.vmsize = aRoundupedSegmentDataSize;
        
        _segmentCommand64.fileoff = aPreviousSegmentCommand.fileoff + aPreviousSegmentCommand.filesize;
        _segmentCommand64.filesize = aRoundupedSegmentDataSize;
        
        [self setPaddingSize:aRoundupedSegmentDataSize - aSegmentDataSize];
        
        __block NUMachOSection *aPreviousSection = nil;
        [[self sections] enumerateObjectsUsingBlock:^(NUMachOSection * _Nonnull aSection, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0)
            {
                [aSection setOffset:[self paddingSize]];
                [aSection setAddress:[self paddingSize] + _segmentCommand64.vmaddr];
            }
            else
            {
                [aSection setOffset:[aPreviousSection offset] + (uint32_t)[aPreviousSection size]];
                [aSection setAddress:[self paddingSize] + [aPreviousSection address] + [aPreviousSection size]];
            }
            
            [aSection setSize:[[aSection sectionData] size]];
            aPreviousSection = aSection;
        }];
    }
    else
    {

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

- (void)addInstruction:(NUAArch64Instruction *)anInstruction
{
//    []
}

@end
