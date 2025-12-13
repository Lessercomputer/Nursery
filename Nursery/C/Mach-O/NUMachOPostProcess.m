//
//  NUMachOPostProcess.m
//  Nursery
//
//  Created by akiha on 2025/09/28.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOPostProcess.h"
#import "NUMachOTextSection.h"
#import "NUAArch64AdrpInstruction.h"
#import "NUAArch64AddInstruction.h"
#import "NUAArch64LdrInstruction.h"
#import "NUMachO.h"

@implementation NUMachOPostProcess

- (void)execute
{
    uint64_t aDataOffset = [[self dataSection] addr] + [self dataOffsetInSection];
    uint64_t anInstructionOffet = [[self textSection] addr] + [self instructionOffsetInSection];
    
    uint64_t anOffset;
    uint64_t aPageAddressOfData = [NUAArch64Instruction pageAddressOf:aDataOffset offsetInPage:&anOffset];
    uint64_t aPageAddressOfInstruction = [NUAArch64Instruction pageAddressOf:anInstructionOffet offsetInPage:NULL];
    uint64_t aPageCount = (aPageAddressOfData - aPageAddressOfInstruction + ([[self macho] pageSize] - 1)) / [[self macho] pageSize];

    uint64_t anInstructionOffsetInSection = [self instructionOffsetInSection];
    
    NUAArch64AdrpInstruction *anAdrpInstruction = [NUAArch64AdrpInstruction instruction];
    NUAArch64AddInstruction *anAddInstruction = [NUAArch64AddInstruction instruction];
    NUAArch64LdrInstruction *anLdrInstruction = [NUAArch64LdrInstruction instruction];
    
    [anAdrpInstruction setRd:1];
    [anAdrpInstruction setImmhi:aPageCount & 0x3FFFFC];
    [anAdrpInstruction setImmlo:aPageCount & 0x3];
    
    [anAddInstruction setRd:1];
    [anAddInstruction setRn:1];
    [anAddInstruction setImm12:(uint32_t)anOffset];
    
    [anLdrInstruction setRt:0];
    [anLdrInstruction setRn:1];
    
    [[self textSection] replaceInstructionAtOffset:anInstructionOffsetInSection with:anAdrpInstruction];
    anInstructionOffsetInSection += [anAdrpInstruction size];
    
    [[self textSection] replaceInstructionAtOffset:anInstructionOffsetInSection with:anAddInstruction];
    anInstructionOffsetInSection += [anAddInstruction size];
    
    [[self textSection] replaceInstructionAtOffset:anInstructionOffsetInSection with:anLdrInstruction];
}

@end
