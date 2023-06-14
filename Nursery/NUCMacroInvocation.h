//
//  NUCMacroInvocation.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCControlLineDefine;

@interface NUCMacroInvocation : NUCPreprocessingToken
{
    NUCControlLineDefine *define;
    NSMutableArray *arguments;
}

+ (instancetype)macroInvocationWithDefine:(NUCControlLineDefine *)aDefine;

- (instancetype)initWithDefine:(NUCControlLineDefine *)aDefine;

- (void)setDefine:(NUCControlLineDefine *)aDefine;

- (NSMutableArray *)arguments;

- (void)addArgument:(NUCPreprocessingToken *)anArgument;

@end

