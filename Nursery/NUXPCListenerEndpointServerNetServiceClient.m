//
//  NUXPCListenerEndpointServerNetServiceClient.m
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/12.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import "NUXPCListenerEndpointServerNetServiceClient.h"
#import "NUXPCListenerEndpointServer.h"
#import "NUTypes.h"

static NSUInteger NUXPCListenerEndpointServerNetServiceClientBufferDataLength = 4096;

@implementation NUXPCListenerEndpointServerNetServiceClient

- (instancetype)init
{
    if (self = [super init])
    {
        _condition = [NSCondition new];
        _netServices = [NSMutableArray new];
        _hostNameToNetServiceDictionary = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [_netServices release];
    [_hostNameToNetServiceDictionary release];
    [_netServiceBrowser release];
    [_condition release];
    
    [super dealloc];
}

- (void)start
{
    NSThread *aThread = [[[NSThread alloc] initWithTarget:self selector:@selector(startInNewThreadWith:) object:nil] autorelease];
    
    [aThread setName:@"NUXPCListenerEndpointServerNetServiceClient Networking Thread"];
    [self setNetworkingThread:aThread];
    
    [aThread start];
}

- (void)startInNewThreadWith:(id)anObject
{
    _netServiceBrowser = [NSNetServiceBrowser new];

    [[self netServiceBrowser] setDelegate:self];

    [[self condition] lock];

    [self setStatus:NUXPCListenerEndpointServerNetServiceClientStatusRunning];

    [[self condition] signal];
    [[self condition] unlock];

    BOOL aSearchingAndResolvingNetServices = NO;
    BOOL aNetworkingWithNetService = NO;

    while (YES)
    {
        if ([self status] == NUXPCListenerEndpointServerNetServiceClientStatusSearchingNetServices && !aSearchingAndResolvingNetServices)
        {
            aSearchingAndResolvingNetServices = YES;
            [[self netServiceBrowser] searchForServicesOfType:NUXPCListenerEndpointServerServiceType inDomain:@""];
        }
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        
        if ([self status] == NUXPCListenerEndpointServerNetServiceClientStatusNetworkingWithNetService && !aNetworkingWithNetService)
        {
            aNetworkingWithNetService = YES;
            [self prepareStreamsForNetService:[self netServiceToConnect]];
        }
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}

- (void)prepareStreamsForNetService:(NSNetService *)aNetService
{
    NSInputStream *anInputStream = nil;
    NSOutputStream *anOutputStream = nil;
    
    BOOL aStreamsCreated = [aNetService getInputStream:&anInputStream outputStream:&anOutputStream];
    
    if (aStreamsCreated)
    {
        [self setInputStream:[anInputStream autorelease]];
        [self setOutputStream:[anOutputStream autorelease]];
        
        [self setInputData:[NSMutableData data]];
        
        [[self inputStream] setDelegate:self];
        [[self inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [[self outputStream] setDelegate:self];
        [[self outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [[self inputStream] open];
        [[self outputStream] open];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}

- (NSXPCListenerEndpoint *)endpointForName:(NSString *)aName host:(NSString *)aHost
{
    if ([self status] == NUXPCListenerEndpointServerNetServiceClientStatusNone)
    {
        [self start];
        [self setNetServices:[self searchNetServices]];
    }
    
    NSXPCListenerEndpoint __block *anEndpoint = nil;
    
    if (aHost)
    {
        NSNetService *aNetServie = [[self hostNameToNetServiceDictionary] objectForKey:aHost];
        
        if (!aNetServie) return nil;
        
        return [self getEndpointForName:aName fromNetService:aNetServie];
    }
    
    [[self netServices] enumerateObjectsUsingBlock:^(NSNetService  * _Nonnull aNetService, NSUInteger idx, BOOL * _Nonnull stop) {

        anEndpoint = [self getEndpointForName:aName fromNetService:aNetService];

        if (anEndpoint) *stop = YES;
    }];
    
    return anEndpoint;
}

- (NSXPCListenerEndpoint *)getEndpointForName:(NSString *)aName fromNetService:(NSNetService *)aNetService
{
    NSXPCListenerEndpoint *anEndpoint = nil;

    NSData *anArchivedDictinary = [NSKeyedArchiver archivedDataWithRootObject:@{@"command":@"getendpoint", @"endpointname":aName}];
    NSMutableData *anOutputData = [NSMutableData data];
    NUUInt64 anOutputDataLength = sizeof(NUUInt64) + [anArchivedDictinary length];
    anOutputDataLength = NSSwapHostLongLongToBig(anOutputDataLength);
    [anOutputData appendBytes:&anOutputDataLength length:sizeof(NUUInt64)];
    [anOutputData appendData:anArchivedDictinary];
    [self setOutputData:anOutputData];

    [self setNetServiceToConnect:aNetService];
    
    [[self condition] lock];
    [self setStatus:NUXPCListenerEndpointServerNetServiceClientStatusNetworkingWithNetService];
    [[self condition] signal];
    [[self condition] unlock];
    
    [[self condition] lock];
    
    while ([self status] == NUXPCListenerEndpointServerNetServiceClientStatusNetworkingWithNetService)
    {
        if ([NSThread isMainThread])
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        
        [[self condition] waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    
    [[self condition] unlock];
    
    NSDictionary *aReplyDictionary = [NSUnarchiver unarchiveObjectWithData:[self inputData]];
    anEndpoint = [aReplyDictionary objectForKey:@"endpoint"];
    [self setInputData:nil];
    
    return anEndpoint;
}

- (NSMutableArray *)searchNetServices
{
    [[self condition] lock];
    
    while ([self status] == NUXPCListenerEndpointServerNetServiceClientStatusNone)
           [[self condition] wait];
    
    [[self condition] unlock];
    
    [[self condition] lock];

    [self setStatus:NUXPCListenerEndpointServerNetServiceClientStatusSearchingNetServices];
    [[self condition] signal];
    [[self condition] unlock];
    
    [[self condition] lock];
    
    while ([self status] == NUXPCListenerEndpointServerNetServiceClientStatusSearchingNetServices
           || [self status] == NUXPCListenerEndpointServerNetServiceClientStatusNetworkingWithNetService)
        [[self condition] wait];
    
    [[self condition] unlock];
    
    return [self netServices];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser
           didFindService:(NSNetService *)aService
               moreComing:(BOOL)aMoreComing
{
    NSLog(@"browser:%@\nservice:%@", aBrowser, aService);
    
    [[self netServices] addObject:aService];
    [aService setDelegate:self];
    
    if (!aMoreComing)
    {
        [[self condition] lock];
        
        [self setStatus:NUXPCListenerEndpointServerNetServiceClientStatusRunning];
        
        [[self condition] signal];
        [[self condition] unlock];
        
        [aBrowser stop];
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)anEventCode
{
    if (aStream == [self inputStream])
    {
        NSInteger aReadCount = 0;
        
        switch (anEventCode)
        {
            case NSStreamEventHasBytesAvailable:
                
                if (![self inputDataBuffer])
                    [self setInputDataBuffer:[NSMutableData dataWithLength:NUXPCListenerEndpointServerNetServiceClientBufferDataLength]];
                
                aReadCount = [[self inputStream] read:(uint8_t *)[[self inputDataBuffer] bytes]  maxLength:NUXPCListenerEndpointServerNetServiceClientBufferDataLength];
                
                if (aReadCount)
                {
                    [[self inputData] appendBytes:[[self inputDataBuffer] bytes] length:aReadCount];
                    
                    if ([[self inputData] length] >= sizeof(NUInt64))
                    {
                        NUUInt64 anInputDataLength;
                        [[self inputData] getBytes:&anInputDataLength length:sizeof(NUUInt64)];
                        anInputDataLength = NSSwapBigLongLongToHost(anInputDataLength);
                        
                        if ([[self inputData] length] == anInputDataLength)
                        {
                            NSData *aReplyDictionaryData = [[self inputData] subdataWithRange:NSMakeRange(sizeof(NUUInt64), anInputDataLength - sizeof(NUUInt64))];
                            [self setReplyDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:aReplyDictionaryData]];
                            [self stop];
                        }
                    }
                }
                
                break;
                
            case NSStreamEventEndEncountered:
                
                [self setInputDataBuffer:nil];
                
                [[self inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                [self setInputStream:nil];
                
                break;
                
            default:
                break;
        }
    }
    else if (aStream == [self outputStream])
    {
        NSInteger aWriteCount = 0;
        
        switch (anEventCode)
        {
            case NSStreamEventHasSpaceAvailable:
                
                if ([[self outputData] length])
                {
                    aWriteCount = [[self outputStream] write:(uint8_t *)[[self outputData] bytes] maxLength:[[self outputData] length]];
                    
                    [[self outputData] replaceBytesInRange:NSMakeRange(0, aWriteCount) withBytes:NULL length:0];
                }
                
                break;
                
            default:
                break;
        }
    }
    
    if (![self outputStream] && ![self inputStream])
    {
        [[self condition] lock];
        
        [self setStatus:NUXPCListenerEndpointServerNetServiceClientStatusRunning];
        
        [[self condition] signal];
        [[self condition] unlock];
    }
}

@end
