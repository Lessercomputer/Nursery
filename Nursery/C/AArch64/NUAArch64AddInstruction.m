//
//  NUAArch64AddInstruction.m
//  Nursery
//
//  Created by akiha on 2025/10/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64AddInstruction.h"

@implementation NUAArch64AddInstruction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _addInstruction.bits.sf = 1;
        _addInstruction.bits.field0 = 0x22;
    }
    return self;
}

- (uint32_t)instruction
{
    return _addInstruction.instruction;
}

- (uint32_t)Rd
{
    return [self addInstruction].bits.Rd;
}

- (void)setRd:(uint32_t)aValue
{
    _addInstruction.bits.Rd = aValue;
}

- (uint32_t)Rn
{
    return [self addInstruction].bits.Rn;
}

- (void)setRn:(uint32_t)aValue
{
    _addInstruction.bits.Rn = aValue;
}

- (uint32_t)imm12
{
    return [self addInstruction].bits.imm12;
}

- (void)setImm12:(uint32_t)aValue
{
    _addInstruction.bits.imm12 = aValue;
}

@end
