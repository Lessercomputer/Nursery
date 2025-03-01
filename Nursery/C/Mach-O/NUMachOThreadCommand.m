//
//  NUMachOThreadCommand.m
//  Nursery
//
//  Created by akiha on 2025/02/27.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOThreadCommand.h"
#import <Foundation/NSData.h>
//#import <mach/arm/_structs.h>

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
        _threadCommand.cmdsize = sizeof(struct arm_unified_thread_state);
        _arm_unified_thread_state.ash.flavor = ARM_THREAD_STATE64;
        _arm_unified_thread_state.ash.count = ARM_THREAD_STATE64_COUNT;
        uint64_t *aRegisterPointer = (uint64_t *)&(_arm_unified_thread_state.uts);
        aRegisterPointer[32] = 4294967296;//4294967296;//544;
//        _arm_unified_thread_state.uts = 544;
//        __darwin_arm_thread_state64_set_pc(
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
