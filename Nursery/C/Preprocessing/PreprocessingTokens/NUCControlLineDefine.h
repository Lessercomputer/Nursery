//
//  NUCControlLineDefine.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//

#import "NUCControlLine.h"

@class NUCIdentifier, NUCReplacementList, NUCIdentifierList;

@interface NUCControlLineDefine : NUCControlLine
{
    NUCIdentifier *identifier;
    NUCReplacementList *replacementList;
}

+ (BOOL)controlLineDefineFrom:(NUCPreprocessingTokenStream  *)aPreprocessingTokenStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName into:(NUCPreprocessingDirective **)aToken;

+ (instancetype)defineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCIdentifier *)anIdentifier replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCIdentifier *)anIdentifier replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline;

- (NUCIdentifier *)identifier;
- (NUCReplacementList *)replacementList;

- (BOOL)isObjectLike;
- (BOOL)isFunctionLike;

@end

