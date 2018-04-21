//
//  NUNurseryNetService.m
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/31.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import "NUNurseryNetService.h"
#import "NUNurseryNetResponder.h"
#include <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>

NSString *NUNurseryNetServiceType = @"_nunurserynetservice._tcp.";

NSString *NUNurseryNetServiceNetworkException = @"NUNurseryNetServiceNetworkException";

const NSTimeInterval NUNurseryNetServiceRunLoopRunningTimeInterval = 0.003;

@interface NUNurseryNetService ()
{
    NUNurseryNetServiceStatus status;
}

@property (nonatomic, retain) NSNetService *netService;
@property (nonatomic, retain) NSMutableArray *netResponders;
@property (nonatomic, retain) NUMainBranchNursery *nursery;
@property (nonatomic, retain) NSString *netServiceName;
@property (nonatomic, retain) NSThread *netServiceThread;
@property (nonatomic, retain) NSLock *lock;
@property (nonatomic, retain) NSLock *statusLock;
@property (nonatomic, retain) NSCondition *statusCondition;
@property (nonatomic) int port;
@property (nonatomic, retain) NSRecursiveLock *netRespondersLock;
@property (nonatomic, retain) NSException *originatedException;

- (void)startInNewThread;
- (void)prepareListeningSocket;
- (void)prepareListeningSocketForIPv4WithSocketContext:(CFSocketContext)aSocketContext;
- (void)prepareListeningSocketForIPv6WithSocketContext:(CFSocketContext)aSocketContext;

void handleConnect(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

@end

@implementation NUNurseryNetService

+ (instancetype)netServiceWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName
{
    return [[[self alloc] initWithNursery:aNursery serviceName:aServiceName] autorelease];
}

- (instancetype)initWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName
{
    if (self = [super init])
    {
        status = NUNurseryNetServiceStatusNone;
        _statusCondition = [NSCondition new];
        _nursery = [aNursery retain];
        _netServiceName = [aServiceName copy];
        _netResponders = [NSMutableArray new];
        _netRespondersLock = [NSRecursiveLock new];
        _statusLock = [NSLock new];
        _lock = [NSLock new];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc:%@", self);
    [_netService release];
    _netService = nil;
    
    [_netServiceThread release];
    _netServiceThread = nil;
    
    [_netResponders release];
    _netResponders = nil;
    
    [_netRespondersLock release];
    _netRespondersLock = nil;
    
    [_netServiceName release];
    _netServiceName = nil;
    
    [_nursery release];
    _nursery = nil;
    
    [_originatedException release];
    _originatedException = nil;
    
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
    
    @try
    {
        if ([self status] == NUNurseryNetServiceStatusNone
            || [self status] == NUNurseryNetServiceStatusStopped)
        {
            [[self statusCondition] lock];

            NSThread *aThread = [[[NSThread alloc] initWithBlock:^{
                [self startInNewThread];
            }] autorelease];
            
            [self setNetServiceThread:aThread];
            [[self netServiceThread] setName:@"org.nursery-framework.NUNurseryNetServiceNetworking"];
            
            [[self netServiceThread] start];
            
            while ([self status] != NUNurseryNetServiceStatusRunning
                   && [self status] != NUNurseryNetServiceStatusFailed)
                [[self statusCondition] wait];
            
            [[self statusCondition] unlock];
            
            if ([self status] == NUNurseryNetServiceStatusFailed)
                @throw [NSException exceptionWithName:NUNurseryNetServiceNetworkException reason:nil userInfo:@{@"originatedException":[self originatedException]}];
        }
    }
    @finally
    {
        [[self lock] unlock];
    }
}

- (void)startInNewThread
{
    [self prepareListeningSocket];
    
    [self setNetService:[[[NSNetService alloc] initWithDomain:@"" type:NUNurseryNetServiceType name:[self netServiceName] port:[self port]] autorelease]];
    [[self netService] setDelegate:self];
    [[self netService] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [[self netService] publish];

    @try
    {
        while ([self status] != NUNurseryNetServiceStatusStopped)
        {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:NUNurseryNetServiceRunLoopRunningTimeInterval]];
            
            if ([self status] == NUNurseryNetServiceStatusShouldStop)
            {
                [self setStatus:NUNurseryNetServiceStatusStopping];
                [[self netService] stop];
            }
        }
    }
    @catch (NSException *anException)
    {
        [[self statusCondition] lock];

        [self setOriginatedException:anException];
        [self setStatus:NUNurseryNetServiceStatusFailed];
        
        [[self statusCondition] signal];
        [[self statusCondition] unlock];
    }
    @finally
    {
        [[self netService] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[self netService] setDelegate:nil];
    }
}

- (void)stop
{
    [[self lock] lock];
    
    [[self statusCondition] lock];
    
    @try
    {
        if ([self status] == NUNurseryNetServiceStatusFailed) return;

        if (![[self netServiceThread] isCancelled])
        {
            [[self netServiceThread] cancel];
            
            [self setStatus:NUNurseryNetServiceStatusShouldStop];
            
            while ([self status] != NUNurseryNetServiceStatusStopped)
                [[self statusCondition] wait];
        }
    }
    @finally
    {
        [[self statusCondition] unlock];
        
        [[self lock] unlock];
    }
}

- (NUNurseryNetServiceStatus)status
{
    [[self statusLock] lock];
    
    NUNurseryNetServiceStatus aStatus = status;
    
    [[self statusLock] unlock];
    
    return aStatus;
}

- (void)setStatus:(NUNurseryNetServiceStatus)aStatus
{
    [[self statusLock] lock];
    
    status = aStatus;
    
    [[self statusLock] unlock];
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict
{
    NSLog(@"%@", errorDict);
    @throw [NSException exceptionWithName:@"NUNurseryNetServiceDidNotPublish" reason:nil userInfo:errorDict];
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"%@", sender);
    
    [[self statusCondition] lock];
    
    [self setStatus:NUNurseryNetServiceStatusRunning];
    
    [[self statusCondition] signal];
    [[self statusCondition] unlock];
}

- (void)netServiceDidStop:(NSNetService *)sender
{
    NSLog(@"netServiceDidStop:%@", sender);
    
    [[self netRespondersLock] lock];
    
    [[self netResponders] enumerateObjectsUsingBlock:^(NUNurseryNetResponder *  _Nonnull aNetResponder, NSUInteger idx, BOOL * _Nonnull stop) {
        [aNetResponder stop];
    }];
    
    [[self netRespondersLock] unlock];
    
    while ([self status] != NUNurseryNetServiceStatusStopped)
    {
        [[self statusCondition] lock];
        
        if ([self status] == NUNurseryNetServiceStatusStopping && ![[self netResponders] count])
        {
            [self setStatus:NUNurseryNetServiceStatusStopped];
            [[self statusCondition] signal];
        }
        
        [[self statusCondition] unlock];
    }
}

- (void)prepareListeningSocket
{
    CFSocketContext aSocketContext;
    aSocketContext.copyDescription = NULL;
    aSocketContext.info = self;
    aSocketContext.release = NULL;
    aSocketContext.retain = NULL;
    aSocketContext.version = 0;
    
    [self prepareListeningSocketForIPv4WithSocketContext:aSocketContext];
    [self prepareListeningSocketForIPv6WithSocketContext:aSocketContext];
}

- (void)prepareListeningSocketForIPv4WithSocketContext:(CFSocketContext)aSocketContext
{
    CFSocketRef anIPv4CFSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, handleConnect, &aSocketContext);
    
    struct sockaddr_in aSockAddrIn;
    
    memset(&aSockAddrIn, 0, sizeof(aSockAddrIn));
    aSockAddrIn.sin_len = sizeof(aSockAddrIn);
    aSockAddrIn.sin_family = AF_INET;
    aSockAddrIn.sin_port = htons(0);
    aSockAddrIn.sin_addr.s_addr= INADDR_ANY;
    
    CFDataRef aSockAddrInData = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&aSockAddrIn, sizeof(aSockAddrIn));
    
    if (CFSocketSetAddress(anIPv4CFSocket, aSockAddrInData) != kCFSocketSuccess)
        @throw [NSException exceptionWithName:NUNurseryNetServiceNetworkException reason:NUNurseryNetServiceNetworkException userInfo:nil];
    
    CFRunLoopSourceRef aSocketRunLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, anIPv4CFSocket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), aSocketRunLoopSource, kCFRunLoopDefaultMode);

    CFRelease(aSockAddrInData);
    CFRelease(anIPv4CFSocket);
    CFRelease(aSocketRunLoopSource);
}

- (void)prepareListeningSocketForIPv6WithSocketContext:(CFSocketContext)aSocketContext
{
    CFSocketRef anIPv6CFSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET6, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, handleConnect, &aSocketContext);
    
    struct sockaddr_in6 aSockAddrIn6;
    
    memset(&aSockAddrIn6, 0, sizeof(aSockAddrIn6));
    aSockAddrIn6.sin6_len = sizeof(aSockAddrIn6);
    aSockAddrIn6.sin6_family = AF_INET6;
    aSockAddrIn6.sin6_port = htons(0);
    aSockAddrIn6.sin6_addr = in6addr_any;
    
    CFDataRef aSockAddrIn6Data = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&aSockAddrIn6, sizeof(aSockAddrIn6));
    
    if (CFSocketSetAddress(anIPv6CFSocket, aSockAddrIn6Data) != kCFSocketSuccess)
        @throw [NSException exceptionWithName:NUNurseryNetServiceNetworkException reason:NUNurseryNetServiceNetworkException userInfo:nil];
    
    CFDataRef aSocketAddressData = CFSocketCopyAddress(anIPv6CFSocket);
    struct sockaddr_in *aSockAddr = (struct sockaddr_in*)CFDataGetBytePtr(aSocketAddressData);
    
    [self setPort:ntohs(aSockAddr->sin_port)];
    
    CFRunLoopSourceRef aSocketRunLoopSource6 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, anIPv6CFSocket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), aSocketRunLoopSource6, kCFRunLoopDefaultMode);

    CFRelease(aSockAddrIn6Data);
    CFRelease(anIPv6CFSocket);
    CFRelease(aSocketRunLoopSource6);
}

void handleConnect(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    if (type != kCFSocketAcceptCallBack)
        @throw [NSException exceptionWithName:NUNurseryNetServiceNetworkException reason:NUNurseryNetServiceNetworkException userInfo:nil];
    
    NUNurseryNetService *aNurseryNetService = (NUNurseryNetService *)info;
    CFReadStreamRef aReadStream;
    CFWriteStreamRef aWriteStream;
    
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, *(CFSocketNativeHandle *)data, &aReadStream, &aWriteStream);
    
    CFReadStreamSetProperty(aReadStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    CFWriteStreamSetProperty(aWriteStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    
    NSInputStream *anInputStream = (NSInputStream *)aReadStream;
    NSOutputStream *anOutputStream = (NSOutputStream *)aWriteStream;
    
    NUNurseryNetResponder *aNetResponder = [[[NUNurseryNetResponder alloc] initWithNetService:aNurseryNetService inputStream:anInputStream outputStream:anOutputStream] autorelease];
    
    [[aNurseryNetService netResponders] addObject:aNetResponder];
    [aNetResponder start];
    
    [anInputStream release];
    [anOutputStream release];
}

- (void)netResponderDidStop:(NUNurseryNetResponder *)sender
{
    NSLog(@"netResponderDidStop:%@", sender);
    [[self netRespondersLock] lock];
    
    [[self netResponders] removeObject:sender];
    
    [[self netRespondersLock] unlock];
}

@end
