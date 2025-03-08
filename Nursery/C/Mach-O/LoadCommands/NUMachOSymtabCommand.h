//
//  NUMachOSymtabCommand.h
//  Nursery
//
//  Created by akiha on 2025/03/07.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUMachOLoadCommand.h"


@interface NUMachOSymtabCommand : NUMachOLoadCommand

@property (nonatomic) struct symtab_command symtabCommand;

@end

