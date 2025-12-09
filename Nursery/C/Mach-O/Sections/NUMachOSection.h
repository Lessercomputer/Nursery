//
//  NUMachOSection.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>
#import "NUAArch64Instruction.h"

#import <mach-o/loader.h>

@class NUMachOSegmentCommand64;
@class NSMutableData;

@interface NUMachOSection : NSObject
{
    struct section_64 _section;
}

+ (instancetype)section;

@property (nonatomic, assign) NUMachOSegmentCommand64 *segmentCommand;
@property (nonatomic, assign) NUMachOSection *previous;
@property (nonatomic, readonly) BOOL isText;
@property (nonatomic, readonly) BOOL isData;

@property (nonatomic) uint64_t leadingPaddingSize;
@property (nonatomic) struct section_64 section;
@property (nonatomic) uint64_t addr;
@property (nonatomic) uint64_t size;
@property (nonatomic) uint32_t offset;
@property (nonatomic, readonly) uint32_t nextOffset;

@property (nonatomic, retain) NSMutableData *data;

- (uint64_t)computeSize;
- (uint64_t)updateSize;

- (void)writeToData:(NSMutableData *)aData;
- (void)writeSectionDataToData:(NSMutableData *)aData;

@end

