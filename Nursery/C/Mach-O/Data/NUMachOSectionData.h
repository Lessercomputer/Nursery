//
//  NUMachOSectionData.h
//  Nursery
//
//  Created by akiha on 2025/03/02.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NUMachOSegmentData;
@class NUMachOSection;
@class NUAArch64Instruction;
@class NSMutableArray;
@class NSMutableData;

@interface NUMachOSectionData : NSObject

@property (nonatomic, assign) NUMachOSegmentData *segmentData;
@property (nonatomic, assign) NUMachOSection *section;
@property (nonatomic, retain) NSMutableArray *instructions;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, readonly) uint64_t paddingSize;
@property (nonatomic, readonly) uint64_t size;

- (void)addInstruction:(NUAArch64Instruction *)anInstruction;
- (uint64_t)addUInt64:(uint64_t)aValue;
- (uint64_t)addInt64:(int64_t)aValue;
- (void)writeToData:(NSMutableData *)aData;

@end

