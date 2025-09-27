//
//  NUMachOTextSection.m
//  Nursery
//
//  Created by akiha on 2025/09/28.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOTextSection.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>

@implementation NUMachOTextSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _instructions = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_instructions release];
    [super dealloc];
}

- (void)addInstruction:(NUAArch64Instruction *)anInstruction
{
    [[self instructions] addObject:anInstruction];
}

- (uint64_t)computeSize
{
    __block uint64_t aSize = 0;
    [[self instructions] enumerateObjectsUsingBlock:^(NUAArch64Instruction * _Nonnull anInstruction, NSUInteger idx, BOOL * _Nonnull stop) {
        aSize += [anInstruction size];
    }];
    return aSize;
}

- (void)writeSectionToData:(NSMutableData *)aData
{
    [aData increaseLengthBy:[self paddingSize]];
    
    [[self instructions] makeObjectsPerformSelector:@selector(writeToData:) withObject:aData];
}

@end
