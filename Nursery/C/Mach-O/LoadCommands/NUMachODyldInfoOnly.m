//
//  NUMachODyldInfoOnly.m
//  Nursery
//
//  Created by akiha on 2025/03/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachODyldInfoOnly.h"
#import <Foundation/NSData.h>

@implementation NUMachODyldInfoOnly

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dyldInfoCommand.cmd = LC_DYLD_INFO_ONLY;
        _dyldInfoCommand.cmdsize = sizeof(_dyldInfoCommand);
    }
    return self;
}

- (uint32_t)size
{
    return _dyldInfoCommand.cmdsize;
}

- (void)writeToData:(NSMutableData *)aData
{
    [aData appendBytes:&_dyldInfoCommand length:sizeof(_dyldInfoCommand)];
}

@end
