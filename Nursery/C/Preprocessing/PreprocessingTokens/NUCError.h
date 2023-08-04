//
//  NUCError.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2022/03/28.
//

#import "NUCControlLine.h"

@class NUCPpTokens;

@interface NUCError : NUCControlLine
{
    NUCPpTokens *ppTokens;
}

+ (BOOL)errorFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCControlLine **)aToken;

+ (instancetype)errorWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (NUCPpTokens *)ppTokens;

@end

