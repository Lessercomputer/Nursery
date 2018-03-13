//
//  NUXPCListenerEndpointServerStreamUnit.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/21.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUXPCListenerEndpointServerStreamUnit : NSObject <NSStreamDelegate>

@property (retain)NSInputStream *inputStream;
@property (retain)NSOutputStream *outputStream;
@property (retain)NSMutableData *inputDataBuffer;
@property (retain)NSMutableData *inputData;
@property (retain)NSMutableData *outputData;

- (void)stop;

@end
