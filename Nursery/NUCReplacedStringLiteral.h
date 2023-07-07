//
//  NUCReplacedStringLiteral.h
//  Nursery
//
//  Created by aki on 2023/07/07.
//  Copyright © 2023 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NSMutableArray;

@interface NUCReplacedStringLiteral : NUCPreprocessingToken
{
    NSMutableArray *ppTokens;
}

+ (instancetype)replacedStringLiteral;
+ (instancetype)replacedStringLiteralWithPpTokens:(NSMutableArray *)aPpTokens;

- (instancetype)initWithPpTokens:(NSMutableArray *)aPpTokens;

-(NSMutableArray *)ppTokens;

@end

