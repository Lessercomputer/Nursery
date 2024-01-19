//
//  NUCProtoExpression.h
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/06.
//

#import <Foundation/NSObject.h>

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

@interface NUCProtoExpression : NSObject
{
    NUCExpressionType type;
}

- (instancetype)initWithType:(NUCExpressionType)aType;

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor;

@end

