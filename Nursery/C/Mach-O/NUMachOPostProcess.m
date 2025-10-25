//
//  NUMachOPostProcess.m
//  Nursery
//
//  Created by akiha on 2025/09/28.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOPostProcess.h"
#import "NUMachOTextSection.h"

@implementation NUMachOPostProcess

- (void)execute
{
    uint64_t aDataOffset;
    uint64_t aDataPage = [NUAArch64Instruction pageOf:[[self dataSection] addr] + [self dataOffset] offset:&aDataOffset];
    
}

@end
