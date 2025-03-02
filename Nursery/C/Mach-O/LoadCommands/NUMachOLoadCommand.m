//
//  NUMachOLoadCommand.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"
#import "NUMachOHeader64.h"
#import "NUMachO.h"

@implementation NUMachOLoadCommand

- (uint32_t)size
{
    return 0;
}

- (void)computeLayout
{
}

- (void)computeLoadCommandSize
{
}

- (uint32_t)roundUpLoadCommandSize:(uint32_t)aCommandSize
{
    if (aCommandSize % 8)
        return (aCommandSize / 8 + 1) * 8;
    else
        return aCommandSize;
}

- (uint64_t)roundUpToPageSize:(uint64_t)aSize
{
    uint64_t aPageSize = [[[self header] machO] pageSize];
    
    if (aSize % aPageSize)
        return (aSize / aPageSize + 1) * aPageSize;
    else
        return aSize;
}

- (BOOL)isSegmentCommand
{
    return NO;
}

- (NUMachOSegmentCommand64 *)previousLoadSegmentCommand
{
    if ([[self previous] isSegmentCommand])
        return (NUMachOSegmentCommand64 *)[self previous];
    else
        return [[self previous] previousLoadSegmentCommand];
}

- (void)writeToData:(NSMutableData *)aData
{
}

@end
