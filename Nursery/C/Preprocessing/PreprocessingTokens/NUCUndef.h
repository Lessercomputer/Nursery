//
//  NUCUndef.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/11/18.
//

#import "NUCControlLine.h"

@interface NUCUndef : NUCControlLine
{
    NUCPreprocessingToken *identifier;
}

+ (BOOL)undefFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken;

+ (instancetype)undefWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCPreprocessingToken *)anIdentifier newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCPreprocessingToken *)anIdentifier newline:(NUCNewline *)aNewline;

- (NUCPreprocessingToken *)identifier;

@end

