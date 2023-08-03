//
//  NUCSubstitutedStringLiteral.h
//  Nursery
//
//  Created by aki on 2023/07/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NSMutableArray;

@interface NUCSubstitutedStringLiteral : NUCPreprocessingToken
{
    NSMutableArray *ppTokens;
    NSString *string;
}

+ (instancetype)substitutedStringLiteralWithPpTokens:(NSMutableArray *)aPpTokens;

- (instancetype)initWithPpTokens:(NSMutableArray *)aPpTokens;

- (NSMutableArray *)ppTokens;

- (NSString *)string;

@end

