//
//  NUCExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCProtoExpression.h"

@class NUCConditionalExpression, NUCPreprocessingTokenStream;

@interface NUCExpression : NUCProtoExpression
{
    NUCConditionalExpression *conditionalExpression;
}

+ (BOOL)expressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCExpression **)anExpression;

+ (instancetype)expressionWithConditionalExpression:(NUCConditionalExpression *)aConditionalExpression;

- (instancetype)initWithConditionalExpression:(NUCConditionalExpression *)aConditionalExpression;

@end

