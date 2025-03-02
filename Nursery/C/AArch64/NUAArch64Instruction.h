//
//  NUAArch64Instruction.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import <Foundation/NSObject.h>

@class NSMutableData;

@interface NUAArch64Instruction : NSObject

+ (instancetype)instruction;

@property (nonatomic, readonly) uint32_t size;

- (void)writeToData:(NSMutableData *)aData;

@end

