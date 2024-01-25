//
//  NUCInclusiveORExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCExpressionWithMultipleExpressions.h"

@class NUCPreprocessingTokenStream;

@interface NUCInclusiveORExpression : NUCExpressionWithMultipleExpressions

+ (BOOL)inclusiveORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCInclusiveORExpression **)aToken;

@end

