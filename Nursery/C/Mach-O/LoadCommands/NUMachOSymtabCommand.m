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

- (uint32_t)size
{
    return _symtabCommand.cmdsize;
}

- (void)writeToData:(NSMutableData *)aData
{
    [aData appendBytes:&_symtabCommand length:sizeof(_symtabCommand)];
}

@end
