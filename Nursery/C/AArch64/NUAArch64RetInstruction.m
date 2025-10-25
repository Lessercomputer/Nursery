//
//  NUAArch64RetInstruction.m
//  Nursery
//
//  Created by akiha on 2025/02/26.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64RetInstruction.h"

@implementation NUAArch64RetInstruction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _retInstruction.bits.field0 = 107;
        _retInstruction.bits.field1 = 2;
        _retInstruction.bits.field2 = 31;
        _retInstruction.bits.field3 = 0;
        _retInstruction.bits.Rn = 30;
        _retInstruction.bits.field5 = 0;
    }
    return self;
}

- (uint32_t)instruction
{
    return _retInstruction.instruction;
}

- (uint32_t)rn
{
    return _retInstruction.bits.Rn;
}

- (void)setRn:(uint32_t)rn
{
    _retInstruction.bits.Rn = rn;
}

@end
