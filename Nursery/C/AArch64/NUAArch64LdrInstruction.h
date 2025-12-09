//
//  NUAArch64LdrInstruction.h
//  Nursery
//
//  Created by akiha on 2025/10/29.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64Instruction.h"

struct NUAArch64LdrInstructionBits
{
    uint32_t Rt : 5;
    uint32_t Rn : 5;
    uint32_t field0 : 2;
    uint32_t S : 1;
    uint32_t option : 3;
    uint32_t Rm : 5;
    uint32_t field1 : 11;
};

union NUAArch64LdrInstruction
{
    struct NUAArch64LdrInstructionBits bits;
    uint32_t instruction;
};

@interface NUAArch64LdrInstruction : NUAArch64Instruction

@property (nonatomic) union NUAArch64LdrInstruction ldrInstruction;

@property (nonatomic) uint32_t Rt;
@property (nonatomic) uint32_t Rn;
@property (nonatomic) uint32_t S;
@property (nonatomic) uint32_t option;
@property (nonatomic) uint32_t Rm;

@end

