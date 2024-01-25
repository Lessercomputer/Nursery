//
//  NUCLogicalANDExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/14.
//

#import "NUCExpressionWithMultipleExpressions.h"

@class NUCPreprocessingTokenStream;

@interface NUCLogicalANDExpression : NUCExpressionWithMultipleExpressions

+ (BOOL)logicalANDExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalANDExpression **)anExpression;

@end

