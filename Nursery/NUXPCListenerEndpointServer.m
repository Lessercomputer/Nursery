//
//  NUXPCListenerEndpointServer.m
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/09.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import "NUXPCListenerEndpointServer.h"
#import "NUXPCListenerEndpointNetService.h"
#import "NUXPCListenerEndpointServerNetServiceClient.h"

static NSRecursiveLock *classLock;
static NUXPCListenerEndpointServer *sharedInstance = nil;

NSString *NUXPCListenerEndpointServerServiceType = @"_nuxpclistenerendpointserver._tcp.";

@implementation NUXPCListenerEndpointServer

+ (void)initialize
{
    classLock = [NSRecursiveLock new];
}

+ (instancetype)sharedInstance
{
    [classLock lock];
    
    if (!sharedInstance)
        sharedInstance = [self new];

    [classLock unlock];
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _netService = [NUXPCListenerEndpointNetService new];
        _netServiceClient = [NUXPCListenerEndpointServerNetServiceClient new];
    }
    
    return self;
}

- (void)dealloc
{
    [_netService release];
    [_netServiceClient release];
    
    [super dealloc];
}

- (BOOL)registerEndpoint:(NSXPCListenerEndpoint *)anEndpoint name:(NSString *)aName
{
    @synchronized (self)
    {
        [[self netService] startIfNeeded];
        
        [[self netService] setEndpoint:anEndpoint forName:aName];
    }
    
    return YES;
}

- (NSXPCListenerEndpoint *)endpointForName:(NSString *)aName
{
    return [self endpointForName:aName host:nil];
}

- (NSXPCListenerEndpoint *)endpointForName:(NSString *)aName host:(NSString *)aHost;
{
    NSXPCListenerEndpoint *anEndpoint = nil;
    
    @synchronized (self)
    {
        [[self netService] startIfNeeded];

        anEndpoint = [[self netServiceClient] endpointForName:aName host:aHost];
    }
    
    return anEndpoint;
}

- (BOOL)removeEndpointForName:(NSString *)aName
{
    @synchronized (self)
    {
        [[self netService] startIfNeeded];
        
        [[self netService] removeEndpointForName:aName];
    }
    
    return YES;
}

@end
