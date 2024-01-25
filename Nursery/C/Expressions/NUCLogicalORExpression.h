//
//  NUCLogicalORExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCExpressionWithMultipleExpressions.h"

@class NUCPreprocessingTokenStream;

@interface NUCLogicalORExpression : NUCExpressionWithMultipleExpressions

+ (BOOL)logicalORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalORExpression **)anExpression;

@end

