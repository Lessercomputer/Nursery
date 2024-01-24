//
//  NUCLogicalANDExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2021/02/14.
//

#import "NUCProtoExpression.h"

@class NUCLogicalANDExpression, NUCPreprocessingTokenStream;
@class NSMutableArray;

@interface NUCLogicalANDExpression : NUCProtoExpression

@property (nonatomic, retain) NSMutableArray *expressions;

+ (instancetype)expression;

+ (BOOL)logicalANDExpressionFrom:(NUCPreprocessingTokenStream *)aStream into:(NUCLogicalANDExpression **)anExpression;

- (void)add:(NUCProtoExpression *)anExpression;

@end

