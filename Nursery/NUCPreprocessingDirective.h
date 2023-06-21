//
//  NUCPreprocessingDirective.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCPreprocessingTokenStream;

@interface NUCPreprocessingDirective : NUCPreprocessingToken

+ (BOOL)readPpTokensUntilNewlineFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLexicalElement **)aPpTokens;

- (BOOL)isPpTokens;
- (BOOL)isControlLine;

@end
