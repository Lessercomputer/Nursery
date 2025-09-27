//
//  NUMachOSegmentCommand64.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"

@class NUMachOSection;
@class NUMachOTextSection;
@class NUMachOSegmentData;
@class NUAArch64Instruction;
@class NSMutableArray, NSMutableData;

@interface NUMachOSegmentCommand64 : NUMachOLoadCommand
{
    struct segment_command_64 _segmentCommand64;
    NSMutableData *_data;
}

@property (nonatomic, readonly) BOOL isPageZero;
@property (nonatomic, readonly) BOOL isText;
@property (nonatomic, readonly) BOOL isLinkedit;
@property (nonatomic) struct segment_command_64 segmentCommand64;
@property (nonatomic) uint64_t vmaddr;
@property (nonatomic) uint64_t vmsize;
@property (nonatomic) uint64_t fileoff;
@property (nonatomic) uint64_t filesize;
@property (nonatomic) uint64_t paddingSize;
@property (nonatomic, readonly) uint64_t nextVMAddr;
@property (nonatomic, readonly) uint64_t nextFileoff;
@property (nonatomic, readonly) NSMutableData *data;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, readonly) NUMachOTextSection *textSection;
@property (nonatomic, readonly) uint64_t sectionSize;

- (void)add:(NUMachOSection *)aSection;

@end

