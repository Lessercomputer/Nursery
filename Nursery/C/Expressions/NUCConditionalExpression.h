//
//  NUCConditionalExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCProtoExpression.h"

@class NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream, NUCLogicalORExpression, NUCExpression;

@interface NUCConditionalExpression : NUCProtoExpression
{
    NUCLogicalORExpression *logicalORExpression;
    NUCDecomposedPreprocessingToken *questionMarkPunctuator;
    NUCExpression *expression;
    NUCDecomposedPreprocessingToken *colonPunctuator;
    NUCConditionalExpression *conditionalExpression;
}

+ (BOOL)conditionalExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCConditionalExpression **)anExpression;

+ (instancetype)expressionWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression;

+ (instancetype)expressionWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression questionMarkPunctuator:(NUCDecomposedPreprocessingToken *)aQuestionMarkPunctuator expression:(NUCExpression *)anExpression colonPunctuator:(NUCDecomposedPreprocessingToken *)aColonPunctuator conditionalExpression:(NUCConditionalExpression *)aConditionalExpression;

- (instancetype)initWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression questionMarkPunctuator:(NUCDecomposedPreprocessingToken *)aQuestionMarkPunctuator expression:(NUCExpression *)anExpression colonPunctuator:(NUCDecomposedPreprocessingToken *)aColonPunctuator conditionalExpression:(NUCConditionalExpression *)aConditionalExpression;

- (NUCLogicalORExpression *)logicalORExpression;
- (NUCDecomposedPreprocessingToken *)questionMarkPunctuator;
- (NUCExpression *)expression;
- (NUCDecomposedPreprocessingToken *)colonPunctuator;
- (NUCConditionalExpression *)conditionalExpression;

@end

