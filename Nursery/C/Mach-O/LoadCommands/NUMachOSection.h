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
@class NUMachOSegmentData;
@class NUMachOSectionData;
@class NSMutableData;

@interface NUMachOSection : NSObject

+ (instancetype)textSection;

@property (nonatomic, assign) NUMachOSegmentCommand64 *segmentCommand;
@property (nonatomic, readonly) NUMachOSegmentData *segmentData;
@property (nonatomic, assign) NUMachOSection *previous;
@property (nonatomic, readonly) BOOL isText;

@property (nonatomic) uint64_t paddingSize;
@property (nonatomic) struct section_64 section;
@property (nonatomic) uint64_t addr;
@property (nonatomic) uint64_t size;
@property (nonatomic) uint32_t offset;

@property (nonatomic, retain) NUMachOSectionData *sectionData;

- (void)writeToData:(NSMutableData *)aData;

@end

