//
//  NUNurseryNetMessage.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/01.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

extern const NUUInt64 NUNurseryNetMessageKindUndefined;

extern const NUUInt64 NUNurseryNetMessageKindOpenSandbox;
extern const NUUInt64 NUNurseryNetMessageKindOpenSandboxResponse;

extern const NUUInt64 NUNurseryNetMessageKindCloseSandbox;
extern const NUUInt64 NUNurseryNetMessageKindCloseSandboxResponse;

extern const NUUInt64 NUNurseryNetMessageKindRootOOP;
extern const NUUInt64 NUNurseryNetMessageKindRootOOPResponse;

extern const NUUInt64 NUNurseryNetMessageKindLatestGrade;
extern const NUUInt64 NUNurseryNetMessageKindLatestGradeResponse;

extern const NUUInt64 NUNurseryNetMessageKindOlderRetainedGrade;
extern const NUUInt64 NUNurseryNetMessageKindOlderRetainedGradeResponse;

extern const NUUInt64 NUNurseryNetMessageKindRetainLatestGrade;
extern const NUUInt64 NUNurseryNetMessageKindRetainLatestGradeResponse;

extern const NUUInt64 NUNurseryNetMessageKindRetainGradeIfValid;
extern const NUUInt64 NUNurseryNetMessageKindRetainGradeIfValidResponse;

extern const NUUInt64 NUNurseryNetMessageKindRetainGrade;
extern const NUUInt64 NUNurseryNetMessageKindRetainGradeResponse;

extern const NUUInt64 NUNurseryNetMessageKindReleaseGradeLessThan;
extern const NUUInt64 NUNurseryNetMessageKindReleaseGradeLessThanResponse;

extern const NUUInt64 NUNurseryNetMessageKindCallForPupil;
extern const NUUInt64 NUNurseryNetMessageKindCallForPupilResponse;

extern const NUUInt64 NUNurseryNetMessageKindFarmOutPupils;
extern const NUUInt64 NUNurseryNetMessageKindFarmOutPupilsResponse;

@class NUNurseryNetMessageArgument;

@interface NUNurseryNetMessage : NSObject

@property (nonatomic) NUUInt64 messageKind;
@property (nonatomic, retain) NSMutableArray *arguments;
@property (nonatomic, retain) NSData *serializedData;

- (instancetype)initWithData:(NSData *)aMessageData;
- (instancetype)initWithData:(NSData *)aMessageData ofKind:(NUUInt64)aMessageKind;

+ (instancetype)message;
+ (instancetype)messageOfKind:(NUUInt64)aMessageKind;

- (void)addArgumentOfTypeUInt64WithValue:(NUUInt64)aValue;
- (void)addArgumentOfTypeBytesWithValue:(NUUInt8 *)aValue length:(NUUInt64)aLength;
- (void)addArgumentOfTypeBOOLWithValue:(BOOL)aValue;

- (void)addArgument:(NUNurseryNetMessageArgument *)anArgument;

- (NUNurseryNetMessageArgument *)argumentAt:(NUUInt64)anIndex;

- (NSData *)serialize;
- (void)serializeMessageHeaderTo:(NSMutableData *)aMessageData;
- (void)serializeMessageBodyTo:(NSMutableData *)aMessageData;
- (void)replaceMessageHeaderSizeIn:(NSMutableData *)aMessageData messageHeaderSize:(NUUInt64)aMessageHeaderSize;
- (void)replaceMessageSizeIn:(NSMutableData *)aMessageData;

- (void)deserialize;

@end
