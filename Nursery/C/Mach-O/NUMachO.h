//
//  NUMachO.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NUMachOHeader64;
@class NUMachOLoadCommand;
@class NUMachOSegmentData;
@class NSMutableArray;
@class NSData, NSMutableData;
@class NUCIntegerConstant;
@class NUAArch64Instruction;
@class NUMachOSegmentCommand64;
@class NUMachOTextSegmentCommand;
@class NUMachODataSegmentCommand;
@class NUMachOSection;
@class NUMachOTextSection;
@class NUMachODataSection;
@class NUMachOPostProcess;

@interface NUMachO : NSObject

+ (instancetype)exampleReturnZero;

@property (class, nonatomic) uint32_t pageSize;
@property (class, nonatomic, copy) NSString *codesignPath;
@property (nonatomic, readonly) uint32_t pageSize;
@property (nonatomic, retain) NUMachOHeader64 *header;
@property (nonatomic, retain) NSMutableArray *loadCommands;

@property (nonatomic, readonly) uint32_t commandCount;
@property (nonatomic, readonly) uint32_t commandSize;

@property (nonatomic) uint64_t fileSize;

@property (nonatomic, readonly) NUMachOTextSegmentCommand *textSegment;
@property (nonatomic, readonly) NUMachOTextSection *textSection;

@property (nonatomic, readonly) NUMachODataSegmentCommand *dataSegment;
@property (nonatomic, readonly) NUMachODataSection *dataSection;

@property (nonatomic, readonly) uint64_t instructionOffsetInSection;
@property (nonatomic, retain) NSMutableArray *postProcesses;

@property (nonatomic) BOOL needsComputeLayout;

- (uint64_t)roundUpToPageSize:(uint64_t)aSize;
- (uint32_t)headerAndAllLoadCommandsSize;
- (uint32_t)roundUpedHeaderAndAllLoadCommandsSize;

- (void)add:(NUMachOLoadCommand *)aLoadCommand;
- (void)computeLayoutIfNeeded;
- (void)computeLayout;
- (void)writeToData:(NSMutableData *)aData;
- (BOOL)writeToPath:(NSString *)aFilepath;

- (void)addInstruction:(NUAArch64Instruction *)anInstruction;

- (void)addPostProcess:(NUMachOPostProcess *)aPostProcess;
- (void)executePostProcesses;

@end

