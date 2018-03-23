//
//  NUNurseryNetClient.m
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/31.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import "NUNurseryNetClient.h"
#import "NUNurseryNetService.h"
#import "NUNurseryNetMessage.h"
#import "NUNurseryNetMessageArgument.h"
#import "NUBranchNursery.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>

const NUUInt64 NUNurseryNetClientReadBufferSize = 4096;
const NSTimeInterval NUNurseryNetClientRunLoopRunningTimeInterval = 0.003;


@implementation NUNurseryNetClient

- (instancetype)initWithServiceName:(NSString *)aServiceName
{
    if (self = [super init])
    {
        _lock = [NSRecursiveLock new];
        _statusLock = [NSLock new];
        _statusCondition = [NSCondition new];
        _serviceName = [aServiceName copy];
    }
    
    return self;
}

- (NUNurseryNetClientStatus)status
{
    [[self statusLock] lock];
    
    NUNurseryNetClientStatus aStatus = status;
    
    [[self statusLock] unlock];
    
    return aStatus;
}

- (void)setStatus:(NUNurseryNetClientStatus)aStatus
{
    [[self statusLock] lock];
    status = aStatus;
//    NSLog(@"status:%@", @(status));
    [[self statusLock] unlock];
}

- (BOOL)isNotStarted
{
    return [self status] == NUNurseryNetClientStatusNotStarted;
}

- (BOOL)isFindingService
{
    return [self status] == NUNurseryNetClientStatusFindingService;
}

- (BOOL)isSendingMessage
{
    return [self status] == NUNurseryNetClientStatusSendingMessage;
}

- (BOOL)isReceivingMessage
{
    return [self status] == NUNurseryNetClientStatusReceivingMessage;
}

- (void)dealloc
{
    [_netService release];
    _netService = nil;
    [_serviceBrowser release];
    _serviceBrowser = nil;
    [_serviceName release];
    _serviceName = nil;
    [_nursery release];
    _nursery = nil;
    [_statusCondition release];
    _statusCondition = nil;
    [_statusLock release];
    _statusLock = nil;
    [_lock release];
    _lock = nil;
    
    [super dealloc];
}


- (void)start
{
    [[self lock] lock];
    
    [[self statusCondition] lock];
    
    NSThread *aThread = [[[NSThread alloc] initWithTarget:self selector:@selector(startInNewThread:) object:nil] autorelease];
    [aThread setName:@"org.nursery-framework.NUNurseryNetClientNetworking"];
    [self setThread:aThread];
    [aThread start];
    
    while ([self isNotStarted])
        [[self statusCondition] wait];
    
    [[self statusCondition] unlock];
    
    [[self lock] unlock];
}

- (void)startInNewThread:(id)anObject
{
    [[self statusCondition] lock];
    
    [self setServiceBrowser:[[NSNetServiceBrowser new] autorelease]];
    [[self serviceBrowser] setDelegate:self];

    [self setStatus:NUNurseryNetClientStatusFindingService];
    [[self serviceBrowser] searchForServicesOfType:NUNurseryNetServiceType inDomain:@""];
    
    while ([self status] != NUNurseryNetClientStatusDidFindService)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:NUNurseryNetClientRunLoopRunningTimeInterval]];
    
    [self setStatus:NUNurseryNetClientStatusResolvingService];
    [[self netService] setDelegate:self];
    [[self netService] resolveWithTimeout:0];
    
    while ([self status] != NUNurseryNetClientStatusDidResolveService)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:NUNurseryNetClientRunLoopRunningTimeInterval]];

    CFHostRef aHost = CFHostCreateWithName(kCFAllocatorDefault, (CFStringRef)[[self netService] hostName]);
    CFReadStreamRef aReadStream;
    CFWriteStreamRef aWriteStream;
    NSInputStream *anInputStream;
    NSOutputStream *anOutputStream;
    
    CFStreamCreatePairWithSocketToCFHost(kCFAllocatorDefault, aHost, (SInt)[[self netService] port], &aReadStream, &aWriteStream);
    
    CFReadStreamSetProperty(aReadStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    CFWriteStreamSetProperty(aWriteStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    
    anInputStream = (NSInputStream *)aReadStream;
    anOutputStream = (NSOutputStream *)aWriteStream;
    
    [self setInputStream:anInputStream];
    
    [self setOutputStream:anOutputStream];
    
    [[self inputStream] open];
    [[self outputStream] open];
    
    [self setStatus:NUNurseryNetClientStatusRunning];
    
    [[self statusCondition] signal];
    [[self statusCondition] unlock];
    
    while (![[self thread] isCancelled])
    {
        [NSThread sleepForTimeInterval:0.001];
        
        [[self statusCondition] lock];
        
        switch ([self status])
        {
            case NUNurseryNetClientStatusSendingMessage:
              
                if ([[self outputStream] hasSpaceAvailable])
                    [self sendMessageOnStream];
                
                break;
                
            case NUNurseryNetClientStatusReceivingMessage:
                
                if ([[self inputStream] hasBytesAvailable])
                    [self receiveMessageOnStream];
                
                break;
                
            case NUNurseryNetClientStatusDidSendMessage:
            
                break;
                
            case NUNurseryNetClientStatusDidReceiveMessage:
                
                break;
                
            default:
                break;
        }
        
        if (!([self isSendingMessage] || [self isReceivingMessage]))
            [[self statusCondition] signal];
        
        [[self statusCondition] unlock];
    }
    
    [[self inputStream] close];
    [[self outputStream] close];
    
    [[self statusCondition] lock];
    
    [self setStatus:NUNurseryNetClientStatusDidStop];
    
    [[self statusCondition] unlock];
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser
           didFindService:(NSNetService *)aService
               moreComing:(BOOL)aMoreComing
{
    NSLog(@"browser:%@\nservice:%@", aBrowser, aService);

    NSLog(@"name:%@", [aService name]);
    NSLog(@"host name:%@", [aService hostName]);
    
    if (!aMoreComing)
    {
        [aBrowser stop];
        
        [[self serviceBrowser] setDelegate:nil];;
        [[self serviceBrowser] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [self setNetService:aService];
        [self setStatus:NUNurseryNetClientStatusDidFindService];
    }
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSLog(@"%@", [[self netService] hostName]);
    
    [[self netService] stop];
    [[self netService] setDelegate:nil];
    
    [self setStatus:NUNurseryNetClientStatusDidResolveService];
}

- (void)streamDidOpen:(NSStream *)aStream
{
//    if (aStream == [self outputStream])
//    {
//        CFSocketContext aSocketContext;
//        memset(&aSocketContext, 0, sizeof(aSocketContext));
//        aSocketContext.info = (void *)self;
//
//        CFDataRef aSocketData = CFWriteStreamCopyProperty((CFWriteStreamRef)[self outputStream], kCFStreamPropertySocketNativeHandle);
//
//        CFSocketNativeHandle aHandle;
//        CFDataGetBytes(aSocketData, CFRangeMake(0, sizeof(CFSocketNativeHandle)), (UInt8 *)&aHandle);
//
////        CFSocketRef aSocket = CFSocketCreateWithNative(NULL, aHandle, kCFSocketNoCallBack, nil, &aSocketContext);
//
//        int aYes = 1;
//        int aResult = setsockopt(aHandle, IPPROTO_TCP, TCP_NODELAY, (void *)&aYes, sizeof(aYes));
//        NSLog(@"setsockopt:%@", @(aResult));
//    }
}

- (void)startIfNeeded
{
    [[self lock] lock];
    
    if ([self isNotStarted])
        [self start];
    
    [[self lock] unlock];
}

- (void)stop
{
    [[self lock] lock];
    [[self thread] cancel];
    
    [[self statusCondition] lock];
    
    while ([self status] == NUNurseryNetClientStatusDidStop)
        [[self statusCondition] wait];
    
    [[self statusCondition] unlock];
    
    [[self lock] unlock];
}

- (void)sendMessage:(NUNurseryNetMessage *)aSendingMessage
{
    [[self statusCondition] lock];
    
    [aSendingMessage serialize];
    [self setSendingMessage:aSendingMessage];
    [self setStatus:NUNurseryNetClientStatusSendingMessage];
    
    [[self statusCondition] signal];
    [[self statusCondition] unlock];
    
    [[self statusCondition] lock];
    
    while ([self isSendingMessage])
        [[self statusCondition] wait];
    
    [[self statusCondition] unlock];
}

- (void)messageDidSend
{
    [self setStatus:NUNurseryNetClientStatusDidSendMessage];
}

- (void)receiveMessage
{
//    NSLog(@"receiveMessage, %@", self);
    
    [[self statusCondition] lock];
    
    [self setStatus:NUNurseryNetClientStatusReceivingMessage];
    
    [[self statusCondition] signal];
    [[self statusCondition] unlock];
    
    [[self statusCondition] lock];
    
    while ([self isReceivingMessage])
        [[self statusCondition] wait];
    
    [[self statusCondition] unlock];
}

- (void)messageDidReceive
{
    [self setStatus:NUNurseryNetClientStatusDidReceiveMessage];
}

- (void)sendAndReceiveMessage:(NUNurseryNetMessage *)aSendingMessage
{
    [self sendMessage:aSendingMessage];
    [self receiveMessage];
}

- (NUUInt64)openSandbox
{
//    NSLog(@"openSandbox");
    NUUInt64 aPairID = 0;
    
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindOpenSandbox];
    
    [self sendAndReceiveMessage:aMessage];
    
    aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    
    [[self lock] unlock];
    
    return aPairID;
}

- (void)closeSandboxWithID:(NUUInt64)anID
{
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindCloseSandbox];
    
    [aMessage addArgumentOfTypeUInt64WithValue:anID];
    
    [self sendAndReceiveMessage:aMessage];
    
    [[self lock] unlock];
}

- (NUUInt64)rootOOPForSandboxWithID:(NUUInt64)anID
{
//    NSLog(@"rootOOPForSandboxWithID");
    NUUInt64 aRootOOP = 0;
    
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRootOOP];
    
    [aMessage addArgumentOfTypeUInt64WithValue:anID];
    
    [self sendAndReceiveMessage:aMessage];
    
    aRootOOP = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    
    [[self lock] unlock];

    return aRootOOP;
}

- (NUUInt64)latestGrade
{
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindLatestGrade];
    
    [self sendAndReceiveMessage:aMessage];
    
    NUUInt64 aLatestGrade = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    
    [[self lock] unlock];
    
    return aLatestGrade;
}

- (NUUInt64)olderRetainedGrade
{
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindOlderRetainedGrade];
    
    [self sendAndReceiveMessage:aMessage];
    
    NUUInt64 anOlderRetainedGrade = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    
    [[self lock] unlock];
    
    return anOlderRetainedGrade;
}

- (NUUInt64)retainLatestGradeBySandboxWithID:(NUUInt64)anID
{
    NUUInt64 aGrade;
    
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainLatestGrade];
    
    [aMessage addArgumentOfTypeUInt64WithValue:anID];
    
    [self sendAndReceiveMessage:aMessage];
    
    aGrade = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    
    [[self lock] unlock];
    
    return aGrade;
}

- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID
{
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainGradeIfValid];
    
    [aMessage addArgumentOfTypeUInt64WithValue:aGrade];
    [aMessage addArgumentOfTypeUInt64WithValue:anID];
    
    [self sendAndReceiveMessage:aMessage];
    
    NUUInt64 aRetainedGradeOrNilGrade = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    
    [[self lock] unlock];
    
    return aRetainedGradeOrNilGrade;
}

- (void)retainGrade:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID
{
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainGrade];
    
    [aMessage addArgumentOfTypeUInt64WithValue:aGrade];
    [aMessage addArgumentOfTypeUInt64WithValue:anID];

    [self sendAndReceiveMessage:aMessage];
    
    [[self lock] unlock];
}

- (void)releaseGradeLessThan:(NUUInt64)aGrade bySandboxWithID:(NUUInt64)anID
{
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindReleaseGradeLessThan];
    
    [aMessage addArgumentOfTypeUInt64WithValue:aGrade];
    [aMessage addArgumentOfTypeUInt64WithValue:anID];
    
    [self sendAndReceiveMessage:aMessage];
    
    [[self lock] unlock];
}

- (NSData *)callForPupilWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade sandboxWithID:(NUUInt64)anID containsFellowPupils:(BOOL)aContainsFellowPupils
{
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindCallForPupil];
    
    [aMessage addArgumentOfTypeUInt64WithValue:anOOP];
    [aMessage addArgumentOfTypeUInt64WithValue:aGrade];
    [aMessage addArgumentOfTypeUInt64WithValue:anID];
    [aMessage addArgumentOfTypeBOOLWithValue:aContainsFellowPupils];
    
    [self sendAndReceiveMessage:aMessage];
    
    NSData *aPupilsData = [[[self receivedMessage] argumentAt:0] dataFromValue];
    
    [[self lock] unlock];
    
    return aPupilsData;
}

- (NUFarmOutStatus)farmOutPupils:(NSData *)aPupilData rootOOP:(NUUInt64)aRootOOP sandboxWithID:(NUUInt64)anID fixedOOPs:(NSData **)aFixedOOPs latestGrade:(NUUInt64 *)aLatestGrade
{
    [[self lock] lock];
    
    NUNurseryNetMessage *aMessage = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindFarmOutPupils];
    
    [aMessage addArgumentOfTypeBytesWithValue:(void *)[aPupilData bytes] length:[aPupilData length]];
    [aMessage addArgumentOfTypeUInt64WithValue:aRootOOP];
    [aMessage addArgumentOfTypeUInt64WithValue:anID];
    
    [self sendAndReceiveMessage:aMessage];
    
    NUFarmOutStatus aStatus = (NUFarmOutStatus)[[[self receivedMessage] argumentAt:0] UInt64FromValue];
    
    *aFixedOOPs = [[[self receivedMessage] argumentAt:1] dataFromValue];
    *aLatestGrade = [[[self receivedMessage] argumentAt:2] UInt64FromValue];
    
    [[self lock] unlock];
    
    return aStatus;
}

@end

