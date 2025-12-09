//
//  NUAArch64AddInstruction.h
//  Nursery
//
//  Created by akiha on 2025/10/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64Instruction.h"

struct NUAArch64AddInstructionBits
{
    uint32_t Rd : 5;
    uint32_t Rn : 5;
    uint32_t imm12 : 12;
    uint32_t sh : 1;
    uint32_t field0 : 6;
    uint32_t S : 1;
    uint32_t op : 1;
    uint32_t sf : 1;
};

union NUAArch64AddInstruction
{
    struct NUAArch64AddInstructionBits bits;
    uint32_t instruction;
};

@interface NUAArch64AddInstruction : NUAArch64Instruction

@property (nonatomic) union NUAArch64AddInstruction addInstruction;

@property (nonatomic) uint32_t Rd;
@property (nonatomic) uint32_t Rn;
@property (nonatomic) uint32_t imm12;
@property (nonatomic) uint32_t sh;
@property (nonatomic) uint32_t SF;

@end

