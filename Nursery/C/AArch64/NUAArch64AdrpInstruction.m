//
//  NUAArch64AdrpInstruction.m
//  Nursery
//
//  Created by akiha on 2025/10/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64AdrpInstruction.h"

@implementation NUAArch64AdrpInstruction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _adrpInstruction.bits.field0 = 1;
        _adrpInstruction.bits.field1 = 0x10;
    }
    return self;
}

- (uint32_t)instruction
{
    return _adrpInstruction.instruction;
}

- (uint32_t)immlo
{
    return [self adrpInstruction].bits.immlo;
}

- (void)setImmlo:(uint32_t)aValue
{
    _adrpInstruction.bits.immlo = (uint32_t)aValue;
}

- (uint32_t)immhi
{
    return [self adrpInstruction].bits.immhi;
}

- (void)setImmhi:(uint32_t)aValue
{
    _adrpInstruction.bits.immhi = aValue;
}

- (uint32_t)Rd
{
    return [self adrpInstruction].bits.rd;
}

- (void)setRd:(uint32_t)aValue
{
    _adrpInstruction.bits.rd = aValue;
}

@end
