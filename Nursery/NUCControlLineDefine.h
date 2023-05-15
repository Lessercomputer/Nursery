//
//  NUCControlLineDefine.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLine.h"

@class NUCReplacementList, NUCIdentifierList;

@interface NUCControlLineDefine : NUCControlLine
{
    NUCDecomposedPreprocessingToken *identifier;
    NUCReplacementList *replacementList;
}

+ (BOOL)controlLineDefineFrom:(NUCPreprocessingTokenStream *)aPreprocessingTokenStream hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken;

+ (instancetype)defineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline;

- (NUCDecomposedPreprocessingToken *)identifier;
- (NUCReplacementList *)replacementList;

@end

