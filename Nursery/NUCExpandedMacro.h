//
//  NUCExpandedMacro.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCDecomposedPreprocessingToken.h"

@class NUCControlLineDefine;

@interface NUCExpandedMacro : NUCDecomposedPreprocessingToken
{
    NUCControlLineDefine *define;
    NSMutableArray *expandedPpTokens;
}

- (instancetype)initWithDefine:(NUCControlLineDefine *)aDefine;

- (NUCControlLineDefine *)define;
- (void)setDefine:(NUCControlLineDefine *)aDefine;

- (NSMutableArray *)expandedPpTokens;

- (void)add:(NUCDecomposedPreprocessingToken *)aPpToken;

@end

