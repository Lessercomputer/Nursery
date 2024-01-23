//
//  NUCExpressionResult.m
//  Nursery
//
//  Created by TAKATA Akifumi on 2024/01/06.
//

#import "NUCExpressionResult.h"

@implementation NUCExpressionResult

+ (instancetype)expressionResultWithIntValue:(int)aValue
{
    return [[[self alloc] initWithIntValue:aValue] autorelease];
}

- (instancetype)initWithIntValue:(int)aValue
{
    if (self = [super init])
        intValue = aValue;
    
    return self;
}

- (int)intValue
{
    return intValue;
}

@end
