//
//  NUCConditionalExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCProtoExpression.h"

@class NUCDecomposedPreprocessingToken, NUCTokenStream, NUCLogicalORExpression, NUCExpression;

@interface NUCConditionalExpression : NUCProtoExpression
{
    NUCLogicalORExpression *logicalORExpression;
    id <NUCToken> questionMarkPunctuator;
    NUCExpression *expression;
    id <NUCToken> colonPunctuator;
    NUCConditionalExpression *conditionalExpression;
}

+ (BOOL)conditionalExpressionFrom:(NUCTokenStream *)aStream into:(NUCConditionalExpression **)anExpression;

+ (instancetype)expressionWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression;

+ (instancetype)expressionWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression questionMarkPunctuator:(id <NUCToken>)aQuestionMarkPunctuator expression:(NUCExpression *)anExpression colonPunctuator:(id <NUCToken>)aColonPunctuator conditionalExpression:(NUCConditionalExpression *)aConditionalExpression;

- (instancetype)initWithLogicalORExpression:(NUCLogicalORExpression *)aLogicalORExpression questionMarkPunctuator:(id <NUCToken>)aQuestionMarkPunctuator expression:(NUCExpression *)anExpression colonPunctuator:(id <NUCToken>)aColonPunctuator conditionalExpression:(NUCConditionalExpression *)aConditionalExpression;

- (NUCLogicalORExpression *)logicalORExpression;
- (id <NUCToken>)questionMarkPunctuator;
- (NUCExpression *)expression;
- (id <NUCToken>)colonPunctuator;
- (NUCConditionalExpression *)conditionalExpression;

@end

