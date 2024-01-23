//
//  NUCLogicalORExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/12.
//

#import "NUCProtoExpression.h"
#import "NUTypes.h"

@class NUCLogicalANDExpression, NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@class NSMutableArray;

@interface NUCLogicalORExpression : NUCProtoExpression

@property (nonatomic, retain) NSMutableArray *expressions;
@property (nonatomic, readonly) NUUInt64 count;

+ (BOOL)logicalORExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalORExpression **)aToken;

+ (instancetype)expression;

- (void)add:(NUCLogicalANDExpression *)anExpression;

@end

