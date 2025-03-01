//
//  NUMachO.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachO.h"
#import "NUMachOHeader64.h"
#import "NUMachOData.h"
#import "NUMachOSegmentCommand64.h"
#import "NUMachOThreadCommand.h"
#import "NUMachOSection.h"
#import "NUAArch64MovzInstruction.h"
#import "NUAArch64RetInstruction.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSFileManager.h>

#import <mach-o/loader.h>
#import <sys/stat.h>

@implementation NUMachO

- (instancetype)init
{
    self = [super init];
    if (self) {
        _header = [NUMachOHeader64 new];
        [_header setMachO:self];
        _loadCommands = [NSMutableArray new];
        
        [_loadCommands addObject:[NUMachOSegmentCommand64 pageZeroSegmentCommand]];
        
        NUMachOSegmentCommand64 *aCommand = [NUMachOSegmentCommand64 textSegmentCommand];
        NUMachOSection *aSection = [NUMachOSection textSection];
        [aSection add:[NUAArch64MovzInstruction instruction]];
        [aSection add:[NUAArch64RetInstruction instruction]];
        [aCommand add:aSection];
        
        [_loadCommands addObject:aCommand];
        
        [_loadCommands addObject:[NUMachOThreadCommand unixThreadCommand]];
        _data = [NUMachOData new];
    }
    return self;
}

- (void)dealloc
{
    [_header release];
    [_loadCommands release];
    [_data release];
    [super dealloc];
}

- (void)add:(NUMachOLoadCommand *)aLoadCommand
{
    [[self loadCommands] addObject:aLoadCommand];
}

- (uint32_t)commandCount
{
    return (uint32_t)[[self loadCommands] count];
}

- (uint32_t)commandSize
{
    __block uint32_t aSize = 0;
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        aSize += (uint32_t)[aLoadCommand size];
    }];
    return aSize;
}

- (NSData *)serializedBinaryData
{
    NSMutableData *aData = [[[[self header] serializedBinaryData] mutableCopy] autorelease];
    
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        [aData appendData:[aLoadCommand serializedData]];
    }];
    
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([aLoadCommand isKindOfClass:[NUMachOSegmentCommand64 class]])
        {
            [[(NUMachOSegmentCommand64 *)aLoadCommand sections] enumerateObjectsUsingBlock:^(NUMachOSection * _Nonnull aSection, NSUInteger idx, BOOL * _Nonnull stop) {
                [[aSection instructions] enumerateObjectsUsingBlock:^(NUAArch64Instruction * _Nonnull anInstruction, NSUInteger idx, BOOL * _Nonnull stop) {
                    uint32_t aRawInstruction = [anInstruction instruction];
                    [aData appendBytes:&aRawInstruction length:sizeof(uint32_t)];
                }];
            }];
        }
    }];
    
    if ([aData length] < 4096 * 5)
        [aData setLength:4096 * 5];
    return aData;
}

- (BOOL)writeToPath:(NSString *)aFilepath
{
    NSDictionary *aFileAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithShort:ACCESSPERMS] forKey:NSFilePosixPermissions];
    
    return [[NSFileManager defaultManager] createFileAtPath:aFilepath contents:[self serializedBinaryData] attributes:aFileAttributes];
}

@end
