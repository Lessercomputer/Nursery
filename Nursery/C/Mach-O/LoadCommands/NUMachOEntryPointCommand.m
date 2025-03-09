//
//  NUMachOEntryPointCommand.m
//  Nursery
//
//  Created by akiha on 2025/03/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOEntryPointCommand.h"
#import <Foundation/NSData.h>

@implementation NUMachOEntryPointCommand

- (instancetype)init
{
    self = [super init];
    if (self) {
        _entoryPointCommand.cmd = LC_MAIN;
        _entoryPointCommand.cmdsize = sizeof(_entoryPointCommand);
        _entoryPointCommand.entryoff = 0;
        _entoryPointCommand.stacksize = 0;
    }
    return self;
}

- (BOOL)isEntryPointCommand
{
    return YES;
}

- (uint64_t)entryoff
{
    return _entoryPointCommand.entryoff;
}

- (void)setEntryoff:(uint64_t)entryoff
{
    _entoryPointCommand.entryoff = entryoff;
}

- (uint32_t)size
{
    return _entoryPointCommand.cmdsize;
}

- (void)writeToData:(NSMutableData *)aData
{
    [aData appendBytes:&_entoryPointCommand length:sizeof(_entoryPointCommand)];
}

@end
