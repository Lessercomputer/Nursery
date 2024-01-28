//
//  NUCExpressionWithMultipleExpressions.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/25.
//

#import "NUCProtoExpression.h"
#import "NUTypes.h"

#import <Foundation/NSArray.h>

@class NUCDecomposedPreprocessingToken, NUCPreprocessingTokenStream;

@interface NUCExpressionWithMultipleExpressions : NUCProtoExpression

@property (nonatomic, retain) NSMutableArray *expressions;
@property (nonatomic, retain) NSMutableArray *operators;
@property (nonatomic, readonly) NUUInt64 count;
@property (nonatomic, readonly) NUUInt64 operatorCount;

+ (instancetype)expression;

+ (BOOL)expressionInto:(NUCProtoExpression **)anExpression from:(NUCPreprocessingTokenStream *)aStream;
+ (BOOL)subexpressionInto:(NUCProtoExpression **)aSubexpression from:(NUCPreprocessingTokenStream *)aStream;
+ (BOOL)operatorIsValid:(NUCDecomposedPreprocessingToken *)anOperator;

- (void)add:(NUCProtoExpression *)anExpression;
- (NUCProtoExpression *)at:(NSUInteger)anIndex;

- (void)addOperator:(NUCDecomposedPreprocessingToken *)anOperator;
- (NUCDecomposedPreprocessingToken *)operatorAt:(NSUInteger)anIndex;

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor using:(void (^)(NUCExpressionResult *aLeftExpressionResult, NUCDecomposedPreprocessingToken *anOperator, NUCExpressionResult *aRightExpressionResult, NUCExpressionResult **aBinaryExpressionResult))aBlock;

@end

