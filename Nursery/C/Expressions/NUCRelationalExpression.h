//
//  NUCRelationalExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/18.
//  Copyright © 2021年 Nursery-Framework. All rights reserved.
//

#import "NUCPreprocessingToken.h"

@class NUCShiftExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCRelationalExpression : NUCPreprocessingToken
{
    NUCShiftExpression *shiftExpression;
    NUCRelationalExpression *relationalExpression;
    NUCDecomposedPreprocessingToken *relationalOperator;
}

+ (BOOL)relationalExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCRelationalExpression **)aToken;

+ (instancetype)expressionWithShiftExpression:(NUCShiftExpression *)aShiftExpression;

+ (instancetype)expressionWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression;

- (instancetype)initWithShiftExpression:(NUCShiftExpression *)aShiftExpression;

- (instancetype)initWithRelationalExpression:(NUCRelationalExpression *)aRelationalExpression relationalOperator:(NUCDecomposedPreprocessingToken *)aRelationalOperator shiftExpression:(NUCShiftExpression *)aShiftExpression;

@end

