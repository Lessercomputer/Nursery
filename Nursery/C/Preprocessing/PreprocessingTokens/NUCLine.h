//
//  NUCLine.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2022/03/28.
//

#import "NUCControlLine.h"

@class NUCPpTokens;

@interface NUCLine : NUCControlLine
{
    NUCPpTokens *ppTokens;
}

+ (instancetype)lineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName ppTokens:(NUCPpTokens *)aPpTokens newline:(NUCNewline *)aNewline;

- (NUCPpTokens *)ppTokens;

@end

