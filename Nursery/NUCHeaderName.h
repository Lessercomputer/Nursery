//
//  NUCHeaderName.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCDecomposedPreprocessingToken.h"

@interface NUCHeaderName : NUCDecomposedPreprocessingToken
{
    BOOL isHChar;
}

+ (instancetype)preprocessingTokenWithRange:(NSRange)aRange isHChar:(BOOL)anIsHChar;

+ (instancetype)preprocessingTokenWithContentFromString:(NSString *)aString range:(NSRange)aRange isHChar:(BOOL)anIsHChar;

+ (instancetype)preprocessingTokenWithContent:(NSString *)aContent range:(NSRange)aRange isHChar:(BOOL)anIsHChar;

- (instancetype)initWithRange:(NSRange)aRange isHChar:(BOOL)anIsHChar;

- (instancetype)initWithContent:(NSString *)aContent range:(NSRange)aRange isHChar:(BOOL)anIsHChar;

- (BOOL)isHChar;
- (BOOL)isQChar;

@end
