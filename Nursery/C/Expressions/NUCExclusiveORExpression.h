//
//  NUCExclusiveORExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/16.
//

#import "NUCExpressionWithMultipleExpressions.h"

@class NUCPreprocessingTokenStream;

@interface NUCExclusiveORExpression : NUCExpressionWithMultipleExpressions

+ (BOOL)exclusiveORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCExclusiveORExpression **)aToken;

@end

