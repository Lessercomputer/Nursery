//
//  NUCEndifLine.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCPreprocessingDirective.h"

@class NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream, NUCNewline;

@interface NUCEndifLine : NUCPreprocessingDirective
{
    NUCDecomposedPreprocessingToken *hash;
    NUCDecomposedPreprocessingToken *endif;
    NUCNewline *newline;
}

+ (BOOL)endifLineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream into:(NUCPreprocessingDirective **)anEndifLine;

+ (instancetype)endifLineWithHash:(NUCDecomposedPreprocessingToken *)aHash endif:(NUCDecomposedPreprocessingToken *)anEndif newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash endif:(NUCDecomposedPreprocessingToken *)anEndif newline:(NUCNewline *)aNewline;

- (NUCDecomposedPreprocessingToken *)hash;
- (NUCDecomposedPreprocessingToken *)endif;
- (NUCNewline *)newline;

@end

