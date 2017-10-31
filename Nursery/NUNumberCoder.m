//
//  NUNumberCoder.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import "NUNumberCoder.h"

@implementation NUNumberCoder

- (void)encode:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
    [self encodeIndexedIvarsOf:anObject withAliaser:anAliaser];
}

- (void)encodeIndexedIvarsOf:(id)anObject withAliaser:(NUAliaser *)anAliaser
{
	NSNumber *aNumber  = anObject;
	const char *aNumberObjCType = [aNumber objCType];
    NUUInt64 aLengthOfObjCType = strlen(aNumberObjCType);
    NUUInt64 aSwappedLengthOfObjCType = NSSwapHostLongLongToBig(aLengthOfObjCType);
    [anAliaser encodeIndexedBytes:(NUUInt8 *)&aSwappedLengthOfObjCType count:sizeof(NUUInt64)];
    [anAliaser encodeIndexedBytes:(NUUInt8 *)aNumberObjCType count:aLengthOfObjCType at:sizeof(NUUInt64)];
    NUUInt64 anOffset = sizeof(NUUInt64) + aLengthOfObjCType;
    
    if (strcmp(aNumberObjCType, @encode(unsigned char)) == 0)
    {
        unsigned char aValue = [aNumber unsignedCharValue];
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(unsigned char) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(char)) == 0)
    {
        unsigned char aValue = [aNumber charValue];
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(char) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(unsigned short)) == 0)
    {
        unsigned short aValue = NSSwapHostShortToBig([aNumber unsignedShortValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(unsigned short) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(short)) == 0)
    {
        unsigned short aValue = NSSwapHostShortToBig([aNumber shortValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(short) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(unsigned int)) == 0)
    {
        unsigned int aValue = NSSwapHostIntToBig([aNumber unsignedIntValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(unsigned int) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(int)) == 0)
    {
        unsigned int aValue = NSSwapHostIntToBig([aNumber intValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(int) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(unsigned long)) == 0)
    {
        unsigned long aValue = NSSwapHostLongToBig([aNumber unsignedLongValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(unsigned long) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(long)) == 0)
    {
        unsigned long aValue = NSSwapHostLongToBig([aNumber longValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(long) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(unsigned long long)) == 0)
    {
        unsigned long long aValue = NSSwapHostLongLongToBig([aNumber unsignedLongLongValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(unsigned long long) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(long long)) == 0)
    {
        long long aValue = NSSwapHostLongLongToBig([aNumber longLongValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(long long) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(float)) == 0)
    {
        NSSwappedFloat aValue = NSSwapHostFloatToBig([aNumber floatValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(float) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(double)) == 0)
    {
        NSSwappedDouble aValue = NSSwapHostDoubleToBig([aNumber doubleValue]);
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(double) at:anOffset];
    }
    else if (strcmp(aNumberObjCType, @encode(BOOL)) == 0)
    {
        NUUInt8 aValue = [aNumber boolValue];
        [anAliaser encodeIndexedBytes:(NUUInt8 *)&aValue count:sizeof(NUUInt8) at:anOffset];
    }
    else [[NSException exceptionWithName:@"NUNumberCoderCannotEncodeValue" reason:nil userInfo:nil] raise];
}

- (id)decodeObjectWithAliaser:(NUAliaser *)anAliaser
{
    NUUInt64 aLength = [anAliaser indexedIvarsSize];
	NSNumber *aNumber = nil;
	
	if (aLength)
	{
        char *aNumberObjCType = NULL;
        
        @try
        {
            NUUInt64 aLengthOfObjCType;
            NUUInt64 aValueByteCount;
            NUUInt64 aValueOffset;
            
            [anAliaser decodeBytes:(NUUInt8 *)&aLengthOfObjCType count:sizeof(NUUInt64)];
            aLengthOfObjCType = NSSwapBigLongLongToHost(aLengthOfObjCType);
            aNumberObjCType = malloc(aLengthOfObjCType);
            [anAliaser decodeBytes:(NUUInt8 *)aNumberObjCType count:aLengthOfObjCType at:sizeof(NUUInt64)];
            
            aValueByteCount = aLength - sizeof(NUUInt64) - aLengthOfObjCType;
            aValueOffset = sizeof(NUUInt64) + aLengthOfObjCType;
            
            if (strncmp(aNumberObjCType, @encode(unsigned char), aLengthOfObjCType) == 0)
            {
                unsigned char aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithUnsignedChar:aValue];
            }
            else if (strncmp(aNumberObjCType, @encode(char), aLengthOfObjCType) == 0)
            {
                unsigned char aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithChar:aValue];
            }
            else if (strncmp(aNumberObjCType, @encode(unsigned short), aLengthOfObjCType) == 0)
            {
                unsigned short aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithUnsignedShort:NSSwapBigShortToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(short), aLengthOfObjCType) == 0)
            {
                unsigned short aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithShort:NSSwapBigShortToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(unsigned int), aLengthOfObjCType) == 0)
            {
                unsigned int aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithUnsignedInt:NSSwapBigIntToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(int), aLengthOfObjCType) == 0)
            {
                unsigned int aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithInt:NSSwapBigIntToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(unsigned long), aLengthOfObjCType) == 0)
            {
                unsigned long aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithUnsignedLong:NSSwapBigLongToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(long), aLengthOfObjCType) == 0)
            {
                unsigned long aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithLong:NSSwapBigLongToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(unsigned long long), aLengthOfObjCType) == 0)
            {
                unsigned long long aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithUnsignedLongLong:NSSwapBigLongLongToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(long long), aLengthOfObjCType) == 0)
            {
                unsigned long long aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithLongLong:NSSwapBigLongLongToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(float), aLengthOfObjCType) == 0)
            {
                NSSwappedFloat aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithFloat:NSSwapBigFloatToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(double), aLengthOfObjCType) == 0)
            {
                NSSwappedDouble aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithDouble:NSSwapBigDoubleToHost(aValue)];
            }
            else if (strncmp(aNumberObjCType, @encode(BOOL), aLengthOfObjCType) == 0)
            {
                NUUInt8 aValue;
                [anAliaser decodeBytes:(NUUInt8 *)&aValue count:aValueByteCount at:aValueOffset];
                aNumber = [NSNumber numberWithBool:aValue];
            }
            else
            {
                [[NSException exceptionWithName:@"NUNumberCoderCannotDecodeValue" reason:nil userInfo:nil] raise];
            }
        }
        @finally
        {
            free(aNumberObjCType);
        }
	}
    
	return aNumber;
}

@end
