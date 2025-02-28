//
//  NUMachOThreadCommand.m
//  Nursery
//
//  Created by akiha on 2025/02/27.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOThreadCommand.h"
#import <Foundation/NSData.h>

@implementation NUMachOThreadCommand

+ (instancetype)unixThreadCommand
{
    return [[[self alloc] init] autorelease];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _threadCommand.cmd = LC_UNIXTHREAD;
        _threadCommand.cmdsize = sizeof(struct thread_command) + sizeof(arm_state_hdr_t) + sizeof(arm_thread_state64_t);
        _arm_unified_thread_state.ash.flavor = ARM_THREAD_STATE64;
        _arm_unified_thread_state.ash.count = ARM_THREAD_STATE64_COUNT;
    }
    return self;
}

- (uint32_t)size
{
    return _threadCommand.cmdsize;
}

- (NSData *)serializedData
{
    NSMutableData *aData = [NSMutableData dataWithLength:sizeof(struct thread_command) + sizeof(struct arm_unified_thread_state)];
    struct thread_command *aThreadCommand = [aData mutableBytes];
    aThreadCommand->cmd = _threadCommand.cmd;
    aThreadCommand->cmdsize = _threadCommand.cmdsize;
    struct arm_unified_thread_state *anArmUnifieldThreadState = (struct arm_unified_thread_state *)((char *)aThreadCommand + sizeof(struct thread_command));
    anArmUnifieldThreadState->ash = _arm_unified_thread_state.ash;
    anArmUnifieldThreadState->uts = _arm_unified_thread_state.uts;
    return aData;
}

@end
