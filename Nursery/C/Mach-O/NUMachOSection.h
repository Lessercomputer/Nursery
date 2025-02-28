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

@class NUMachOSegment;
@class NSMutableArray;

@interface NUMachOSection : NSObject

+ (instancetype)textSection;

@property (nonatomic, assign) NUMachOSegment *segment;

@property (nonatomic) struct section_64 section;
@property (nonatomic, retain) NSMutableArray *instructions;

@property (nonatomic, retain) NSData *serializedData;

- (void)add:(NUAArch64Instruction *)anInstruction;

@property (nonatomic, readonly) uint32_t size;

@end

