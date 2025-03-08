//
//  NUMachODylibCommand.h
//  Nursery
//
//  Created by akiha on 2025/03/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"


@interface NUMachODylibCommand : NUMachOLoadCommand

@property (nonatomic) struct dylib_command dylibCommand;

@end

