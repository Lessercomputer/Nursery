//
//  AllTypesObject.h
//  Nursery
//
//  Created by Akifumi Takata on 2014/10/02.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@interface AllTypesObject : NSObject <NUCoding>
{
    NUBell *bell;
    NUInt8 int8Value;
    NUInt16 int16Value;
    NUInt32 int32Value;
    NUInt64 int64Value;
    NUUInt8 uint8Value;
    NUUInt16 uint16Value;
    NUUInt32 uint32Value;
    NUUInt64 uint64Value;
    NUFloat floatValue;
    NUDouble doubleValue;
    BOOL boolValue;
    NSRange rangeValue;
    NSPoint pointValue;
    NSSize sizeValue;
    NSRect rectValue;
    NSString *stringValue;
    NSMutableString *mutableStringValue;
    NSArray *arrayValue;
    NSMutableArray *mutableArrayValue;
    NSDictionary *dictionaryValue;
    NSMutableDictionary *mutableDictionaryValue;
    NSSet *setValue;
    NSMutableSet *mutableSetValue;
    NSIndexSet *indexSetValue;
    NSMutableIndexSet *mutableIndexSetValue;
    NSData *dataValue;
    NSMutableData *mutableDataValue;
    NSDate *dateValue;
    NSNumber *numberWithCharValue;
    NSNumber *numberWithUnsignedCharValue;
    NSNumber *numberWithShortValue;
    NSNumber *numberWithUnsignedShortValue;
    NSNumber *numberWithIntValue;
    NSNumber *numberWithUnsignedIntValue;
    NSNumber *numberWithLongValue;
    NSNumber *numberWithUnsignedLongValue;
    NSNumber *numberWithLongLongValue;
    NSNumber *numberWithUnsignedLongLongValue;
    NSNumber *numberWithFloatValue;
    NSNumber *numberWithDoubleValue;
    NSNumber *numberWithBOOLValue;
    NULibrary *libraryValue;
}

+ (void)setUseKeyedCoding:(BOOL)aKeyedCodingFlag;

- (NUInt8)int8Value;
- (NUInt16)int16Value;
- (NUInt32)int32Value;
- (NUInt64)int64Value;

- (NUUInt8)uint8Value;
- (NUUInt16)uint16Value;
- (NUUInt32)uint32Value;
- (NUUInt64)uint64Value;

- (NUFloat)floatValue;
- (NUDouble)doubleValue;

- (BOOL)BOOLValue;

- (NSRange)rangeValue;
- (NSPoint)pointValue;
- (NSSize)sizeValue;
- (NSRect)rectValue;

- (NSString *)stringValue;
- (NSMutableString *)mutableStringValue;

- (NSArray *)arrayValue;
- (NSMutableArray *)mutableArrayValue;

- (NSDictionary *)dictionaryValue;
- (NSMutableDictionary *)mutableDictionaryValue;

- (NSSet *)setValue;
- (NSMutableSet *)mutableSetValue;

- (NSIndexSet *)indexSetValue;
- (NSMutableIndexSet *)mutableIndexSetValue;

- (NSData *)dataValue;
- (NSMutableData *)mutableDataValue;

- (NSDate *)dateValue;

- (NSNumber *)numberWithCharValue;
- (NSNumber *)numberWithUnsignedCharValue;
- (NSNumber *)numberWithShortValue;
- (NSNumber *)numberWithUnsignedShortValue;
- (NSNumber *)numberWithIntValue;
- (NSNumber *)numberWithUnsignedIntValue;
- (NSNumber *)numberWithLongValue;
- (NSNumber *)numberWithUnsignedLongValue;
- (NSNumber *)numberWithLongLongValue;
- (NSNumber *)numberWithUnsignedLongLongValue;
- (NSNumber *)numberWithFloatValue;
- (NSNumber *)numberWithDoubleValue;
- (NSNumber *)numberWithBOOLValue;

- (NULibrary *)libraryValue;

@end
