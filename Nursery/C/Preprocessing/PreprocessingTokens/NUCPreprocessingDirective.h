//
//  NUCPreprocessingDirective.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCPreprocessingToken.h"

@class NUCPreprocessingTokenStream;

@interface NUCPreprocessingDirective : NUCPreprocessingToken

+ (BOOL)readPpTokensUntilNewlineFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLexicalElement **)aPpTokens;

- (BOOL)isPpTokens;
- (BOOL)isIfSection;
- (BOOL)isControlLine;
- (BOOL)isTextLine;
- (BOOL)isNonDirective;
- (BOOL)isDefine;

@end
