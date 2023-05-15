//
//  NUCPrimaryExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/21.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream, NUCConstant, NUCExpression;

@interface NUCPrimaryExpression : NUCPreprocessingToken
{
    NUCPreprocessingToken *content;
}

+ (BOOL)primaryExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCPrimaryExpression **)anExpression;

+ (instancetype)expressionWithIdentifier:(NUCDecomposedPreprocessingToken *)anIdentifier;
+ (instancetype)expressionWithConstant:(NUCConstant *)aConstant;
+ (instancetype)expressionWithStringLiteral:(NUCDecomposedPreprocessingToken *)aStringLiteral;
+ (instancetype)expressionWithExpression:(NUCExpression *)anExpression;

- (instancetype)initWithToken:(NUCPreprocessingToken *)aContent;

@end

