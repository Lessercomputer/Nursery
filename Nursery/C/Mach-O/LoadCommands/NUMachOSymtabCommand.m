//
//  NUMachOSymtabCommand.m
//  Nursery
//
//  Created by akiha on 2025/03/07.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSymtabCommand.h"
#import <Foundation/NSData.h>

@implementation NUMachOSymtabCommand

- (instancetype)init
{
    self = [super init];
    if (self) {
        _symtabCommand.cmd = LC_SYMTAB;
        _symtabCommand.cmdsize = sizeof(_symtabCommand);
    }
    return self;
}

- (uint32_t)symoff
{
    return _symtabCommand.symoff;
}

- (void)setSymoff:(uint32_t)aSymoff
{
    _symtabCommand.symoff = aSymoff;
}

- (uint32_t)stroff
{
    return _symtabCommand.stroff;
}

- (void)setStroff:(uint32_t)aStroff
{
    _symtabCommand.stroff = aStroff;
}

- (BOOL)isSymtabCommand
{
    return YES;
}

- (uint32_t)size
{
    return _symtabCommand.cmdsize;
}

- (void)writeToData:(NSMutableData *)aData
{
    NSLog(@"symtab command offst: %lu", [aData length]);
    [aData appendBytes:&_symtabCommand length:sizeof(_symtabCommand)];
    NSLog(@"symtab command end offst: %lu", [aData length]);
}

@end
