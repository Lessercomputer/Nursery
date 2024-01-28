//
//  NUCRelationalExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/18.
//

#import "NUCExpressionWithMultipleExpressions.h"

@class NUCPreprocessingTokenStream;

@interface NUCRelationalExpression : NUCExpressionWithMultipleExpressions

+ (BOOL)relationalExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCRelationalExpression **)aToken;

@end

