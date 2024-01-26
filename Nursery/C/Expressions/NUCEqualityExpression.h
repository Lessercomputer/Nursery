//
//  NUCEqualityExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/17.
//

#import "NUCExpressionWithMultipleExpressions.h"

@class NUCPreprocessingTokenStream;

@interface NUCEqualityExpression : NUCExpressionWithMultipleExpressions

+ (BOOL)equalityExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCEqualityExpression **)aToken;

@end

