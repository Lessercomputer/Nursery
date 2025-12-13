//
//  NUMachOPostProcess.h
//  Nursery
//
//  Created by akiha on 2025/09/28.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NUMachOTextSection, NUMachODataSection, NUMachO;

@interface NUMachOPostProcess : NSObject

@property (nonatomic, assign) NUMachO *macho;

@property (nonatomic) uint64_t instructionOffsetInSection;
@property (nonatomic, retain) NUMachOTextSection *textSection;

@property (nonatomic) uint64_t dataOffsetInSection;
@property (nonatomic, retain) NUMachODataSection *dataSection;

- (void)execute;

@end

