//
//  NUCControlLineDefineFunctionLike.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/11.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCControlLineDefine.h"

@class NSMutableIndexSet;

@interface NUCControlLineDefineFunctionLike : NUCControlLineDefine
{
    NUCDecomposedPreprocessingToken *lparen;
    NUCIdentifierList *identifierList;
    NUCDecomposedPreprocessingToken *ellipsis;
    NUCDecomposedPreprocessingToken *rparen;
    NSMutableArray *parameters;
    NSMutableIndexSet *hashOperatorOperandIndexesInParameters;
}

+ (BOOL)controlLineDefineFunctionLikeFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen into:(NUCPreprocessingDirective **)aToken;

+ (instancetype)defineWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen identifierList:(NUCIdentifierList *)anIdentifierList ellipsis:(NUCDecomposedPreprocessingToken *)anEllipsis rparen:(NUCDecomposedPreprocessingToken *)anRparen replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline;

- (instancetype)initWithHash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aDirectiveName identifier:(NUCDecomposedPreprocessingToken *)anIdentifier lparen:(NUCDecomposedPreprocessingToken *)anLparen identifierList:(NUCIdentifierList *)anIdentifierList ellipsis:(NUCDecomposedPreprocessingToken *)anEllipsis rparen:(NUCDecomposedPreprocessingToken *)anRparen replacementList:(NUCReplacementList *)aReplacementList newline:(NUCNewline *)aNewline;

- (NUCDecomposedPreprocessingToken *)lparen;
- (NUCIdentifierList *)identifierList;
- (NUCDecomposedPreprocessingToken *)ellipsis;
- (NUCDecomposedPreprocessingToken *)rparen;

- (NSMutableArray *)parameters;
- (NSUInteger)parameterCount;
- (BOOL)identifierIsParameter:(NUCIdentifier *)anIdentifier;
- (NSUInteger)parameterIndexOf:(NUCIdentifier *)anIdentifier;
- (BOOL)parameterIsHashOperatorOperandAt:(NSUInteger)anIndex;

@end

