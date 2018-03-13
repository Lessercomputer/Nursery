//
//  NUXPCListenerEndpointServerNetServiceClient.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/12.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUXPCListenerEndpointServerStreamUnitWithThread.h"

typedef enum : NSUInteger {
    NUXPCListenerEndpointServerNetServiceClientStatusNone,
    NUXPCListenerEndpointServerNetServiceClientStatusRunning,
    NUXPCListenerEndpointServerNetServiceClientStatusSearchingNetServices,
    NUXPCListenerEndpointServerNetServiceClientStatusNetworkingWithNetService
} NUXPCListenerEndpointServerNetServiceClientStatus;

@interface NUXPCListenerEndpointServerNetServiceClient : NUXPCListenerEndpointServerStreamUnitWithThread <NSNetServiceDelegate,  NSNetServiceBrowserDelegate>

@property NUXPCListenerEndpointServerNetServiceClientStatus status;
@property (retain)NSCondition *condition;
@property (retain)NSNetServiceBrowser *netServiceBrowser;
@property (retain)NSMutableArray *netServices;
@property (retain)NSMutableDictionary *hostNameToNetServiceDictionary;
@property (retain)NSNetService *netServiceToConnect;
@property BOOL shouldScheduleStreamPairs;
@property (retain)NSDictionary *replyDictionary;

- (NSXPCListenerEndpoint *)endpointForName:(NSString *)aName host:(NSString *)aHost;

- (NSXPCListenerEndpoint *)getEndpointForName:(NSString *)aName fromNetService:(NSNetService *)aNetService;

@end
