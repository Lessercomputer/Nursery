//
//  NUMachODylinkerCommand.m
//  Nursery
//
//  Created by akiha on 2025/03/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachODylinkerCommand.h"
#import <Foundation/NSData.h>
#import "string.h"

char DylinkerPath[] = "/usr/lib/dyld";

@implementation NUMachODylinkerCommand

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dyLinkerCommand.cmd = LC_LOAD_DYLINKER;
        _dyLinkerCommand.name.offset = sizeof(_dyLinkerCommand);
        _dyLinkerCommand.cmdsize = [self roundUpLoadCommandSize:(uint32_t)(sizeof(_dyLinkerCommand) + strlen(DylinkerPath))];
    }
    return self;
}

- (uint32_t)size
{
    return _dyLinkerCommand.cmdsize;
}

- (void)writeToData:(NSMutableData *)aData
{
    [aData appendBytes:&_dyLinkerCommand length:sizeof(_dyLinkerCommand)];
    [aData appendBytes:DylinkerPath length:strlen(DylinkerPath)];
    NSUInteger aPaddingSize = _dyLinkerCommand.cmdsize - (sizeof(_dyLinkerCommand) + strlen(DylinkerPath));
    [aData increaseLengthBy:aPaddingSize];
}

@end
