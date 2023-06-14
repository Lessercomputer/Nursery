//
//  NUCTextLine.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/09.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPpTokens, NUCNewline, NUCPreprocessingTokenStream;

@interface NUCTextLine : NUCPreprocessingDirective
{
    NUCPpTokens *ppTokens;
    NUCNewline *newline;
    NUCPreprocessingToken *ppTokensWithMacroInvocations;
}

+ (BOOL)textLineFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPreprocessingDirective **)aToken;

+ (instancetype)textLineWithPpTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (instancetype)initWithPpTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (NUCPpTokens *)ppTokens;

- (NUCPreprocessingToken *)ppTokensWithMacroInvocations;
- (void)setPpTokensWithMacroInvocations:(NUCPreprocessingToken *)aMacroExpandedPpTokens;

@end

