//
//  NUMachODyldInfoOnly.h
//  Nursery
//
//  Created by akiha on 2025/03/06.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"


@interface NUMachODyldInfoOnly : NUMachOLoadCommand

@property (nonatomic) struct dyld_info_command dyldInfoCommand;

@end

