//
//  NUCControlLineInclude.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/10.
//

#import "NUCControlLine.h"

@class NUCDecomposedPreprocessingToken, NUCPpTokens, NUCNewline;

@interface NUCControlLineInclude : NUCControlLine
{
    NUCPpTokens *ppTokens;
}

+ (BOOL)controlLineIncludeFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken;

+ (instancetype)includeWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

@end

