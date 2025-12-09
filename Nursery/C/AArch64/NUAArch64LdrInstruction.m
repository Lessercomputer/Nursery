//
//  NUAArch64LdrInstruction.m
//  Nursery
//
//  Created by akiha on 2025/10/29.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64LdrInstruction.h"

@implementation NUAArch64LdrInstruction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _ldrInstruction.bits.field1 = 0x7CA;
//        _ldrInstruction.bits.field0 = 0x2;
    }
    return self;
}

- (uint32_t)instruction
{
    return _ldrInstruction.instruction;
}

- (uint32_t)Rt
{
    return [self ldrInstruction].bits.Rt;
}

- (void)setRt:(uint32_t)aValue
{
    _ldrInstruction.bits.Rt = aValue;
}

- (uint32_t)Rn
{
    return [self ldrInstruction].bits.Rn;
}

- (void)setRn:(uint32_t)aValue
{
    _ldrInstruction.bits.Rn = aValue;
}

- (uint32_t)S
{
    return [self ldrInstruction].bits.S;
}

- (void)setS:(uint32_t)aValue
{
    _ldrInstruction.bits.S = aValue;
}

- (uint32_t)option
{
    return [self ldrInstruction].bits.option;
}

- (void)setOption:(uint32_t)aValue
{
    _ldrInstruction.bits.option = aValue;
}

- (uint32_t)Rm
{
    return [self ldrInstruction].bits.Rm;
}

- (void)setRm:(uint32_t)aValue
{
    _ldrInstruction.bits.Rm = aValue;
}

@end
