//
//  NUAArch64Instruction.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64Instruction.h"
#import <Foundation/NSData.h>

@implementation NUAArch64Instruction

+ (uint64_t)pageSize
{
    return 4096;
}

+ (uint64_t)pageOf:(uint64_t)anAddress offset:(uint64_t *)anOffset
{
    uint64_t aPage = anAddress / [self pageSize];
    if (anOffset)
        *anOffset = anAddress % [self pageSize];
    return aPage;
}

+ (instancetype)instruction
{
    return [[self new] autorelease];
}

- (uint32_t)size
{
    return 4;
}

- (BOOL)isPlaceholder
{
    return NO;
}

- (void)writeToData:(NSMutableData *)aData
{
    uint32_t anInstruction = [self instruction];
    [aData appendBytes:&anInstruction length:[self size]];
}

@end
