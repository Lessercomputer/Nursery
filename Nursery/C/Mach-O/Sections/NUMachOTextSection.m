//
//  NUMachOTextSection.m
//  Nursery
//
//  Created by akiha on 2025/09/28.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOTextSection.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>

#define InstructionSizeInBytes 4

@implementation NUMachOTextSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _section.align = 2;
        _instructions = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_instructions release];
    [super dealloc];
}

- (void)addInstruction:(NUAArch64Instruction *)anInstruction
{
    uint64_t anInstructionOffset = [self instructionOffsetInSection];
    [[self instructions] addObject:anInstruction];
    _instructionOffsetInSection += InstructionSizeInBytes;
}

- (void)replaceInstructionAtOffset:(uint64_t)anOffset with:(NUAArch64Instruction *)anInstruction
{
    [self replaceInstructionAt:anOffset / InstructionSizeInBytes with:anInstruction];
}

- (void)replaceInstructionAt:(uint64_t)anIndex with:(NUAArch64Instruction *)anInstruction
{
    [[self instructions] replaceObjectAtIndex:anIndex withObject:anInstruction];
}

- (uint64_t)computeSize
{
    __block uint64_t aSize = 0;
    [[self instructions] enumerateObjectsUsingBlock:^(NUAArch64Instruction * _Nonnull anInstruction, NSUInteger idx, BOOL * _Nonnull stop) {
        aSize += [anInstruction size];
    }];
    return aSize;
}

- (void)writeSectionDataToData:(NSMutableData *)aData
{
    [aData increaseLengthBy:[self leadingPaddingSize]];
    [[self instructions] makeObjectsPerformSelector:@selector(writeToData:) withObject:aData];
}

@end
