//
//  NUCNonDirective.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCTextLine.h"

@class NUCDecomposedPreprocessingToken;

@interface NUCNonDirective : NUCTextLine
{
    NUCDecomposedPreprocessingToken *hash;
}

+ (BOOL)hashAndNonDirectiveFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPreprocessingDirective **)aToken;
+ (BOOL)nonDirectiveFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCNonDirective **)aToken hash:(NUCDecomposedPreprocessingToken *)aHash;

+ (instancetype)noneDirectiveWithHash:(NUCDecomposedPreprocessingToken *)aHash ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

@end
