//
//  NUMachOSection.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSection.h"
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
        _section.addr = 4294983584;
        _section.size = 8;
        _section.offset = 544;
        _section.align = 0;
        _section.reloff = 0;
        _section.nreloc = 0;
        _section.flags = S_ATTR_PURE_INSTRUCTIONS | S_ATTR_SOME_INSTRUCTIONS;
        _section.reserved1 = 0;
        _section.reserved2 = 0;
        _section.reserved3 = 0;
        _instructions = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_instructions release];
    [super dealloc];
}

- (void)add:(NUAArch64Instruction *)anInstruction
{
    [[self instructions] addObject:anInstruction];
}

- (uint32_t)size
{
    __block uint32_t aSize = 0;
    [[self instructions] enumerateObjectsUsingBlock:^(NUAArch64Instruction * _Nonnull anInstruction, NSUInteger idx, BOOL * _Nonnull stop) {
        aSize += [anInstruction size];
    }];
    return aSize;
}

- (NSData *)serializedData
{
    NSMutableData *aData = [NSMutableData dataWithLength:sizeof(struct section_64)];
    
    struct section_64 *aSection = [aData mutableBytes];
    strcpy(aSection->sectname, _section.sectname);
    strcpy(aSection->segname, _section.segname);
    aSection->addr = _section.addr;
    aSection->size = [self size];
    aSection->offset = _section.offset;
    aSection->align = _section.align;
    aSection->reloff = _section.nreloc;
    aSection->flags = _section.flags;
    aSection->reserved1 = _section.reserved1;
    aSection->reserved2 = _section.reserved2;
    aSection->reserved3 = _section.reserved3;
    
    return aData;
}

@end
