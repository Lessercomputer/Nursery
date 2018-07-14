//
//  NUOpaqueQueue.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/06/16.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

#import "NUTypes.h"

@interface NUOpaqueQueue : NSObject
{
    NUUInt8 *values;
    NUUInt64 valuesCapacity;
    NUUInt64 count;
    NUUInt64 firstIndex;
    NUUInt64 lastIndex;
}

+ (instancetype)queue;

- (instancetype)initWithCapacity:(NUUInt64)aCapacity;
                                   
- (void)pushValue:(NUUInt8 *)aValue;
- (NUUInt8 *)popValue;

- (void)removeAll;

- (NUUInt64)count;
- (BOOL)isFull;

- (void)willPushValue:(NUUInt8 *)aValue;
- (void)willPopValue:(NUUInt8 *)aValue;
- (NUUInt8 *)allocValuesWithCapacity:(NUUInt64)aCapacity;
- (NUUInt8 *)getValueAt:(NUUInt64)anIndex in:(NUUInt8 *)aValues;
- (void)setValue:(NUUInt8 *)aValue at:(NUUInt64)anIndex in:(NUUInt8 *)aValues;
- (void)clearValueIfNeededAt:(NUUInt64)anIndex in:(NUUInt8 *)aValues;

@end
