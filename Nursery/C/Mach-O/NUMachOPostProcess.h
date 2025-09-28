//
//  NUMachOPostProcess.h
//  Nursery
//
//  Created by akiha on 2025/09/28.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NUMachOTextSection, NUMachODataSection;

@interface NUMachOPostProcess : NSObject

@property (nonatomic) uint64_t instructionOffset;
@property (nonatomic, retain) NUMachOTextSection *textSection;

@property (nonatomic) uint64_t dataOffset;
@property (nonatomic, retain) NUMachODataSection *dataSection;

- (void)execute;

@end

