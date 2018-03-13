//
//  NUXPCListenerEndpointServer.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/09.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *NUXPCListenerEndpointServerServiceType;

@class NUXPCListenerEndpointNetService, NUXPCListenerEndpointServerNetServiceClient;

@interface NUXPCListenerEndpointServer : NSObject

+ (instancetype)sharedInstance;

@property (retain) NUXPCListenerEndpointNetService *netService;
@property (retain) NUXPCListenerEndpointServerNetServiceClient *netServiceClient;

- (NSXPCListenerEndpoint *)endpointForName:(NSString *)aName;
- (NSXPCListenerEndpoint *)endpointForName:(NSString *)aName host:(NSString *)aHost;

- (BOOL)registerEndpoint:(NSXPCListenerEndpoint *)anEndpoint name:(NSString *)aName;
- (BOOL)removeEndpointForName:(NSString *)aName;

@end

@interface NUXPCListenerEndpointServer (Private)

@property (retain)NSCondition *condition;

- (void)getEndpointFor:(NSDictionary *)aDictionary;

@end
