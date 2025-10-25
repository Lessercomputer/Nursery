//
//  NUAArch64AdrpInstruction.h
//  Nursery
//
//  Created by akiha on 2025/10/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64Instruction.h"

struct NUAArch64MovInstructionBits
{
    uint32_t rd : 5;
    uint32_t immhi : 19;
    uint32_t field1 : 5;
    uint32_t immlo : 2;
    uint32_t field0 : 1;
};

union NUAArch64AdrpInstruction
{
    struct NUAArch64MovInstructionBits bits;
    uint32_t instruction;
};

@interface NUAArch64AdrpInstruction : NUAArch64Instruction

@property (nonatomic) union NUAArch64AdrpInstruction adrpInstruction;
@property (nonatomic) uint32_t immlo;
@property (nonatomic) uint32_t immhi;
@property (nonatomic) uint32_t Rd;

@end

