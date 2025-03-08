//
//  NUMachODylibCommand.m
//  Nursery
//
//  Created by akiha on 2025/03/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachODylibCommand.h"
#import <Foundation/NSData.h>
#import <string.h>

char LSYSTEM[]  = "/usr/lib/system/libdyld.dylib";

@implementation NUMachODylibCommand

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dylibCommand.cmd = LC_LOAD_DYLIB;
        _dylibCommand.cmdsize = [self roundUpLoadCommandSize:(uint32_t)(sizeof(_dylibCommand) + strlen(LSYSTEM))];
        _dylibCommand.dylib.name.offset = sizeof(_dylibCommand);
    }
    return self;
}

- (uint32_t)size
{
    return _dylibCommand.cmdsize;
}

- (void)writeToData:(NSMutableData *)aData
{
    [aData appendBytes:&_dylibCommand length:sizeof(_dylibCommand)];
    [aData appendBytes:LSYSTEM length:strlen(LSYSTEM)];
    uint64_t aPaddingSize = _dylibCommand.cmdsize - (sizeof(_dylibCommand) + strlen(LSYSTEM));
    [aData increaseLengthBy:aPaddingSize];
}

@end
