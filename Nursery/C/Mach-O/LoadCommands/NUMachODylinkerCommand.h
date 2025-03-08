//
//  NUMachODylinkerCommand.h
//  Nursery
//
//  Created by akiha on 2025/03/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"


@interface NUMachODylinkerCommand : NUMachOLoadCommand

@property (nonatomic) struct dylinker_command dyLinkerCommand;

@end

