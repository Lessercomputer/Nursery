//
//  NUCConstantExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCProtoExpression.h"

@class NUCConditionalExpression, NUCPreprocessingTokenStream, NUCLexicalElement;

@interface NUCConstantExpression : NUCProtoExpression
{
    NUCConditionalExpression *conditionalExpression;
}

+ (BOOL)constantExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCConstantExpression **)aConstantExpression;

+ (instancetype)expressionWithConditionalExpression:(NUCConditionalExpression *)anExpression;

- (instancetype)initWithConditionalExpression:(NUCConditionalExpression *)anExpression;

- (NUCConditionalExpression *)conditionalExpression;

@end

