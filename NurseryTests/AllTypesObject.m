//
//  AllTypesObject.m
//  Nursery
//
//  Created by Akifumi Takata on 2014/10/02.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import "AllTypesObject.h"

static BOOL useKeyedCoding = NO;

@implementation AllTypesObject

+ (BOOL)automaticallyEstablishCharacter
{
    return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    [aCharacter addInt8IvarWithName:@"int8Value"];
    [aCharacter addInt16IvarName:@"int16Value"];
    [aCharacter addInt32IvarName:@"int32Value"];
    [aCharacter addInt64IvarName:@"int64Value"];
    [aCharacter addUInt8IvarWithName:@"uint8Value"];
    [aCharacter addUInt16IvarName:@"uint16Value"];
    [aCharacter addUInt32IvarName:@"uint32Value"];
    [aCharacter addUInt64IvarWithName:@"uint64Value"];
    [aCharacter addFloatIvarWithName:@"floatValue"];
    [aCharacter addDoubleIvarWithName:@"doubleValue"];
    [aCharacter addBOOLIvarWithName:@"boolValue"];
    [aCharacter addRangeIvarWithName:@"rangeValue"];
    [aCharacter addPointIvarWithName:@"pointValue"];
    [aCharacter addSizeIvarWithName:@"sizeValue"];
    [aCharacter addRectIvarWithName:@"rectValue"];
    [aCharacter addOOPIvarWithName:@"stringValue"];
    [aCharacter addOOPIvarWithName:@"mutableStringValue"];
    [aCharacter addOOPIvarWithName:@"arrayValue"];
    [aCharacter addOOPIvarWithName:@"mutableArrayValue"];
    [aCharacter addOOPIvarWithName:@"dictionaryValue"];
    [aCharacter addOOPIvarWithName:@"mutableDictionaryValue"];
    [aCharacter addOOPIvarWithName:@"setValue"];
    [aCharacter addOOPIvarWithName:@"mutableSetValue"];
    [aCharacter addOOPIvarWithName:@"indexSetValue"];
    [aCharacter addOOPIvarWithName:@"mutableIndexSetValue"];
    [aCharacter addOOPIvarWithName:@"dataValue"];
    [aCharacter addOOPIvarWithName:@"mutableDataValue"];
    [aCharacter addOOPIvarWithName:@"dateValue"];
    [aCharacter addOOPIvarWithName:@"numberWithCharValue"];
    [aCharacter addOOPIvarWithName:@"numberWithUnsignedCharValue"];
    [aCharacter addOOPIvarWithName:@"numberWithShortValue"];
    [aCharacter addOOPIvarWithName:@"numberWithUnsignedShortValue"];
    [aCharacter addOOPIvarWithName:@"numberWithIntValue"];
    [aCharacter addOOPIvarWithName:@"numberWithUnsignedIntValue"];
    [aCharacter addOOPIvarWithName:@"numberWithLongValue"];
    [aCharacter addOOPIvarWithName:@"numberWithUnsignedLongValue"];
    [aCharacter addOOPIvarWithName:@"numberWithLongLongValue"];
    [aCharacter addOOPIvarWithName:@"numberWithUnsignedLongLongValue"];
    [aCharacter addOOPIvarWithName:@"numberWithFloatValue"];
    [aCharacter addOOPIvarWithName:@"numberWithDoubleValue"];
    [aCharacter addOOPIvarWithName:@"numberWithBOOLValue"];
    [aCharacter addOOPIvarWithName:@"libraryValue"];
}

+ (void)setUseKeyedCoding:(BOOL)aKeyedCodingFlag
{
    useKeyedCoding = aKeyedCodingFlag;
}

- (id)init
{
    if (self = [super init])
    {
        int8Value = -8;
        int16Value = -16;
        int32Value = -32;
        int64Value = -64;
        
        uint8Value = 8;
        uint16Value = 16;
        uint32Value = 32;
        uint64Value = 64;
        
        floatValue = 1.1;
        doubleValue = 1.2;
        
        boolValue = YES;
        
        rangeValue = NSMakeRange(0, 1);
        pointValue = NSMakePoint(1, 1);
        sizeValue = NSMakeSize(2, 2);
        rectValue = NSMakeRect(1, 1, 2, 2);
        
        stringValue = @"a String";
        mutableStringValue = [@"a MutableString" mutableCopy];
        arrayValue = [[NSArray arrayWithObjects:@"array item 0", @"array item 1", nil] retain];
        mutableArrayValue = [[NSMutableArray arrayWithObjects:@"array item 0", @"array item 1", nil] retain];
        dictionaryValue = [[NSDictionary dictionaryWithObjectsAndKeys:@"object 0",@"key 0", @"object 1",@"key 1", nil] retain];
        mutableDictionaryValue = [[NSMutableDictionary dictionaryWithObjectsAndKeys:@"object 0",@"key 0", @"object 1",@"key 1", nil] retain];
        setValue = [[NSSet setWithObjects:@"set item 0", @"set item 1", nil] retain];
        mutableSetValue = [[NSMutableSet setWithObjects:@"set item 0", @"set item 1", nil] retain];
        indexSetValue = [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] retain];
        mutableIndexSetValue = [[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] retain];
        dataValue = [[@"a Data" dataUsingEncoding:NSUTF8StringEncoding] copy];
        mutableDataValue = [[@"a MutableData" dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
        dateValue = [[NSDate date] retain];
        
        numberWithCharValue = [[NSNumber numberWithChar:'a'] retain];
        numberWithUnsignedCharValue = [[NSNumber numberWithUnsignedChar:'A'] retain];
        numberWithShortValue = [[NSNumber numberWithShort:SHRT_MAX] retain];
        numberWithUnsignedShortValue = [[NSNumber numberWithUnsignedShort:USHRT_MAX] retain];
        numberWithIntValue = [[NSNumber numberWithInt:INT_MAX] retain];
        numberWithUnsignedIntValue = [[NSNumber numberWithUnsignedInt:UINT_MAX] retain];
        numberWithLongValue = [[NSNumber numberWithLong:LONG_MAX] retain];
        numberWithUnsignedLongValue = [[NSNumber numberWithUnsignedLong:ULONG_MAX] retain];
        numberWithLongLongValue = [[NSNumber numberWithLongLong:ULONG_LONG_MAX] retain];
        numberWithUnsignedLongLongValue = [[NSNumber numberWithUnsignedLongLong:ULONG_LONG_MAX] retain];
        numberWithFloatValue = [[NSNumber numberWithFloat:FLT_MAX] retain];
        numberWithDoubleValue = [[NSNumber numberWithDouble:DBL_MAX] retain];
        numberWithBOOLValue = [[NSNumber numberWithBool:YES] retain];
        
        libraryValue = [[NULibrary library] retain];
        [libraryValue setObject:@"library item 0" forKey:@"library key 0"];
    }
    
    return self;
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
    if (!useKeyedCoding)
    {
        [anAliaser encodeInt8:int8Value];
        [anAliaser encodeInt16:int16Value];
        [anAliaser encodeInt32:int32Value];
        [anAliaser encodeInt64:int64Value];
        [anAliaser encodeUInt8:uint8Value];
        [anAliaser encodeUInt16:uint16Value];
        [anAliaser encodeUInt32:uint32Value];
        [anAliaser encodeUInt64:uint64Value];
        [anAliaser encodeFloat:floatValue];
        [anAliaser encodeDouble:doubleValue];
        [anAliaser encodeBOOL:boolValue];
        [anAliaser encodeRange:rangeValue];
        [anAliaser encodePoint:pointValue];
        [anAliaser encodeSize:sizeValue];
        [anAliaser encodeRect:rectValue];
        [anAliaser encodeObject:stringValue];
        [anAliaser encodeObject:mutableStringValue];
        [anAliaser encodeObject:arrayValue];
        [anAliaser encodeObject:mutableArrayValue];
        [anAliaser encodeObject:dictionaryValue];
        [anAliaser encodeObject:mutableDictionaryValue];
        [anAliaser encodeObject:setValue];
        [anAliaser encodeObject:mutableSetValue];
        [anAliaser encodeObject:indexSetValue];
        [anAliaser encodeObject:mutableIndexSetValue];
        [anAliaser encodeObject:dataValue];
        [anAliaser encodeObject:mutableDataValue];
        [anAliaser encodeObject:dateValue];
        [anAliaser encodeObject:numberWithCharValue];
        [anAliaser encodeObject:numberWithUnsignedCharValue];
        [anAliaser encodeObject:numberWithShortValue];
        [anAliaser encodeObject:numberWithUnsignedShortValue];
        [anAliaser encodeObject:numberWithIntValue];
        [anAliaser encodeObject:numberWithUnsignedIntValue];
        [anAliaser encodeObject:numberWithLongValue];
        [anAliaser encodeObject:numberWithUnsignedLongValue];
        [anAliaser encodeObject:numberWithLongLongValue];
        [anAliaser encodeObject:numberWithUnsignedLongLongValue];
        [anAliaser encodeObject:numberWithFloatValue];
        [anAliaser encodeObject:numberWithDoubleValue];
        [anAliaser encodeObject:numberWithBOOLValue];
        [anAliaser encodeObject:libraryValue];
    }
    else
    {
        [anAliaser encodeObject:libraryValue forKey:@"libraryValue"];
        [anAliaser encodeObject:numberWithBOOLValue forKey:@"numberWithBOOLValue"];
        [anAliaser encodeObject:numberWithDoubleValue forKey:@"numberWithDoubleValue"];
        [anAliaser encodeObject:numberWithFloatValue forKey:@"numberWithFloatValue"];
        [anAliaser encodeObject:numberWithUnsignedLongLongValue forKey:@"numberWithUnsignedLongLongValue"];
        [anAliaser encodeObject:numberWithLongLongValue forKey:@"numberWithLongLongValue"];
        [anAliaser encodeObject:numberWithUnsignedLongValue forKey:@"numberWithUnsignedLongValue"];
        [anAliaser encodeObject:numberWithLongValue forKey:@"numberWithLongValue"];
        [anAliaser encodeObject:numberWithUnsignedIntValue forKey:@"numberWithUnsignedIntValue"];
        [anAliaser encodeObject:numberWithIntValue forKey:@"numberWithIntValue"];
        [anAliaser encodeObject:numberWithUnsignedShortValue forKey:@"numberWithUnsignedShortValue"];
        [anAliaser encodeObject:numberWithShortValue forKey:@"numberWithShortValue"];
        [anAliaser encodeObject:numberWithUnsignedCharValue forKey:@"numberWithUnsignedCharValue"];
        [anAliaser encodeObject:numberWithCharValue forKey:@"numberWithCharValue"];
        [anAliaser encodeObject:dateValue forKey:@"dateValue"];
        [anAliaser encodeObject:mutableDataValue forKey:@"mutableDataValue"];
        [anAliaser encodeObject:dataValue forKey:@"dataValue"];
        [anAliaser encodeObject:mutableIndexSetValue forKey:@"mutableIndexSetValue"];
        [anAliaser encodeObject:indexSetValue forKey:@"indexSetValue"];
        [anAliaser encodeObject:mutableSetValue forKey:@"mutableSetValue"];
        [anAliaser encodeObject:setValue forKey:@"setValue"];
        [anAliaser encodeObject:mutableDictionaryValue forKey:@"mutableDictionaryValue"];
        [anAliaser encodeObject:dictionaryValue forKey:@"dictionaryValue"];
        [anAliaser encodeObject:mutableArrayValue forKey:@"mutableArrayValue"];
        [anAliaser encodeObject:arrayValue forKey:@"arrayValue"];
        [anAliaser encodeObject:mutableStringValue forKey:@"mutableStringValue"];
        [anAliaser encodeObject:stringValue forKey:@"stringValue"];
        [anAliaser encodeRect:rectValue forKey:@"rectValue"];
        [anAliaser encodeSize:sizeValue forKey:@"sizeValue"];
        [anAliaser encodePoint:pointValue forKey:@"pointValue"];
        [anAliaser encodeRange:rangeValue forKey:@"rangeValue"];
        [anAliaser encodeBOOL:boolValue forKey:@"boolValue"];
        [anAliaser encodeDouble:doubleValue forKey:@"doubleValue"];
        [anAliaser encodeFloat:floatValue forKey:@"floatValue"];
        [anAliaser encodeUInt64:uint64Value forKey:@"uint64Value"];
        [anAliaser encodeUInt32:uint32Value forKey:@"uint32Value"];
        [anAliaser encodeUInt16:uint16Value forKey:@"uint16Value"];
        [anAliaser encodeUInt8:uint8Value forKey:@"uint8Value"];
        [anAliaser encodeInt64:int64Value forKey:@"int64Value"];
        [anAliaser encodeInt32:int32Value forKey:@"int32Value"];
        [anAliaser encodeInt16:int16Value forKey:@"int16Value"];
        [anAliaser encodeInt8:int8Value forKey:@"int8Value"];
    }
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    if (self = [super init])
    {
        if (!useKeyedCoding)
        {
            int8Value = [anAliaser decodeInt8];
            int16Value = [anAliaser decodeInt16];
            int32Value = [anAliaser decodeInt32];
            int64Value = [anAliaser decodeInt64];
            uint8Value = [anAliaser decodeUInt8];
            uint16Value = [anAliaser decodeUInt16];
            uint32Value = [anAliaser decodeUInt32];
            uint64Value = [anAliaser decodeUInt64];
            floatValue = [anAliaser decodeFloat];
            doubleValue = [anAliaser decodeDouble];
            boolValue = [anAliaser decodeBOOL];
            rangeValue = [anAliaser decodeRange];
            pointValue = [anAliaser decodePoint];
            sizeValue = [anAliaser decodeSize];
            rectValue = [anAliaser decodeRect];
            stringValue = [[anAliaser decodeObject] retain];
            mutableStringValue = [[anAliaser decodeObject] retain];
            arrayValue = [[anAliaser decodeObject] retain];
            mutableArrayValue = [[anAliaser decodeObject] retain];
            dictionaryValue = [[anAliaser decodeObject] retain];
            mutableDictionaryValue = [[anAliaser decodeObject] retain];
            setValue = [[anAliaser decodeObject] retain];
            mutableSetValue = [[anAliaser decodeObject] retain];
            indexSetValue = [[anAliaser decodeObject] retain];
            mutableIndexSetValue = [[anAliaser decodeObject] retain];
            dataValue = [[anAliaser decodeObject] retain];
            mutableDataValue = [[anAliaser decodeObject] retain];
            dateValue = [[anAliaser decodeObject] retain];
            numberWithCharValue = [[anAliaser decodeObject] retain];
            numberWithUnsignedCharValue = [[anAliaser decodeObject] retain];
            numberWithShortValue = [[anAliaser decodeObject] retain];
            numberWithUnsignedShortValue = [[anAliaser decodeObject] retain];
            numberWithIntValue = [[anAliaser decodeObject] retain];
            numberWithUnsignedIntValue = [[anAliaser decodeObject] retain];
            numberWithLongValue = [[anAliaser decodeObject] retain];
            numberWithUnsignedLongValue = [[anAliaser decodeObject] retain];
            numberWithLongLongValue = [[anAliaser decodeObject] retain];
            numberWithUnsignedLongLongValue = [[anAliaser decodeObject] retain];
            numberWithFloatValue = [[anAliaser decodeObject] retain];
            numberWithDoubleValue = [[anAliaser decodeObject] retain];
            numberWithBOOLValue = [[anAliaser decodeObject] retain];
            libraryValue = [[anAliaser decodeObject] retain];
        }
        else
        {
            libraryValue = [[anAliaser decodeObjectForKey:@"libraryValue"] retain];
            numberWithBOOLValue = [[anAliaser decodeObjectForKey:@"numberWithBOOLValue"] retain];
            numberWithDoubleValue = [[anAliaser decodeObjectForKey:@"numberWithDoubleValue"] retain];
            numberWithFloatValue = [[anAliaser decodeObjectForKey:@"numberWithFloatValue"] retain];
            numberWithUnsignedLongLongValue = [[anAliaser decodeObjectForKey:@"numberWithUnsignedLongLongValue"] retain];
            numberWithLongLongValue = [[anAliaser decodeObjectForKey:@"numberWithLongLongValue"] retain];
            numberWithUnsignedLongValue = [[anAliaser decodeObjectForKey:@"numberWithUnsignedLongValue"] retain];
            numberWithLongValue = [[anAliaser decodeObjectForKey:@"numberWithLongValue"] retain];
            numberWithUnsignedIntValue = [[anAliaser decodeObjectForKey:@"numberWithUnsignedIntValue"] retain];
            numberWithIntValue = [[anAliaser decodeObjectForKey:@"numberWithIntValue"] retain];
            numberWithUnsignedShortValue = [[anAliaser decodeObjectForKey:@"numberWithUnsignedShortValue"] retain];
            numberWithShortValue = [[anAliaser decodeObjectForKey:@"numberWithShortValue"] retain];
            numberWithUnsignedCharValue = [[anAliaser decodeObjectForKey:@"numberWithUnsignedCharValue"] retain];
            numberWithCharValue = [[anAliaser decodeObjectForKey:@"numberWithCharValue"] retain];
            dateValue = [[anAliaser decodeObjectForKey:@"dateValue"] retain];
            mutableDataValue = [[anAliaser decodeObjectForKey:@"mutableDataValue"] retain];
            dataValue = [[anAliaser decodeObjectForKey:@"dataValue"] retain];
            mutableIndexSetValue = [[anAliaser decodeObjectForKey:@"mutableIndexSetValue"] retain];
            indexSetValue = [[anAliaser decodeObjectForKey:@"indexSetValue"] retain];
            mutableSetValue = [[anAliaser decodeObjectForKey:@"mutableSetValue"] retain];
            setValue = [[anAliaser decodeObjectForKey:@"setValue"] retain];
            mutableDictionaryValue = [[anAliaser decodeObjectForKey:@"mutableDictionaryValue"] retain];
            dictionaryValue = [[anAliaser decodeObjectForKey:@"dictionaryValue"] retain];
            mutableArrayValue = [[anAliaser decodeObjectForKey:@"mutableArrayValue"] retain];
            arrayValue = [[anAliaser decodeObjectForKey:@"arrayValue"] retain];
            mutableStringValue = [[anAliaser decodeObjectForKey:@"mutableStringValue"] retain];
            stringValue = [[anAliaser decodeObjectForKey:@"stringValue"] retain];
            rectValue = [anAliaser decodeRectForKey:@"rectValue"];
            sizeValue = [anAliaser decodeSizeForKey:@"sizeValue"];
            pointValue = [anAliaser decodePointForKey:@"pointValue"];
            rangeValue = [anAliaser decodeRangeForKey:@"rangeValue"];
            boolValue = [anAliaser decodeBOOLForKey:@"boolValue"];
            doubleValue = [anAliaser decodeDoubleForKey:@"doubleValue"];
            floatValue = [anAliaser decodeFloatForKey:@"floatValue"];
            uint64Value = [anAliaser decodeUInt64ForKey:@"uint64Value"];
            uint32Value = [anAliaser decodeUInt32ForKey:@"uint32Value"];
            uint16Value = [anAliaser decodeUInt16ForKey:@"uint16Value"];
            uint8Value = [anAliaser decodeUInt8ForKey:@"uint8Value"];
            int64Value = [anAliaser decodeInt64ForKey:@"int64Value"];
            int32Value = [anAliaser decodeInt32ForKey:@"int32Value"];
            int16Value = [anAliaser decodeInt16ForKey:@"int16Value"];
            int8Value = [anAliaser decodeInt8ForKey:@"int8Value"];
        }
    }
    
    return self;
}

- (NUBell *)bell
{
    return bell;
}

- (void)setBell:(NUBell *)aBell
{
    bell = aBell;
}

- (NUInt8)int8Value
{
    return int8Value;
}

- (NUInt16)int16Value
{
    return int16Value;
}

- (NUInt32)int32Value
{
    return int32Value;
}

- (NUInt64)int64Value
{
    return int64Value;
}

- (NUUInt8)uint8Value
{
    return uint8Value;
}

- (NUUInt16)uint16Value
{
    return uint16Value;
}

- (NUUInt32)uint32Value
{
    return uint32Value;
}

- (NUUInt64)uint64Value
{
    return uint64Value;
}

- (NUFloat)floatValue
{
    return floatValue;
}

- (NUDouble)doubleValue
{
    return doubleValue;
}

- (BOOL)BOOLValue
{
    return boolValue;
}

- (NSRange)rangeValue
{
    return rangeValue;
}

- (NSPoint)pointValue
{
    return pointValue;
}

- (NSSize)sizeValue
{
    return sizeValue;
}

- (NSRect)rectValue
{
    return rectValue;
}

- (NSString *)stringValue
{
    return NUGetIvar(&stringValue);
}

- (NSMutableString *)mutableStringValue
{
    return NUGetIvar(&mutableStringValue);
}

- (NSArray *)arrayValue
{
    return NUGetIvar(&arrayValue);
}

- (NSMutableArray *)mutableArrayValue
{
    return NUGetIvar(&mutableArrayValue);
}

- (NSDictionary *)dictionaryValue
{
    return NUGetIvar(&dictionaryValue);
}

- (NSMutableDictionary *)mutableDictionaryValue
{
    return NUGetIvar(&mutableDictionaryValue);
}

- (NSSet *)setValue
{
    return NUGetIvar(&setValue);
}

- (NSMutableSet *)mutableSetValue
{
    return NUGetIvar(&mutableSetValue);
}

- (NSIndexSet *)indexSetValue
{
    return NUGetIvar(&indexSetValue);
}

- (NSMutableIndexSet *)mutableIndexSetValue
{
    return NUGetIvar(&mutableIndexSetValue);
}

- (NSData *)dataValue
{
    return NUGetIvar(&dataValue);
}

- (NSMutableData *)mutableDataValue
{
    return NUGetIvar(&mutableDataValue);
}

- (NSDate *)dateValue
{
    return NUGetIvar(&dateValue);
}

- (NSNumber *)numberWithCharValue
{
    return NUGetIvar(&numberWithCharValue);
}

- (NSNumber *)numberWithUnsignedCharValue
{
    return NUGetIvar(&numberWithUnsignedCharValue);
}

- (NSNumber *)numberWithShortValue
{
    return NUGetIvar(&numberWithShortValue);
}

- (NSNumber *)numberWithUnsignedShortValue
{
    return NUGetIvar(&numberWithUnsignedShortValue);
}

- (NSNumber *)numberWithIntValue
{
    return NUGetIvar(&numberWithIntValue);
}

- (NSNumber *)numberWithUnsignedIntValue
{
    return NUGetIvar(&numberWithUnsignedIntValue);
}

- (NSNumber *)numberWithLongValue
{
    return NUGetIvar(&numberWithLongValue);
}

- (NSNumber *)numberWithUnsignedLongValue
{
    return NUGetIvar(&numberWithUnsignedLongValue);
}

- (NSNumber *)numberWithLongLongValue
{
    return NUGetIvar(&numberWithLongLongValue);
}

- (NSNumber *)numberWithUnsignedLongLongValue
{
    return NUGetIvar(&numberWithUnsignedLongLongValue);
}

- (NSNumber *)numberWithFloatValue
{
    return NUGetIvar(&numberWithFloatValue);
}

- (NSNumber *)numberWithDoubleValue
{
    return NUGetIvar(&numberWithDoubleValue);
}

- (NSNumber *)numberWithBOOLValue
{
    return NUGetIvar(&numberWithBOOLValue);
}

- (NULibrary *)libraryValue
{
    return NUGetIvar(&libraryValue);
}

- (BOOL)isEqual:(id)object
{
    AllTypesObject *anObject = object;
    
    if (self == anObject) return YES;
    
    if ([self int8Value] != [anObject int8Value]) return NO;
    if ([self int16Value] != [anObject int16Value]) return NO;
    if ([self int32Value] != [anObject int32Value]) return NO;
    if ([self int64Value] != [anObject int64Value]) return NO;
    
    if ([self uint8Value] != [anObject uint8Value]) return NO;
    if ([self uint16Value] != [anObject uint16Value]) return NO;
    if ([self uint32Value] != [anObject uint32Value]) return NO;
    if ([self uint64Value] != [anObject uint64Value]) return NO;
    
    if ([self floatValue] != [anObject floatValue]) return NO;
    if ([self doubleValue] != [anObject doubleValue]) return NO;

    if ([self BOOLValue] != [anObject BOOLValue]) return NO;
    
    if (!NSEqualRanges([self rangeValue], [anObject rangeValue])) return NO;
    if (!NSEqualPoints([self pointValue], [anObject pointValue])) return NO;
    if (!NSEqualSizes([self sizeValue], [anObject sizeValue])) return NO;
    if (!NSEqualRects([self rectValue], [anObject rectValue])) return NO;

    if (![[self stringValue] isEqual:[anObject stringValue]]) return NO;
    if (![[self mutableStringValue] isEqual:[anObject mutableStringValue]]) return NO;
    
    if (![[self arrayValue] isEqual:[anObject arrayValue]]) return NO;
    if (![[self mutableArrayValue] isEqual:[anObject mutableArrayValue]]) return NO;
    
    if (![[self dictionaryValue] isEqual:[anObject dictionaryValue]]) return NO;
    if (![[self mutableDictionaryValue] isEqual:[anObject mutableDictionaryValue]]) return NO;
    
    if (![[self setValue] isEqual:[anObject setValue]]) return NO;
    if (![[self mutableSetValue] isEqual:[anObject mutableSetValue]]) return NO;
    
    if (![[self indexSetValue] isEqual:[anObject indexSetValue]]) return NO;
    if (![[self mutableIndexSetValue] isEqual:[anObject mutableIndexSetValue]]) return NO;
    
    if (![[self dataValue] isEqual:[anObject dataValue]]) return NO;
    if (![[self mutableDataValue] isEqual:[anObject mutableDataValue]]) return NO;
    
    if (![[self dateValue] isEqual:[anObject dateValue]]) return NO;
    
    if (![[self numberWithCharValue] isEqual:[anObject numberWithCharValue]]) return NO;
    if (![[self numberWithUnsignedCharValue] isEqual:[anObject numberWithUnsignedCharValue]]) return NO;
    if (![[self numberWithShortValue] isEqual:[anObject numberWithShortValue]]) return NO;
    if (![[self numberWithUnsignedShortValue] isEqual:[anObject numberWithUnsignedShortValue]]) return NO;
    if (![[self numberWithIntValue] isEqual:[anObject numberWithIntValue]]) return NO;
    if (![[self numberWithUnsignedIntValue] isEqual:[anObject numberWithUnsignedIntValue]]) return NO;
    if (![[self numberWithLongValue] isEqual:[anObject numberWithLongValue]]) return NO;
    if (![[self numberWithUnsignedLongValue] isEqual:[anObject numberWithUnsignedLongValue]]) return NO;
    if (![[self numberWithLongLongValue] isEqual:[anObject numberWithLongLongValue]]) return NO;
    if (![[self numberWithUnsignedLongLongValue] isEqual:[anObject numberWithUnsignedLongLongValue]]) return NO;
    if (![[self numberWithFloatValue] isEqual:[anObject numberWithFloatValue]]) return NO;
    if (![[self numberWithDoubleValue] isEqual:[anObject numberWithDoubleValue]]) return NO;
    if (![[self numberWithBOOLValue] isEqual:[anObject numberWithBOOLValue]]) return NO;
    
    if (![[self libraryValue] isEqual:[anObject libraryValue]]) return NO;
    
    return YES;
}

@end
