//
//  NUMachOSegmentCommand64.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"

@class NUMachOSection;
@class NUMachOSegmentData;
@class NUAArch64Instruction;
@class NSMutableArray;

@interface NUMachOSegmentCommand64 : NUMachOLoadCommand

+ (instancetype)pageZeroSegmentCommand;
+ (instancetype)textSegmentCommand;
+ (instancetype)linkeditCommand;

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
@property (nonatomic, retain) NSMutableArray *sections;

@property (nonatomic, retain) NUMachOSegmentData *segmentData;

- (void)add:(NUMachOSection *)aSection;

@end

