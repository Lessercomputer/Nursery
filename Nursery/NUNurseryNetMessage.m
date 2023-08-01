//
//  NUNurseryNetMessage.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/01.
//

#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSByteOrder.h>

#import "NUNurseryNetMessage.h"
#import "NUNurseryNetMessageArgument.h"

const NUUInt64 NUNurseryNetMessageKindUndefined = 0;

const NUUInt64 NUNurseryNetMessageKindOpenGarden = 1;
const NUUInt64 NUNurseryNetMessageKindOpenGardenResponse = 2;

const NUUInt64 NUNurseryNetMessageKindCloseGarden = 3;
const NUUInt64 NUNurseryNetMessageKindCloseGardenResponse = 4;

const NUUInt64 NUNurseryNetMessageKindRootOOP = 5;
const NUUInt64 NUNurseryNetMessageKindRootOOPResponse = 6;

const NUUInt64 NUNurseryNetMessageKindLatestGrade = 7;
const NUUInt64 NUNurseryNetMessageKindLatestGradeResponse = 8;

const NUUInt64 NUNurseryNetMessageKindOlderRetainedGrade = 9;
const NUUInt64 NUNurseryNetMessageKindOlderRetainedGradeResponse = 10;

const NUUInt64 NUNurseryNetMessageKindRetainLatestGrade = 11;
const NUUInt64 NUNurseryNetMessageKindRetainLatestGradeResponse = 12;

const NUUInt64 NUNurseryNetMessageKindRetainGradeIfValid = 13;
const NUUInt64 NUNurseryNetMessageKindRetainGradeIfValidResponse = 14;

const NUUInt64 NUNurseryNetMessageKindRetainGrade = 15;
const NUUInt64 NUNurseryNetMessageKindRetainGradeResponse = 16;

const NUUInt64 NUNurseryNetMessageKindReleaseGradeLessThan = 17;
const NUUInt64 NUNurseryNetMessageKindReleaseGradeLessThanResponse = 18;

const NUUInt64 NUNurseryNetMessageKindCallForPupil = 19;
const NUUInt64 NUNurseryNetMessageKindCallForPupilResponse = 20;

const NUUInt64 NUNurseryNetMessageKindFarmOutPupils = 21;
const NUUInt64 NUNurseryNetMessageKindFarmOutPupilsResponse = 22;

const NUUInt64 NUNurseryNetMessageKindNetClientWillStop = 23;
const NUUInt64 NUNurseryNetMessageKindNetClientWillStopResponse = 24;

@implementation NUNurseryNetMessage

- (instancetype)init
{
    return [self initWithData:nil ofKind:NUNurseryNetMessageKindUndefined];
}

- (instancetype)initWithData:(NSData *)aMessageData
{
    return [self initWithData:aMessageData ofKind:NUNurseryNetMessageKindUndefined];
}

- (instancetype)initWithData:(NSData *)aMessageData ofKind:(NUUInt64)aMessageKind
{
    if (self = [super init])
    {
        _messageKind = aMessageKind;
        _arguments = [NSMutableArray new];
        _serializedData = [aMessageData retain];
    }
    
    return self;
}

+ (instancetype)message
{
    return [self messageOfKind:NUNurseryNetMessageKindOpenGarden];
}

+ (instancetype)messageOfKind:(NUUInt64)aMessageKind
{
    return [[[self alloc] initWithData:nil ofKind:aMessageKind] autorelease];
}

- (void)dealloc
{
    [_arguments release];
    [_serializedData release];
    
    [super dealloc];
}

- (void)addArgumentOfTypeUInt64WithValue:(NUUInt64)aValue
{
    [self addArgument:[NUNurseryNetMessageArgument argumentWithUInt64:aValue]];
}

- (void)addArgumentOfTypeBytesWithValue:(NUUInt8 *)aValue length:(NUUInt64)aLength
{
    [self addArgument:[NUNurseryNetMessageArgument argumentWithBytes:aValue length:aLength]];
}

- (void)addArgumentOfTypeBOOLWithValue:(BOOL)aValue
{
    [self addArgument:[NUNurseryNetMessageArgument argumentWithBOOL:aValue]];
}

- (void)addArgument:(NUNurseryNetMessageArgument *)anArgument
{
    [[self arguments] addObject:anArgument];
}

- (NUNurseryNetMessageArgument *)argumentAt:(NUUInt64)anIndex;
{
    return [[self arguments] objectAtIndex:(NSUInteger)anIndex];
}

- (NSData *)serialize
{
    NSMutableData *aMessageData = [NSMutableData data];
    
    [self serializeMessageHeaderTo:aMessageData];
    [self serializeMessageBodyTo:aMessageData];
    [self replaceMessageSizeIn:aMessageData];
    
    [self setSerializedData:aMessageData];
    
    return [self serializedData];
}

- (void)serializeMessageHeaderTo:(NSMutableData *)aMessageData
{
    NUUInt64 aMessageKind = [self messageKind];
    NUUInt64 aMessageArgumentCount = [[self arguments] count];
    __block NUUInt64 aMessageHeaderSize = 0;
    
    [aMessageData increaseLengthBy:sizeof(NUUInt64)];
    aMessageHeaderSize += sizeof(NUUInt64);
    
    aMessageKind = NSSwapHostLongLongToBig(aMessageKind);
    [aMessageData appendBytes:&aMessageKind length:sizeof(NUUInt64)];
    aMessageHeaderSize += sizeof(NUUInt64);
    
    [aMessageData increaseLengthBy:sizeof(NUUInt64)];
    aMessageHeaderSize += sizeof(NUUInt64);
    
    aMessageArgumentCount = NSSwapHostLongLongToBig(aMessageArgumentCount);
    [aMessageData appendBytes:&aMessageArgumentCount length:sizeof(NUUInt64)];
    aMessageHeaderSize += sizeof(NUUInt64);
    
    [[self arguments] enumerateObjectsUsingBlock:^(NUNurseryNetMessageArgument * _Nonnull anArgument, NSUInteger anIndex, BOOL * _Nonnull aStop) {
        
        NUUInt64 anArgumentType = [anArgument argumentType];
        anArgumentType = NSSwapHostLongLongToBig(anArgumentType);
        [aMessageData appendBytes:&anArgumentType  length:sizeof(NUUInt64)];
        aMessageHeaderSize += sizeof(NUUInt64);
        
        if ([anArgument argumentType] == NUNurseryNetMessageArgumentTypeBytes)
        {
            NUUInt64 aBytesLength = [[anArgument dataFromValue] length];
            aBytesLength = NSSwapHostLongLongToBig(aBytesLength);
            [aMessageData appendBytes:&aBytesLength length:sizeof(NUUInt64)];
            aMessageHeaderSize += sizeof(NUUInt64);
        }
    }];
    
    [self replaceMessageHeaderSizeIn:aMessageData messageHeaderSize:aMessageHeaderSize];
}

- (void)serializeMessageBodyTo:(NSMutableData *)aMessageData
{
    [[self arguments] enumerateObjectsUsingBlock:^(NUNurseryNetMessageArgument * _Nonnull anArgument, NSUInteger anIndex, BOOL * _Nonnull aStop) {
        
        if ([anArgument argumentType] == NUNurseryNetMessageArgumentTypeUInt64)
        {
            NUUInt64 aValue = [anArgument UInt64FromValue];
            aValue = NSSwapHostLongLongToBig(aValue);
            [aMessageData appendBytes:&aValue  length:sizeof(NUUInt64)];
        }
        else if ([anArgument argumentType] == NUNurseryNetMessageArgumentTypeBytes)
        {
            [aMessageData appendData:[anArgument dataFromValue]];
        }
        else if ([anArgument argumentType] == NUNurseryNetMessageArgumentTypeBOOL)
        {
            BOOL aBOOLValue = [anArgument BOOLFromValue];
            NUUInt64 aValue = aBOOLValue ? 1 : 0;
            aValue = NSSwapHostLongLongToBig(aValue);
            [aMessageData appendBytes:&aValue length:sizeof(NUUInt64)];
        }
    }];
}

-(void)replaceMessageHeaderSizeIn:(NSMutableData *)aMessageData messageHeaderSize:(NUUInt64)aMessageHeaderSize
{
    aMessageHeaderSize = NSSwapBigLongLongToHost(aMessageHeaderSize);
    [aMessageData replaceBytesInRange:NSMakeRange(sizeof(NUUInt64) * 2, sizeof(NUUInt64)) withBytes:&aMessageHeaderSize];
}

- (void)replaceMessageSizeIn:(NSMutableData *)aMessageData
{
    NUUInt64 aMessageSize = NSSwapHostLongLongToBig([aMessageData length]);
    [aMessageData replaceBytesInRange:NSMakeRange(0, sizeof(NUUInt64)) withBytes:&aMessageSize];
}

- (void)deserialize
{
    NSData *aMessageData = [self serializedData];
    __block NUUInt64 anOffsetOfMessageHeaderInMessageData = 0;
    NUUInt64 anOffsetOfMessageArgumentValueInMessageData;
    NUUInt64 aMessageSize;
    NUUInt64 aMessageKind;
    NUUInt64 aMessageHeaderSize;
    NUUInt64 anArgumentCount;

    void (^aReadUInt64ValueFromMessageData)(NUUInt64 *, NUUInt64 *) = ^(NUUInt64 *aBuffer, NUUInt64 *anOffset)
    {
        [aMessageData getBytes:aBuffer range:NSMakeRange((NSUInteger)*anOffset, sizeof(NUUInt64))];
        *anOffset += sizeof(NUUInt64);
        *aBuffer = NSSwapBigLongLongToHost(*aBuffer);
    };
    
    aReadUInt64ValueFromMessageData(&aMessageSize, &anOffsetOfMessageHeaderInMessageData);
    aReadUInt64ValueFromMessageData(&aMessageKind, &anOffsetOfMessageHeaderInMessageData);
    aReadUInt64ValueFromMessageData(&aMessageHeaderSize, &anOffsetOfMessageHeaderInMessageData);
    aReadUInt64ValueFromMessageData(&anArgumentCount, &anOffsetOfMessageHeaderInMessageData);
    
    [self setMessageKind:aMessageKind];;
    
    anOffsetOfMessageArgumentValueInMessageData = aMessageHeaderSize;

    for (NUUInt64 i = 0; i < anArgumentCount; i++)
    {
        NUUInt64 anArgumentType;
        aReadUInt64ValueFromMessageData(&anArgumentType, &anOffsetOfMessageHeaderInMessageData);
        
        if (anArgumentType == NUNurseryNetMessageArgumentTypeUInt64)
        {
            NUUInt64 anArgumentValue;
            aReadUInt64ValueFromMessageData(&anArgumentValue, &anOffsetOfMessageArgumentValueInMessageData);
            
            [self addArgument:[NUNurseryNetMessageArgument argumentWithUInt64:anArgumentValue]];
        }
        else if (anArgumentType == NUNurseryNetMessageArgumentTypeBytes)
        {
            NUUInt64 anArgumentValueLength;
            aReadUInt64ValueFromMessageData(&anArgumentValueLength, &anOffsetOfMessageHeaderInMessageData);
            
            NUNurseryNetMessageArgument *anArgument = [NUNurseryNetMessageArgument argumentWithBytes:(void *)&[aMessageData bytes][anOffsetOfMessageArgumentValueInMessageData] length:anArgumentValueLength];
            anOffsetOfMessageArgumentValueInMessageData += anArgumentValueLength;
            
            [self addArgument:anArgument];
        }
        else if (anArgumentType == NUNurseryNetMessageArgumentTypeBOOL)
        {
            NUUInt64 anArgumentValue;
            aReadUInt64ValueFromMessageData(&anArgumentValue, &anOffsetOfMessageArgumentValueInMessageData);
            
            [self addArgument:[NUNurseryNetMessageArgument argumentWithBOOL:anArgumentValue ? YES : NO]];
        }
    }
}

@end
