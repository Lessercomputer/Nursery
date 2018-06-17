//
//  NUUInt64Queue.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/17.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#include <stdlib.h>

#import "NUUInt64Queue.h"

@implementation NUUInt64Queue

- (void)push:(NUUInt64)aValue
{
    [self pushValue:(NUUInt8 *)&aValue];
}

- (NUUInt64)pop
{
    return *(NUUInt64 *)[self popValue];
}

- (NUUInt8 *)allocValuesWithCapacity:(NUUInt64)aCapacity
{
    return malloc(aCapacity * sizeof(NUUInt64));
}

- (NUUInt8 *)getValueAt:(NUUInt64)anIndex in:(NUUInt8 *)aValues
{
    NUUInt64 *aUInt64Values = (NUUInt64 *)aValues;
    return (NUUInt8 *)&aUInt64Values[anIndex];
}

- (void)setValue:(NUUInt8 *)aValue at:(NUUInt64)anIndex in:(NUUInt8 *)aValues
{
    NUUInt64 *aUInt64Values = (NUUInt64 *)aValues;
    aUInt64Values[anIndex] = *(NUUInt64 *)aValue;
}

@end
