//
//  NUAArch64RetInstruction.h
//  Nursery
//
//  Created by akiha on 2025/02/26.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64Instruction.h"

struct NUAArch64RetInstructionBits
{
//    uint32_t field0 : 7;
//    uint32_t field1 : 4;
//    uint32_t field2 : 5;
//    uint32_t field3 : 6;
//    uint32_t Rn : 5;
//    uint32_t field5 : 5;
    
    uint32_t field5 : 5;
    uint32_t Rn : 5;
    int32_t field3 : 6;
    uint32_t field2 : 5;
    uint32_t field1 : 4;
    uint32_t field0 : 7;
};

union NUAArch64RetInstruction
{
    struct NUAArch64RetInstructionBits bits;
    uint32_t instruction;
};

@interface NUAArch64RetInstruction : NUAArch64Instruction

@property (nonatomic) union NUAArch64RetInstruction retInstruction;

@property (nonatomic) NSInteger rn;

@end

