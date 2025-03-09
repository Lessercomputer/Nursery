//
//  NUMachOEntryPointCommand.h
//  Nursery
//
//  Created by akiha on 2025/03/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"


@interface NUMachOEntryPointCommand : NUMachOLoadCommand

@property (nonatomic) struct entry_point_command entoryPointCommand;
@property (nonatomic) uint64_t entryoff;

@end

