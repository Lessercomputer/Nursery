//
//  NUCIfGroup.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/01.
//

#import "NUCPreprocessingDirective.h"

@class NUCDecomposedPreprocessingToken, NUCGroup, NUCPreprocessingTokenStream;

@interface NUCIfGroup : NUCPreprocessingDirective
{
    NUCDecomposedPreprocessingToken *hash;
    NUCDecomposedPreprocessingToken *directiveName;
    NUCLexicalElement *expressionOrIdentifier;
    NUCPreprocessingDirective *newline;
    NUCGroup *group;
}

+ (BOOL)ifGroupFrom:(NUCPreprocessingTokenStream *)aStream with:(NUCPreprocessor *)aPreprocessor isSkipped:(BOOL)aGroupIsSkipped into:(NUCIfGroup **)anIfGroup;

+ (instancetype)ifGroupWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aName expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup;

- (instancetype)initWithType:(NUCLexicalElementType)aType hash:(NUCDecomposedPreprocessingToken *)aHash directiveName:(NUCDecomposedPreprocessingToken *)aName expressionOrIdentifier:(NUCLexicalElement *)anExpressionOrIdentifier newline:(NUCPreprocessingDirective *)aNewline group:(NUCGroup *)aGroup;

- (BOOL)isIf;
- (BOOL)isElif;
- (BOOL)isIfdef;
- (BOOL)isIfndef;

@property (nonatomic, readonly) BOOL isNonzero;
@property (nonatomic) BOOL isSkipped;
@property (nonatomic) NSInteger expressionValue;


- (NUCDecomposedPreprocessingToken *)hash;
- (NUCLexicalElement *)expression;
- (NUCLexicalElement *)identifier;
- (NUCPreprocessingDirective *)newline;
- (NUCGroup *)group;

@end
