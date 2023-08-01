//
//  NUQueue2.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/16.
//

#include <stdlib.h>

#import "NUQueue.h"

@implementation NUQueue

- (void)push:(id)anObject
{
    [super pushValue:(NUUInt8 *)anObject];
}

- (id)pop
{
    return (id)[super popValue];
}

- (void)willPushValue:(NUUInt8 *)aValue
{
    id anObject = (id)aValue;
    [anObject retain];
}

- (void)willPopValue:(NUUInt8 *)aValue
{
    id anObject = (id)aValue;
    [anObject autorelease];
}

- (NUUInt8 *)allocValuesWithCapacity:(NUUInt64)aCapacity
{
    return malloc((size_t)(aCapacity * sizeof(id)));
}

- (NUUInt8 *)getValueAt:(NUUInt64)anIndex in:(NUUInt8 *)aValues
{
    id *anObjects = (id *)aValues;
    return (NUUInt8 *)anObjects[anIndex];
}

- (void)setValue:(NUUInt8 *)aValue at:(NUUInt64)anIndex in:(NUUInt8 *)aValues
{
    id anObject = (id)aValue;
    id *anObjects = (id *)aValues;
    anObjects[anIndex] = anObject;
}

- (void)clearValueIfNeededAt:(NUUInt64)anIndex in:(NUUInt8 *)aValues
{
    id *anObjects = (id *)aValues;
    anObjects[anIndex] = nil;
}

@end
