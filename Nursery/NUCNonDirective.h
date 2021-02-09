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

+ (instancetype)noneDirectiveWithHash:(NUCDecomposedPreprocessingToken *)aHash ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

@end
