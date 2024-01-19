//
//  NUCProtoExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/06.
//

#import "NUCProtoExpression.h"

@implementation NUCProtoExpression

- (instancetype)initWithType:(NUCExpressionType)aType
{
    if (self = [super init])
    {
        type = aType;
    }
    
    return self;
}

- (NUCExpressionResult *)evaluateWith:(NUCPreprocessor *)aPreprocessor
{
    return nil;
}

@end
