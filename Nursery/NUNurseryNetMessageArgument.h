//
//  NUNurseryNetMessageArgument.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/01.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>
#import <Nursery/NUTypes.h>

extern const NUUInt64 NUNurseryNetMessageArgumentTypeUInt64;
extern const NUUInt64 NUNurseryNetMessageArgumentTypeBytes;
extern const NUUInt64 NUNurseryNetMessageArgumentTypeBOOL;

@interface NUNurseryNetMessageArgument : NSObject

@property (nonatomic) NUUInt64 argumentType;
@property (nonatomic, retain) id value;
@property (nonatomic, readonly) NUUInt64 UInt64FromValue;
@property (nonatomic, readonly) NSData *dataFromValue;
@property (nonatomic, readonly) BOOL BOOLFromValue;

- (instancetype)initWithValue:(id)aValue ofType:(NUUInt64)anArgumentType;

+ (instancetype)argumentWithUInt64:(NUUInt64)aValue;
+ (instancetype)argumentWithBytes:(NUUInt8  *)aValue length:(NUUInt64)aLength;
+ (instancetype)argumentWithBytesNoCopy:(NUUInt8 *)aValue length:(NUUInt64)aLength;
+ (instancetype)argumentWithBOOL:(BOOL)aValue;

@end
