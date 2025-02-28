//
//  NUMachOThreadCommand.h
//  Nursery
//
//  Created by akiha on 2025/02/27.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"
#import <mach/arm/thread_status.h>

@interface NUMachOThreadCommand : NUMachOLoadCommand

+ (instancetype)unixThreadCommand;

@property (nonatomic) struct thread_command threadCommand;
@property (nonatomic) struct arm_unified_thread_state arm_unified_thread_state;

@end

