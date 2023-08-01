//
//  NUCControlLine.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/07.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingDirective.h"

@class NUCPreprocessingTokenStream, NUCDecomposedPreprocessingToken, NUCNewline, NUCLine;

@interface NUCControlLine : NUCPreprocessingDirective
{
    NUCDecomposedPreprocessingToken *hash;
    NUCDecomposedPreprocessingToken *directiveName;
    NUCNewline *newline;
}

+ (BOOL)controlLineFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCPreprocessingDirective **)aToken;

+ (BOOL)controlLineLineFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCLine **)aToken;

+ (BOOL)controlLineNewlineFrom:(NUCPreprocessingTokenStream *)aStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCControlLine **)aToken;

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName newline:(NUCNewline *)aNewline;

- (NUCDecomposedPreprocessingToken *)hash;
- (NUCDecomposedPreprocessingToken *)directiveName;
- (NUCNewline *)newline;

- (void)preprocessWith:(NUCPreprocessor *)aPreprocessor;

@end

