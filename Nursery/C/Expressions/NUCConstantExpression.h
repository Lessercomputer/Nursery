//
//  NUCConstantExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCPreprocessingToken.h"

@class NUCConditionalExpression, NUCPreprocessingTokenStream;

@interface NUCConstantExpression : NUCPreprocessingToken
{
    NUCConditionalExpression *conditionalExpression;
}

+ (BOOL)constantExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLexicalElement **)aToken;

+ (instancetype)expressionWithConditionalExpression:(NUCConditionalExpression *)anExpression;

- (instancetype)initWithConditionalExpression:(NUCConditionalExpression *)anExpression;

- (NUCConditionalExpression *)conditionalExpression;

@end

