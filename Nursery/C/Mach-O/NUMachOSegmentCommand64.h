//
//  NUMachOSegmentCommand64.h
//  Nursery
//
//  Created by akiha on 2025/02/25.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"

@class NUMachOSection;
@class NSMutableArray;

@interface NUMachOSegmentCommand64 : NUMachOLoadCommand

+ (instancetype)pageZeroSegmentCommand;
+ (instancetype)textSegmentCommand;

@property (nonatomic) struct segment_command_64 segmentCommand64;

@property (nonatomic, retain) NSMutableArray *sections;

- (void)add:(NUMachOSection *)aSection;

@end

