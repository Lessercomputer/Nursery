//
//  NUAArch64MovzInstruction.m
//  Nursery
//
//  Created by akiha on 2025/02/26.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64MovzInstruction.h"



@implementation NUAArch64MovzInstruction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _movInstruction.bits.SF = 1;
        _movInstruction.bits.type = 2;
        _movInstruction.bits.type2 = 37;
    }
    return self;
}

- (uint32_t)instruction
{
    return [self movInstruction].instruction;
}

- (NSInteger)imm16
{
    return [self movInstruction].bits.imm16;
}

- (void)setImm16:(NSInteger)imm16
{
    _movInstruction.bits.imm16 = (uint32_t)imm16;
}

- (NSInteger)rd
{
    return [self movInstruction].bits.Rd;
}

- (void)setRd:(NSInteger)rd
{
    _movInstruction.bits.Rd = (uint32_t)rd;
}

@end
