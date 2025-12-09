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

@implementation NUMachOPostProcess

- (void)execute
{
    uint64_t aDataOffset;
    uint64_t aDataPage = [NUAArch64Instruction pageOf:[[self dataSection] addr] + [self dataOffset] offset:&aDataOffset];
    
    NSLog(@"dataSection addr: %llx, aDataOffset: %llx", [[self dataSection] addr], aDataOffset);
    
    uint64_t anInstructionOffset = [self instructionOffset];
    
    NUAArch64AdrpInstruction *anAdrpInstruction = [NUAArch64AdrpInstruction instruction];
    NUAArch64AddInstruction *anAddInstruction = [NUAArch64AddInstruction instruction];
    NUAArch64LdrInstruction *anLdrInstruction = [NUAArch64LdrInstruction instruction];
    
    [anAdrpInstruction setRd:1];
    [anAdrpInstruction setImmhi:aDataPage & 0x3FFFFC];
    [anAdrpInstruction setImmlo:aDataPage & 0x3];
    
    [anAddInstruction setRd:1];
    [anAddInstruction setRn:1];
    [anAddInstruction setImm12:(uint32_t)aDataOffset];
    
    [anLdrInstruction setRt:0];
    [anLdrInstruction setRn:1];
    
    [[self textSection] replaceInstructionAtOffset:anInstructionOffset with:anAdrpInstruction];
    anInstructionOffset += [anAdrpInstruction size];
    
    [[self textSection] replaceInstructionAtOffset:anInstructionOffset with:anAddInstruction];
    anInstructionOffset += [anAddInstruction size];
    
    [[self textSection] replaceInstructionAtOffset:anInstructionOffset with:anLdrInstruction];
}

@end
