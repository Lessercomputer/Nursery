//
//  NUOpaqueQueue.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/16.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#include <stdlib.h>

#import "NUOpaqueQueue.h"

const NUUInt64 NUOpaqueQueueDefaultValuesCapacity = 7;

@implementation NUOpaqueQueue

+ (instancetype)queue
{
    return [[[self alloc] init] autorelease];
}

- (instancetype)init
{
    return [self initWithCapacity:NUOpaqueQueueDefaultValuesCapacity];
}

- (instancetype)initWithCapacity:(NUUInt64)aCapacity
{
    self = [super init];
    if (self)
    {
        valuesCapacity = aCapacity;
        values = [self allocValuesWithCapacity:valuesCapacity];
    }
    return self;
}

- (void)dealloc
{
    free(values);
    
    [super dealloc];
}

- (void)pushValue:(NUUInt8 *)aValue
{
    [self willPushValue:aValue];
    
    if (count == valuesCapacity)
    {
        NUUInt8 *aValues = values;
        valuesCapacity = valuesCapacity * 2;
        values = [self allocValuesWithCapacity:valuesCapacity];
        
        if (firstIndex < lastIndex)
        {
            NUUInt64 i = 0;
            for (NUUInt64 j = firstIndex; j < lastIndex; j++)
                [self setValue:[self getValueAt:j in:aValues] at:i++ in:values];
        }
        else
        {
            NUUInt64 i = 0;
            
            for (NUUInt64 j = firstIndex; j < count; j++)
                [self setValue:[self getValueAt:j in:aValues] at:i++ in:values];
            
            for (NUUInt64 j = 0; j < lastIndex; j++)
                [self setValue:[self getValueAt:j in:aValues] at:i++ in:values];
        }
        
        firstIndex = 0;
        lastIndex = count;
        
        free(aValues);
    }
    else if (lastIndex == valuesCapacity)
        lastIndex = 0;
    
    [self setValue:aValue at:lastIndex in:values];
    
    lastIndex++;
    
    count++;
}

- (NUUInt8 *)popValue
{
    if (!count) return nil;
    
    NUUInt8 *aValue = [self getValueAt:firstIndex in:values];
    [self willPopValue:aValue];
    [self clearValueIfNeededAt:firstIndex in:values];
    
    firstIndex++;
    
    if (firstIndex == valuesCapacity && lastIndex <= firstIndex)
        firstIndex = 0;
    
    count--;
    
    return aValue;
}

- (NUUInt64)count
{
    return count;
}

- (BOOL)isFull
{
    return count == valuesCapacity;
}

- (void)willPushValue:(NUUInt8 *)aValue
{
}

- (void)willPopValue:(NUUInt8 *)aValue
{
}

- (NUUInt8 *)allocValuesWithCapacity:(NUUInt64)aCapacity
{
    return NULL;
}

- (NUUInt8 *)getValueAt:(NUUInt64)anIndex in:(NUUInt8 *)aValues
{
    return NULL;
}

- (void)setValue:(NUUInt8 *)aValue at:(NUUInt64)anIndex in:(NUUInt8 *)aValues
{
}

- (void)clearValueIfNeededAt:(NUUInt64)anIndex in:(NUUInt8 *)aValues
{
}

@end
