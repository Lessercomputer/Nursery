//
//  NUNurseryNetMessageArgument.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/01.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSValue.h>
#import <Foundation/NSData.h>

#import "NUNurseryNetMessageArgument.h"
#import "NUTypes.h"

const NUUInt64 NUNurseryNetMessageArgumentTypeUInt64  = 0;
const NUUInt64 NUNurseryNetMessageArgumentTypeBytes   = 1;
const NUUInt64 NUNurseryNetMessageArgumentTypeBOOL    = 2;

@implementation NUNurseryNetMessageArgument

- (instancetype)initWithValue:(id)aValue ofType:(NUUInt64)anArgumentType
{
    if (self = [super init])
    {
        _argumentType = anArgumentType;
        _value = [aValue retain];
    }
    
    return self;
}

- (void)dealloc
{
    [_value release];
    
    [super dealloc];
}

+ (instancetype)argumentWithUInt64:(NUUInt64)aValue
{
    return [[[self alloc] initWithValue:@(aValue) ofType:NUNurseryNetMessageArgumentTypeUInt64] autorelease];
}

+ (instancetype)argumentWithBytes:(NUUInt8 *)aValue length:(NUUInt64)aLength
{
    return [[[self alloc] initWithValue:[NSData dataWithBytes:aValue length:(NSUInteger)aLength] ofType:NUNurseryNetMessageArgumentTypeBytes] autorelease];
}

+ (instancetype)argumentWithBytesNoCopy:(NUUInt8 *)aValue length:(NUUInt64)aLength
{
    return [[[self alloc] initWithValue:[NSData dataWithBytesNoCopy:aValue length:(NSUInteger)aLength] ofType:NUNurseryNetMessageArgumentTypeBytes] autorelease];
}

+ (instancetype)argumentWithBOOL:(BOOL)aValue
{
    return [[[self alloc] initWithValue:@(aValue) ofType:NUNurseryNetMessageArgumentTypeBOOL] autorelease];
}

@dynamic UInt64FromValue;
- (NUUInt64)UInt64FromValue
{
    return [(NSNumber *)[self value] unsignedLongLongValue];
}

@dynamic dataFromValue;
- (NSData *)dataFromValue
{
    return (NSData *)[self value];
}

@dynamic BOOLFromValue;
- (BOOL)BOOLFromValue
{
    return [(NSNumber *)[self value] boolValue];
}

@end
