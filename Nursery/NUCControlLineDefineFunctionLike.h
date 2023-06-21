//
//  NUCControlLineDefineFunctionLike.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLineDefine.h"


@interface NUCControlLineDefineFunctionLike : NUCControlLineDefine
{
    NUCDecomposedPreprocessingToken *lparen;
    NUCIdentifierList *identifierList;
    NUCDecomposedPreprocessingToken *ellipsis;
    NUCDecomposedPreprocessingToken *rparen;
}

+ (BOOL)controlLineDefineFunctionLikeFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen into:(NUCPreprocessingDirective **)aToken;

+ (instancetype)defineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen identifierList:(NUCIdentifierList *)anIdentifierList ellipsis:(NUCDecomposedPreprocessingToken *)anEllipsis rparen:(NUCDecomposedPreprocessingToken *)anRparen replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen identifierList:(NUCIdentifierList *)anIdentifierList ellipsis:(NUCDecomposedPreprocessingToken *)anEllipsis rparen:(NUCDecomposedPreprocessingToken *)anRparen replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline;

- (NUCDecomposedPreprocessingToken *)lparen;
- (NUCIdentifierList *)identifierList;
- (NUCDecomposedPreprocessingToken *)ellipsis;
- (NUCDecomposedPreprocessingToken *)rparen;

@end

