//
//  NUCProtoExpression.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/06.
//  Copyright © 2024 com.lily-bud. All rights reserved.
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

- (NUCExpressionResult *)executeWith:(NUCPreprocessor *)aPreprocessor
{
    return nil;
}

@end
