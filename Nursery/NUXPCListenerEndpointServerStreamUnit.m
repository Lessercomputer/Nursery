//
//  NUXPCListenerEndpointServerStreamUnit.m
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/21.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import "NUXPCListenerEndpointServerStreamUnit.h"

@implementation NUXPCListenerEndpointServerStreamUnit

- (void)dealloc
{
    [_outputData release];
    [_inputData release];
    
    [super dealloc];
}

- (void)stop
{
    [[self inputStream] close];
    [[self outputStream] close];
    
    [[self inputStream] setDelegate:nil];
    [[self outputStream] setDelegate:nil];
    
    [[self inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[self outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self setInputStream:nil];
    [self setOutputStream:nil];
}

@end
