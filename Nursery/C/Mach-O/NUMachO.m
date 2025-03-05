//
//  NUMachO.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachO.h"
#import "NUMachOHeader64.h"
#import "NUMachOSegmentData.h"
#import "NUMachOSegmentCommand64.h"
#import "NUMachOThreadCommand.h"
#import "NUMachOSection.h"
#import "NUMachOSectionData.h"
#import "NUAArch64MovzInstruction.h"
#import "NUAArch64RetInstruction.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSFileManager.h>

#import <mach-o/loader.h>
#import <sys/stat.h>

@implementation NUMachO

+ (uint32_t)pageSize
{
    return 4096 * 4;
}

+ (instancetype)exampleReturnZero
{
    NUMachO *aMachO = [[self new] autorelease];
    
    [aMachO add:[NUMachOSegmentCommand64 pageZeroSegmentCommand]];
    
    NUMachOSegmentCommand64 *aLoadCommand = [NUMachOSegmentCommand64 textSegmentCommand];
    [aMachO add:aLoadCommand];
    NUMachOSection *aSection = [NUMachOSection textSection];
    [aLoadCommand add:aSection];
    [[aSection sectionData] addInstruction:[NUAArch64MovzInstruction instruction]];
    [[aSection sectionData] addInstruction:[NUAArch64RetInstruction instruction]];
    
    [aMachO add:[NUMachOThreadCommand unixThreadCommand]];
    
    return aMachO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _header = [NUMachOHeader64 new];
        [_header setMachO:self];
        _loadCommands = [NSMutableArray new];
        _segmentData = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [_header release];
    [_loadCommands release];
    [_segmentData release];
    [super dealloc];
}

- (uint32_t)pageSize
{
    return [[self class] pageSize];
}

- (uint64_t)roundUpToPageSize:(uint64_t)aSize
{
    uint64_t aPageSize = [self pageSize];
    
    if (aSize % aPageSize)
        return (aSize / aPageSize + 1) * aPageSize;
    else
        return aSize;
}

- (void)add:(NUMachOLoadCommand *)aLoadCommand
{
    [aLoadCommand setHeader:[self header]];
    [aLoadCommand setPrevious:[[self loadCommands] lastObject]];
    [[self loadCommands] addObject:aLoadCommand];
    
    if ([aLoadCommand isSegmentCommand])
        [[self segmentData] addObject:[(NUMachOSegmentCommand64 *)aLoadCommand segmentData]];
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

- (void)computeLayout
{
//    [[self loadCommands] makeObjectsPerformSelector:@selector(computeLayout)];
    
    [[self loadCommands] makeObjectsPerformSelector:@selector(computeLoadCommandSize)];
    [[self header] updateHeaderInfo];
    uint32_t aHeaderAndLoadCommandsSize = [self headerAndAllLoadCommandsSize];
    uint64_t aRoundedHeaderAndLoadCommandsSize = [self roundUpToPageSize:aHeaderAndLoadCommandsSize];
    uint64_t aRemainingSegmentSize = aRoundedHeaderAndLoadCommandsSize - aHeaderAndLoadCommandsSize;
    [self setFileSize:aRoundedHeaderAndLoadCommandsSize];
    
    __block NUMachOSegmentCommand64 *aPreceedingSegmentCommand = nil;
    
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([aLoadCommand isSegmentCommand])
        {
            NUMachOSegmentCommand64 *aSegmentCommand = (NUMachOSegmentCommand64 *)aLoadCommand;
            if (![aSegmentCommand isPageZero])
            {
                if (aPreceedingSegmentCommand)
                {
                    [aSegmentCommand setVmaddr:[aPreceedingSegmentCommand vmaddr] + [aPreceedingSegmentCommand vmsize]];
                    [aSegmentCommand setVmsize:aRoundedHeaderAndLoadCommandsSize];
                    [aSegmentCommand setFileoff:0];
                    [aSegmentCommand setFilesize:aRoundedHeaderAndLoadCommandsSize];
                    
                    [[aSegmentCommand sections] enumerateObjectsUsingBlock:^(NUMachOSection * _Nonnull aSection, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == 0)
                        {
                            uint64_t aPaddingSize = aRemainingSegmentSize - [[aSection sectionData] size];
                            [[aSection sectionData] setPaddingSize:aPaddingSize];
                            [aSection setOffset:aHeaderAndLoadCommandsSize + (uint32_t)aPaddingSize];
                        }
                        else
                            [aSection setOffset:aHeaderAndLoadCommandsSize];
                        
                        [aSection setAddress:aHeaderAndLoadCommandsSize + [aPreceedingSegmentCommand vmsize] + [aSegmentCommand vmsize]];
                        [aSection setSize:[[aSection sectionData] size]];
                    }];
                }
            }
            else
            {
                aPreceedingSegmentCommand = aSegmentCommand;
            }
        }
    }];
    
    
}

- (uint32_t)totalLoadCommandsSize
{
    __block uint32_t aSize = 0;
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        aSize += [aLoadCommand size];
    }];
    return aSize;
}

- (uint32_t)headerAndAllLoadCommandsSize
{
    return [[self header] size] + [self totalLoadCommandsSize];
}

- (void)writeToData:(NSMutableData *)aData
{
    [self computeLayout];
    
    [[self header] writeToData:aData];
    [[self loadCommands] makeObjectsPerformSelector:@selector(writeToData:) withObject:aData];
//    uint32_t aHeaderAndLoadCommandsSize = [self headerAndAllLoadCommandsSize];
//    uint32_t aRoundedHeaderAndLoadCommandsSize = (uint32_t)[self roundUpToPageSize:aHeaderAndLoadCommandsSize];
//    uint32_t aPaddingSize = aRoundedHeaderAndLoadCommandsSize - aHeaderAndLoadCommandsSize;
//    
//    NSMutableData *aPaddingData = [NSMutableData data];//[NSMutableData dataWithLength:aPaddingSize];
//    uint32_t aNumber = 1;
//    while ([aPaddingData length] < aPaddingSize) {
//        [aPaddingData appendBytes:&aNumber length:sizeof(aNumber)];
//        aNumber++;
//    }
//    [aPaddingData setLength:aPaddingSize];
//    [aPaddingData writeToFile:[@"~/Desktop/pad" stringByExpandingTildeInPath] atomically:YES];
//    
//    [aData appendData:aPaddingData];
    
    [[self segmentData] makeObjectsPerformSelector:@selector(writeToData:) withObject:aData];
    
    if ([aData length] < [self fileSize])
        [aData setLength:[self fileSize]];
}

- (BOOL)writeToPath:(NSString *)aFilepath
{
    NSDictionary *aFileAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithShort:ACCESSPERMS] forKey:NSFilePosixPermissions];
    NSMutableData *aData = [NSMutableData data];
    [self writeToData:aData];
    
    return [[NSFileManager defaultManager] createFileAtPath:aFilepath contents:aData attributes:aFileAttributes];
}

@end
