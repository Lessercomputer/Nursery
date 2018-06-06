//
//  NUNurseryNetClient.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/31.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSNetServices.h>

#import "NUNurseryNetServiceIO.h"
#import "NUGarden.h"

@class NUBranchNursery;

extern NSString *NUNurseryNetClientNetworkException;

typedef enum : NSUInteger {
    NUNurseryNetClientStatusNotStarted,
    NUNurseryNetClientStatusFindingService,
    NUNurseryNetClientStatusDidFindService,
    NUNurseryNetClientStatusResolvingService,
    NUNurseryNetClientStatusDidResolveService,
    NUNurseryNetClientStatusRunning,
    NUNurseryNetClientStatusSendingMessage,
    NUNurseryNetClientStatusDidSendMessage,
    NUNurseryNetClientStatusReceivingMessage,
    NUNurseryNetClientStatusDidReceiveMessage,
    NUNurseryNetClientStatusDidStop,
    NUNurseryNetClientStatusDidFail
} NUNurseryNetClientStatus;

@interface NUNurseryNetClient : NUNurseryNetServiceIO <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
    NUNurseryNetClientStatus status;
}

@property (nonatomic, retain) NUBranchNursery *nursery;
@property (nonatomic, retain) NSString *serviceName;
@property (nonatomic, retain) NSNetServiceBrowser *serviceBrowser;
@property (nonatomic, retain) NSNetService *netService;
@property (nonatomic, retain) NSRecursiveLock *lock;
@property (nonatomic, retain) NSLock *statusLock;
@property (nonatomic) NUNurseryNetClientStatus status;
@property (nonatomic, readonly) BOOL isFindingService;
@property (nonatomic, readonly) BOOL isNotStarted;
@property (nonatomic, readonly) BOOL isSendingMessage;
@property (nonatomic, readonly) BOOL isReceivingMessage;
@property (nonatomic, retain) NSCondition *statusCondition;

@property (nonatomic, retain) NSDate *previousCallEndDate;
@property (nonatomic) NUUInt64 callCount;
@property (nonatomic) NUUInt64 maximumFellowPupilNotesSizeInBytes;
@property (nonatomic) NUUInt64 upperLimitForMaximumFellowPupilNotesSizeInBytes;
@property (nonatomic) NUUInt64 lowerLimitForMaximumFellowPupilNotesSizeInBytes;
@property (nonatomic) NUUInt64 maximumTimeIntervalOfContinuation;
@property (nonatomic) NUUInt64 totalCallCount;

- (instancetype)initWithServiceName:(NSString *)aServiceName;

- (void)start;
- (void)startInNewThread;
- (void)findNetService;
- (void)resolveNetService;
- (void)getStreams;
- (void)runUntileCancel;
- (void)stop;

- (void)sendMessage:(NUNurseryNetMessage *)aSendingMessage;
- (void)sendAndReceiveMessage:(NUNurseryNetMessage *)aSendingMessage;

@end

@interface NUNurseryNetClient (MessagingToNetService)

- (NUUInt64)openGarden;
- (void)closeGardenWithID:(NUUInt64)anID;

- (NUUInt64)rootOOPForGardenWithID:(NUUInt64)anID;

- (NUUInt64)latestGrade;
- (NUUInt64)olderRetainedGrade;
- (NUUInt64)retainLatestGradeByGardenWithID:(NUUInt64)anID;
- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade byGardenWithID:(NUUInt64)anID;
- (void)retainGrade:(NUUInt64)aGrade byGardenWithID:(NUUInt64)anID;
- (void)releaseGradeLessThan:(NUUInt64)aGrade byGardenWithID:(NUUInt64)anID;

- (NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade gardenWithID:(NUUInt64)anID containsFellowPupils:(BOOL)aContainsFellowPupils;
- (NUFarmOutStatus)farmOutPupils:(NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP gardenWithID:(NUUInt64)anID fixedOOPs:(NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade;

- (void)netClientWillStop;

@end
