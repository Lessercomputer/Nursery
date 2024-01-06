//
//  NUCPrimaryExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//

#import "NUCProtoExpression.h"

@class NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream, NUCConstant, NUCExpression;

@interface NUCPrimaryExpression : NUCProtoExpression
{
    id content;
}

+ (BOOL)primaryExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPrimaryExpression **)anExpression;

+ (instancetype)expressionWithIdentifier:(NUCDecomposedPreprocessingToken *)anIdentifier;
+ (instancetype)expressionWithConstant:(NUCConstant *)aConstant;
+ (instancetype)expressionWithStringLiteral:(NUCDecomposedPreprocessingToken *)aStringLiteral;
+ (instancetype)expressionWithExpression:(NUCExpression *)anExpression;

- (instancetype)initWithContent:(id)aContent;

@end

