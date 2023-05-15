//
//  NUCPragma.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2022/03/29.
//  Copyright © 2022 Nursery-Framework. All rights reserved.
//

#import "NUCControlLine.h"

@class NUCPpTokens;

@interface NUCPragma : NUCControlLine
{
    NUCPpTokens *ppTokens;
}

+ (BOOL)pragmaFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCControlLine **)aToken;

+ (instancetype)pragmaWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (NUCPpTokens *)ppTokens;

@end

