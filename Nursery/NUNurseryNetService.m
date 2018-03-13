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
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.003]];
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
    
    CFSocketRef myipv4cfsock = CFSocketCreate(
                                              kCFAllocatorDefault,
                                              PF_INET,
                                              SOCK_STREAM,
                                              IPPROTO_TCP,
                                              kCFSocketAcceptCallBack, handleConnect, &aSocketContext);
    CFSocketRef myipv6cfsock = CFSocketCreate(
                                              kCFAllocatorDefault,
                                              PF_INET6,
                                              SOCK_STREAM,
                                              IPPROTO_TCP,
                                              kCFSocketAcceptCallBack, handleConnect, &aSocketContext);
    
    struct sockaddr_in sin;
    
    memset(&sin, 0, sizeof(sin));
    sin.sin_len = sizeof(sin);
    sin.sin_family = AF_INET;
    sin.sin_port = htons(0);
    sin.sin_addr.s_addr= INADDR_ANY;
    
    CFDataRef sincfd = CFDataCreate(
                                    kCFAllocatorDefault,
                                    (UInt8 *)&sin,
                                    sizeof(sin));
    
    if (CFSocketSetAddress(myipv4cfsock, sincfd) != kCFSocketSuccess)
        NSLog(@"%@", @"!kCFSocketSuccess");
    
    CFRelease(sincfd);
    
    struct sockaddr_in6 sin6;
    
    memset(&sin6, 0, sizeof(sin6));
    sin6.sin6_len = sizeof(sin6);
    sin6.sin6_family = AF_INET6;
    sin6.sin6_port = htons(0);
    sin6.sin6_addr = in6addr_any;
    
    CFDataRef sin6cfd = CFDataCreate(
                                     kCFAllocatorDefault,
                                     (UInt8 *)&sin6,
                                     sizeof(sin6));
    
    if (CFSocketSetAddress(myipv6cfsock, sin6cfd) != kCFSocketSuccess)
        NSLog(@"%@", @"!kCFSocketSuccess");
    CFRelease(sin6cfd);
    
    CFDataRef               dataRef = CFSocketCopyAddress(myipv6cfsock);
    struct sockaddr_in      *sockaddr = (struct sockaddr_in*)CFDataGetBytePtr(dataRef);
    
    [self setPort:ntohs(sockaddr->sin_port)];
    
    CFRunLoopSourceRef socketsource = CFSocketCreateRunLoopSource(
                                                                  kCFAllocatorDefault,
                                                                  myipv4cfsock,
                                                                  0);
    
    CFRunLoopAddSource(
                       CFRunLoopGetCurrent(),
                       socketsource,
                       kCFRunLoopDefaultMode);
    
    CFRunLoopSourceRef socketsource6 = CFSocketCreateRunLoopSource(
                                                                   kCFAllocatorDefault,
                                                                   myipv6cfsock,
                                                                   0);
    
    CFRunLoopAddSource(
                       CFRunLoopGetCurrent(),
                       socketsource6,
                       kCFRunLoopDefaultMode);
}

void handleConnect(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    NSLog(@"handleConnect");
    NSLog(@"currentMode:%@", [[NSRunLoop currentRunLoop] currentMode]);
    
    if (type != kCFSocketAcceptCallBack)
        return;
    
    NUNurseryNetService *nurseryNetService = (NUNurseryNetService *)info;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, *(CFSocketNativeHandle *)data, &readStream, &writeStream);
    
    NSInputStream *inputStream = (NSInputStream *)readStream;
    NSOutputStream *outputStream = (NSOutputStream *)writeStream;
    
    NUNurseryNetResponder *aNetResponder = [[[NUNurseryNetResponder alloc] initWithNetService:nurseryNetService inputStream:inputStream outputStream:outputStream] autorelease];
    
    [[nurseryNetService netResponders] addObject:aNetResponder];
    
    [inputStream release];
    [outputStream release];
}

@end
