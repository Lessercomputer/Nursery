//
//  NUCExpressionWithMultipleExpressions.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/25.
//

#import "NUCProtoExpression.h"
#import "NUTypes.h"

#import <Foundation/NSArray.h>

@class NUCDecomposedPreprocessingToken;

@interface NUCExpressionWithMultipleExpressions : NUCProtoExpression

@property (nonatomic, retain) NSMutableArray *expressions;
@property (nonatomic, retain) NSMutableArray *operators;
@property (nonatomic, readonly) NUUInt64 count;
@property (nonatomic, readonly) NUUInt64 operatorCount;

+ (instancetype)expression;

- (void)add:(NUCProtoExpression *)anExpression;
- (NUCProtoExpression *)at:(NSUInteger)anIndex;

- (void)addOperator:(NUCDecomposedPreprocessingToken *)anOperator;
- (NUCDecomposedPreprocessingToken *)operatorAt:(NSUInteger)anIndex;

@end

