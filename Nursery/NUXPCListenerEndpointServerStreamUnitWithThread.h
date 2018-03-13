//
//  NUXPCListenerEndpointServerInternal.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/12.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import "NUXPCListenerEndpointServerStreamUnit.h"

@interface NUXPCListenerEndpointServerStreamUnitWithThread : NUXPCListenerEndpointServerStreamUnit

@property (retain)NSThread *networkingThread;
@property (assign)NSRunLoop *networkingRunLoop;

- (void)start;
- (void)startInNewThreadWith:(id)anObject;

@end
