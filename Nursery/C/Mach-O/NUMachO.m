//
//  NUMachO.m
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachO.h"
#import "NUMachOHeader64.h"
#import "NUMachOSegmentCommand64.h"
#import "NUMachOPageZeroSegmentCommand.h"
#import "NUMachOTextSegmentCommand.h"
#import "NUMachODataSegmentCommand.h"
#import "NUMachOLinkeditCommand.h"
#import "NUMachOThreadCommand.h"
#import "NUMachOSection.h"
#import "NUMachOTextSection.h"
#import "NUAArch64MovzInstruction.h"
#import "NUAArch64RetInstruction.h"
#import "NUMachOEntryPointCommand.h"
#import "NUMachODylinkerCommand.h"
#import "NUMachODyldInfoOnly.h"
#import "NUMachOSymtabCommand.h"
#import "NUMachODySymtabCommand.h"
#import "NUMachODylibCommand.h"
#import "NUMachOPostProcess.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSTask.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSString.h>

#import <mach-o/loader.h>
#import <sys/stat.h>

static NSString *codeSignPath = @"/usr/bin/codesign";
static uint32_t pageSize = 4096 * 4;

@implementation NUMachO

+ (NSString *)codesignPath
{
    return codeSignPath;
}

+ (void)setCodesignPath:(NSString *)aCodesignPath
{
    codeSignPath = [aCodesignPath copy];
}

+ (uint32_t)pageSize
{
    return pageSize;
}

+ (void)setPageSize:(uint32_t)aPageSize
{
    pageSize = aPageSize;
}

+ (instancetype)exampleReturnZero
{
    NUMachO *aMachO = [[self new] autorelease];
    
    [aMachO add:[NUMachOPageZeroSegmentCommand loadCommand]];
    
    NUMachOSegmentCommand64 *aLoadCommand = [NUMachOTextSegmentCommand loadCommand];
    [aMachO add:aLoadCommand];
    NUMachOTextSection *aSection = [NUMachOTextSection section];
    [aLoadCommand add:aSection];
    [aSection addInstruction:[NUAArch64MovzInstruction instruction]];
    [aSection addInstruction:[NUAArch64RetInstruction instruction]];
    
    [aMachO add:[NUMachOLinkeditCommand loadCommand]];
    [aMachO add:[NUMachOSymtabCommand loadCommand]];
    [aMachO add:[NUMachODySymtabCommand loadCommand]];
    [aMachO add:[NUMachODylinkerCommand loadCommand]];
    [aMachO add:[NUMachODyldInfoOnly loadCommand]];
    [aMachO add:[NUMachODylibCommand loadCommand]];
    [aMachO add:[NUMachOEntryPointCommand loadCommand]];

    return aMachO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _header = [NUMachOHeader64 new];
        [_header setMachO:self];
        _loadCommands = [NSMutableArray new];
        _postProcesses = [NSMutableArray new];
        _needsComputeLayout = YES;
    }
    return self;
}

- (void)dealloc
{
    [_header release];
    [_loadCommands release];
    [_postProcesses release];
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

- (void)computeLayoutIfNeeded
{
    if ([self needsComputeLayout])
    {
        [self computeLayout];
        [self setNeedsComputeLayout:NO];
    }
}
- (void)computeLayout
{
    [[self loadCommands] makeObjectsPerformSelector:@selector(computeLoadCommandSize)];
    [[self loadCommands] makeObjectsPerformSelector:@selector(computeLayout)];
    [self updateLoadCommands];
    [[self header] updateHeader];
}

- (void)updateLoadCommands
{
    NUMachOSegmentCommand64 *aTextSegment = [self textSegment];
    NUMachOSection *aTextSection = [[aTextSegment sections] firstObject];
    NUMachOEntryPointCommand *anEntryPointCommand = [self entryPointCommand];
    [anEntryPointCommand setEntryoff:[aTextSection offset]];
    
//    NUMachOSegmentCommand64 *aLinkeditCommand = [self linkeditSegment];
//    [aLinkeditCommand setFileoff:[aTextSegment nextFileoff]];
//    NUMachOSymtabCommand *aSymtabCommand = [self symtabCommand];
//    [aSymtabCommand setSymoff:(uint32_t)[aLinkeditCommand nextFileoff]];
//    [aSymtabCommand setStroff:[aSymtabCommand symoff]];
}

- (NUMachOSegmentCommand64 *)textSegment
{
    __block NUMachOSegmentCommand64 *aSegmentCommand = nil;
    
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([aLoadCommand isSegmentCommand])
        {
            if ([(NUMachOSegmentCommand64 *)aLoadCommand isText])
                aSegmentCommand = (NUMachOSegmentCommand64 *)aLoadCommand;
        }
    }];
    
    return aSegmentCommand;
}

- (NUMachOTextSection *)textSection
{
    return [[self textSegment] textSection];
}

- (NUMachODataSegmentCommand *)dataSegment
{
    __block NUMachODataSegmentCommand *aSegmentCommand = nil;
    
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([aLoadCommand isSegmentCommand])
        {
            if ([(NUMachOSegmentCommand64 *)aLoadCommand isData])
                aSegmentCommand = (NUMachODataSegmentCommand *)aLoadCommand;
        }
    }];
    
    return aSegmentCommand;
}
- (NUMachODataSection *)dataSection
{
    return [[self dataSegment] dataSection];
}

- (uint64_t)instructionOffsetInSection
{
    return [[self textSection] instructionOffsetInSection];
}

- (NUMachOEntryPointCommand *)entryPointCommand
{
    __block NUMachOEntryPointCommand *anEntryPointCommand = nil;
    
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([aLoadCommand isEntryPointCommand])
        {
            anEntryPointCommand = (NUMachOEntryPointCommand *)aLoadCommand;
        }
    }];
    
    return anEntryPointCommand;
}

- (NUMachOSegmentCommand64 *)linkeditSegment
{
    __block NUMachOSegmentCommand64 *aSegmentCommand = nil;
    
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([aLoadCommand isSegmentCommand])
        {
            if ([(NUMachOSegmentCommand64 *)aLoadCommand isLinkedit])
                aSegmentCommand = (NUMachOSegmentCommand64 *)aLoadCommand;
        }
    }];
    
    return aSegmentCommand;
}

- (NUMachOSymtabCommand *)symtabCommand
{
    __block NUMachOSymtabCommand *aSymtabCommand = nil;
    
    [[self loadCommands] enumerateObjectsUsingBlock:^(NUMachOLoadCommand * _Nonnull aLoadCommand, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([aLoadCommand isSymtabCommand])
        {
            aSymtabCommand = (NUMachOSymtabCommand *)aLoadCommand;
        }
    }];
    
    return aSymtabCommand;
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

- (void)addInstruction:(NUAArch64Instruction *)anInstruction
{
    [[self textSection] addInstruction:anInstruction];
}

- (void)addPostProcess:(NUMachOPostProcess *)aPostProcess
{
    [[self postProcesses] addObject:aPostProcess];
}

- (void)executePostProcesses
{
    [[self postProcesses] makeObjectsPerformSelector:@selector(execute)];
}

- (void)writeToData:(NSMutableData *)aData
{
    [self computeLayoutIfNeeded];
    [self executePostProcesses];

    [[self header] writeToData:aData];
    [[self loadCommands] makeObjectsPerformSelector:@selector(writeToData:) withObject:aData];
    [[self loadCommands] makeObjectsPerformSelector:@selector(writeSegmentDataToData:) withObject:aData];
}

- (BOOL)writeToPath:(NSString *)aFilepath
{
    NSDictionary *aFileAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithShort:ACCESSPERMS] forKey:NSFilePosixPermissions];
    NSMutableData *aData = [NSMutableData data];
    [self writeToData:aData];
    
    if ([[NSFileManager defaultManager] createFileAtPath:aFilepath contents:aData attributes:aFileAttributes])
    {
        NSTask *aCodesignTask = [[NSTask new] autorelease];
        [aCodesignTask setExecutableURL:[NSURL fileURLWithPath:[[self class] codesignPath]]];
        [aCodesignTask setArguments:@[@"--force", @"-s", @"-", aFilepath]];
        [aCodesignTask launch];
        [aCodesignTask waitUntilExit];
        return ![aCodesignTask terminationStatus];
    }
    else
        return NO;
}

@end
