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

- (void)startInNewThread;
- (void)prepareListeningSocket;

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
        _status = NUNurseryNetServiceStatusNone;
        _statusCondition = [NSCondition new];
        _nursery = [aNursery retain];
        _serviceName = [aServiceName copy];
        _netResponders = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [_netResponders release];
    [_serviceName release];
    [_nursery release];
    [_statusCondition release];
    
    [super dealloc];
}

- (void)start
{
    NSThread *aThread = [[[NSThread alloc] initWithTarget:self selector:@selector(startInNewThread) object:nil] autorelease];
    [self setNetServiceThread:aThread];
    [[self netServiceThread] setName:@"org.nursery-framework.NUNurseryNetServiceNetworking"];
    
    [[self netServiceThread] start];
    
    [[self statusCondition] lock];
    
    while ([self status] != NUNurseryNetServiceStatusRunning)
        [[self statusCondition] wait];
    
    [[self statusCondition] unlock];
}

- (void)startInNewThread
{
    [self prepareListeningSocket];
    
    [self setNetService:[[[NSNetService alloc] initWithDomain:@"" type:NUNurseryNetServiceType name:[self serviceName] port:[self port]] autorelease]];
    [[self netService] setDelegate:self];
    [[self netService] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [[self netService] publish];

    while (YES)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:NUNurseryNetServiceRunLoopRunningTimeInterval]];
}

- (void)stop
{
    [[self netService] stop];
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict
{
    NSLog(@"%@", errorDict);
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"%@", sender);
    
    [[self statusCondition] lock];
    
    [self setStatus:NUNurseryNetServiceStatusRunning];
    
    [[self statusCondition] signal];
    [[self statusCondition] unlock];
}

- (void)prepareListeningSocket
{
    CFSocketContext aSocketContext;
    aSocketContext.copyDescription = NULL;
    aSocketContext.info = self;
    aSocketContext.release = NULL;
    aSocketContext.retain = NULL;
    aSocketContext.version = 0;
    
    CFSocketRef anIPv4CFSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, handleConnect, &aSocketContext);
    CFSocketRef anIPv6CFSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET6, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, handleConnect, &aSocketContext);
    
    struct sockaddr_in aSockAddrIn;
    
    memset(&aSockAddrIn, 0, sizeof(aSockAddrIn));
    aSockAddrIn.sin_len = sizeof(aSockAddrIn);
    aSockAddrIn.sin_family = AF_INET;
    aSockAddrIn.sin_port = htons(0);
    aSockAddrIn.sin_addr.s_addr= INADDR_ANY;
    
    CFDataRef aSockAddrInData = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&aSockAddrIn, sizeof(aSockAddrIn));
    
    if (CFSocketSetAddress(anIPv4CFSocket, aSockAddrInData) != kCFSocketSuccess)
        @throw [NSException exceptionWithName:NUNurseryNetServiceNetworkException reason:NUNurseryNetServiceNetworkException userInfo:nil];
    
    CFRelease(aSockAddrInData);
    
    struct sockaddr_in6 aSockAddrIn6;
    
    memset(&aSockAddrIn6, 0, sizeof(aSockAddrIn6));
    aSockAddrIn6.sin6_len = sizeof(aSockAddrIn6);
    aSockAddrIn6.sin6_family = AF_INET6;
    aSockAddrIn6.sin6_port = htons(0);
    aSockAddrIn6.sin6_addr = in6addr_any;
    
    CFDataRef aSockAddrIn6Data = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&aSockAddrIn6, sizeof(aSockAddrIn6));
    
    if (CFSocketSetAddress(anIPv6CFSocket, aSockAddrIn6Data) != kCFSocketSuccess)
        @throw [NSException exceptionWithName:NUNurseryNetServiceNetworkException reason:NUNurseryNetServiceNetworkException userInfo:nil];
    
    CFRelease(aSockAddrIn6Data);
    
    CFDataRef               aSocketAddressData = CFSocketCopyAddress(anIPv6CFSocket);
    struct sockaddr_in      *aSockAddr = (struct sockaddr_in*)CFDataGetBytePtr(aSocketAddressData);
    
    [self setPort:ntohs(aSockAddr->sin_port)];
    
    CFRunLoopSourceRef aSocketRunLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, anIPv4CFSocket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), aSocketRunLoopSource, kCFRunLoopDefaultMode);
    
    CFRunLoopSourceRef aSocketRunLoopSource6 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, anIPv6CFSocket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), aSocketRunLoopSource6, kCFRunLoopDefaultMode);
}

void handleConnect(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    NSLog(@"handleConnect");
    NSLog(@"currentMode:%@", [[NSRunLoop currentRunLoop] currentMode]);
    
    if (type != kCFSocketAcceptCallBack)
        @throw [NSException exceptionWithName:NUNurseryNetServiceNetworkException reason:NUNurseryNetServiceNetworkException userInfo:nil];
    
    NUNurseryNetService *aNurseryNetService = (NUNurseryNetService *)info;
    CFReadStreamRef aReadStream;
    CFWriteStreamRef aWriteStream;
    
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, *(CFSocketNativeHandle *)data, &aReadStream, &aWriteStream);
    
    NSInputStream *anInputStream = (NSInputStream *)aReadStream;
    NSOutputStream *anOutputStream = (NSOutputStream *)aWriteStream;
    
    NUNurseryNetResponder *aNetResponder = [[[NUNurseryNetResponder alloc] initWithNetService:aNurseryNetService inputStream:anInputStream outputStream:anOutputStream] autorelease];
    
    [[aNurseryNetService netResponders] addObject:aNetResponder];
    [aNetResponder start];
    
    [anInputStream release];
    [anOutputStream release];
}

@end
