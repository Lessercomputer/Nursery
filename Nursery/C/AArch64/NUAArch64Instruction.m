//
//  NUAArch64Instruction.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64Instruction.h"

@implementation NUAArch64Instruction

+ (instancetype)instruction
{
    return [[self new] autorelease];
}

- (uint32_t)size
{
    return 4;
}

- (void)writeToData:(NSMutableData *)aData
{
}

@end
