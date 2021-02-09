//
//  NUCTextLine.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPpTokens, NUCNewline;

@interface NUCTextLine : NUCPreprocessingDirective
{
    NUCPpTokens *ppTokens;
    NUCNewline *newline;
}

+ (instancetype)textLineWithPpTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (instancetype)initWithPpTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

@end

