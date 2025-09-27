//
//  NUMachOSectionData.m
//  Nursery
//
//  Created by akiha on 2025/03/02.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSectionData.h"
#import "NUMachOSegmentData.h"
#import "NUMachOSection.h"
#import "NUAArch64Instruction.h"
#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>

@implementation NUMachOSectionData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _instructions = [NSMutableArray new];
        _data = [NSMutableData new];
    }
    return self;
}

- (void)dealloc
{
    [_instructions release];
    [_data release];
    [super dealloc];
}

- (void)addInstruction:(NUAArch64Instruction *)anInstruction
{
    [[self instructions] addObject:anInstruction];
}

- (uint64_t)addUInt64:(uint64_t)aValue
{
    uint64_t anIndex = [[self data] length];
    [[self data] appendBytes:&aValue length:sizeof(aValue)];
    return anIndex;
}

- (uint64_t)addInt64:(int64_t)aValue
{
    uint64_t anIndex = [[self data] length];
    [[self data] appendBytes:&aValue length:sizeof(aValue)];
    return anIndex;
}

- (uint64_t)size
{
    __block uint64_t aSize = 0;
    [[self instructions] enumerateObjectsUsingBlock:^(NUAArch64Instruction * _Nonnull anInstruction, NSUInteger idx, BOOL * _Nonnull stop) {
        aSize += [anInstruction size];
    }];
    return aSize;
}

- (uint64_t)paddingSize
{
    return [[self section] paddingSize];
}

- (void)writeToData:(NSMutableData *)aData
{
    [aData increaseLengthBy:[self paddingSize]];
    
    [[self instructions] makeObjectsPerformSelector:@selector(writeToData:) withObject:aData];
}

@end
