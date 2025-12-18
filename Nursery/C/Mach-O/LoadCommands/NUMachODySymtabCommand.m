//
//  NUMachODySymtabCommand.m
//  Nursery
//
//  Created by akiha on 2025/03/07.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachODySymtabCommand.h"
#import <Foundation/NSData.h>

@implementation NUMachODySymtabCommand

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dysymtabCommand.cmd = LC_DYSYMTAB;
        _dysymtabCommand.cmdsize = sizeof(_dysymtabCommand);
    }
    return self;
}

- (uint32_t)size
{
    return  _dysymtabCommand.cmdsize;
}

- (void)writeToData:(NSMutableData *)aData
{
    NSLog(@"dy symtab command offst: %lu", [aData length]);
    [aData appendBytes:&_dysymtabCommand length:sizeof(_dysymtabCommand)];
    NSLog(@"symtab command end offst: %lu", [aData length]);
}

@end
