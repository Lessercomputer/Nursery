//
//  NUAArch64MovInstruction.h
//  Nursery
//
//  Created by akiha on 2025/02/26.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64Instruction.h"

struct NUAArch64MovInstructionBits
{
//    uint32_t SF : 1;
//    uint32_t type : 2;
//    uint32_t type2 : 6;
//    uint32_t sft : 2;
//    uint32_t imm16 : 16;
//    uint32_t Rd : 5;
    
    uint32_t Rd : 5;
    uint32_t imm16 : 16;
    uint32_t sft : 2;
    uint32_t type2 : 6;
    uint32_t type : 2;
    uint32_t SF : 1;
};

union NUAArch64MovInstruction
{
    struct NUAArch64MovInstructionBits bits;
    uint32_t instruction;
};

@interface NUAArch64MovInstruction : NUAArch64Instruction

@end

