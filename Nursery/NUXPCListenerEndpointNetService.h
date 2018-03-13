//
//  NUXPCListenerEndpointNetService.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/12.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUXPCListenerEndpointServerStreamUnitWithThread.h"

@interface NUXPCListenerEndpointNetService : NUXPCListenerEndpointServerStreamUnitWithThread <NSNetServiceDelegate>

@property BOOL netServicePublished;
@property (retain)NSCondition *netServicePublishedCondition;
@property (retain)NSNetService *netService;
@property (retain)NSMutableDictionary *endpointsDictionary;
@property (retain)NSMutableDictionary *streamUnitDictionary;

- (void)setEndpoint:(NSXPCListenerEndpoint *)anEndpoint forName:(NSString *)aName;
- (void)removeEndpointForName:(NSString *)aName;

- (void)startIfNeeded;
- (void)scheduleStreamsOf:(NUXPCListenerEndpointServerStreamUnit *)aStreamUnit;

@end
