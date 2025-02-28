//
//  NUAArch64MovzInstruction.h
//  Nursery
//
//  Created by akiha on 2025/02/26.
//  Copyright © 2025 com.lily-bud. All rights reserved.
//

#import "NUAArch64MovInstruction.h"



@interface NUAArch64MovzInstruction : NUAArch64MovInstruction

@property (nonatomic) union NUAArch64MovInstruction movInstruction;

@property (nonatomic) NSInteger imm16;
@property (nonatomic) NSInteger rd;

@end

