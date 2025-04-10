//
//  NUCProtoExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/06.
//

#import "NUCSyntaxElement.h"

typedef enum : NSUInteger {
    NUCExpressionNone,
    NUCExpressionConstantExpressionType,
    NUCExpressionConditionalExpressionType,
    NUCExpressionExpressionType,
    NUCExpressionLogicalORExpressionType,
    NUCExpressionLogicalANDExpressionType,
    NUCExpressionInclusiveORExpressionType,
    NUCExpressionExclusiveORExpressionType,
    NUCExpressionANDExpressionType,
    NUCExpressionEqualityExpressionType,
    NUCExpressionRelationalExpressionType,
    NUCExpressionShiftExpressionType,
    NUCExpressionAdditiveExpressionType,
    NUCExpressionMultiplicativeExpressionType,
    NUCExpressionCastExpressionType,
    NUCExpressionUnaryExpressionType,
    NUCExpressionPostfixExpressionType,
    NUCExpressionPrimaryExpressionType,
    NUCExpressionConstantType
} NUCExpressionType;

@class NUCExpressionResult, NUCPreprocessor;
@protocol NUCToken;

@interface NUCProtoExpression : NUCSyntaxElement
{
    NUCExpressionType type;
}

- (instancetype)initWithType:(NUCExpressionType)aType;

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor;

@end

