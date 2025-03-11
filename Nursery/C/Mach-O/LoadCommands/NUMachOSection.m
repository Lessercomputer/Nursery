//
//  NUMachOSection.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSection.h"
#import "NUMachOSectionData.h"
#import "NUMachOSegmentCommand64.h"
#import <Foundation/NSData.h>
#import <Foundation/NSArray.h>
#import <string.h>

@implementation NUMachOSection

+ (instancetype)textSection
{
    return [[self new] autorelease];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        strcpy(_section.sectname, SECT_TEXT);
        strcpy(_section.segname, SEG_TEXT);
        _section.addr = 0;
        _section.size = 0;
        _section.offset = 0;
        _section.align = 0;
        _section.reloff = 0;
        _section.nreloc = 0;
        _section.flags = S_ATTR_PURE_INSTRUCTIONS | S_ATTR_SOME_INSTRUCTIONS;
        _section.reserved1 = 0;
        _section.reserved2 = 0;
        _section.reserved3 = 0;
        _sectionData = [NUMachOSectionData new];
        [_sectionData setSection:self];
    }
    return self;
}

- (void)dealloc
{
    [_sectionData release];
    [super dealloc];
}

- (NUMachOSegmentData *)segmentData
{
    return [[self segmentCommand] segmentData];
}

- (BOOL)isText
{
    if (strcmp(_section.sectname, SECT_TEXT) == 0)
        return YES;
    else
        return NO;
}

- (void)add:(NUAArch64Instruction *)anInstruction
{
    [[self sectionData] addInstruction:anInstruction];
}

- (uint64_t)addr
{
    return _section.addr;
}

- (void)setAddr:(uint64_t)anAddress
{
    _section.addr = anAddress;
}

- (uint64_t)size
{
    return _section.size;
}

- (void)setSize:(uint64_t)aSize
{
    _section.size = aSize;
}

- (uint32_t)offset
{
    return _section.offset;
}

- (void)setOffset:(uint32_t)offset
{
    _section.offset = offset;
}

- (void)writeToData:(NSMutableData *)aData
{
    [aData appendBytes:&_section length:sizeof(_section)];
}

@end
