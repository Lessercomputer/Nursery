//
//  NUMachOTextSection.h
//  Nursery
//
//  Created by akiha on 2025/09/28.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOSection.h"

@class NSMutableArray;
@class NUAArch64Instruction;

@interface NUMachOTextSection : NUMachOSection

@property (nonatomic, retain) NSMutableArray *instructions;

- (void)addInstruction:(NUAArch64Instruction *)anInstruction;

@end

