//
//  NUCPpTokensWithMacroInvocations.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2023/06/14.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"


@interface NUCPpTokensWithMacroInvocations : NUCPreprocessingDirective
{
    NSMutableArray *ppTokens;
}

+ (instancetype)ppTokens;

- (NSMutableArray *)ppTokens;

- (void)add:(NUCPreprocessingToken *)aPpToken;

@end

