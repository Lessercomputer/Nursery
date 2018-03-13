//
//  NUNurseryNetClient.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/31.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import "NUNurseryNetServiceIO.h"
#import "NUSandbox.h"

@class NUBranchNursery;

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
    NUNurseryNetClientStatusDidStop
} NUNurseryNetClientStatus;

@interface NUNurseryNetClient : NUNurseryNetServiceIO <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
    NUNurseryNetClientStatus status;
    BOOL shouldStop;
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
@property (nonatomic) BOOL outputStreamIsScheduled;
@property (nonatomic) BOOL inputStreamIsScheduled;
@property (nonatomic) BOOL shouldStop;
@property (nonatomic, retain) NSRecursiveLock *shouldStopLock;

- (instancetype)initWithServiceName:(NSString *)aServiceName;

- (void)start;
- (void)stop;

- (void)startIfNeeded;

- (void)sendMessage:(NUNurseryNetMessage *)aSendingMessage;
- (void)sendAndReceiveMessage:(NUNurseryNetMessage *)aSendingMessage;

- (NUUInt64)openSandbox;
- (void)closeSandboxWithID:(NUUInt64)anID;

- (NUUInt64)rootOOPForSandboxWithID:(NUUInt64)anID;

- (NUUInt64)latestGrade;
- (NUUInt64)olderRetainedGrade;
- (NUUInt64)retainLatestGradeBySandboxWithID:(NUUInt64)anID;
- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID;
- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID;
- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID;

- (NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade sandboxWithID:(NUUInt64)anID containsFellowPupils:(BOOL)aContainsFellowPupils;
- (NUFarmOutStatus)farmOutPupils:(NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP sandboxWithID:(NUUInt64)anID fixedOOPs:(NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade;

@end
