//
//  NUNurseryNetworker.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/10.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

extern const NUUInt64 NUNurseryNetworkerReadBufferSize;

@class NUNurseryNetMessage;

@interface NUNurseryNetServiceIO : NSObject <NSStreamDelegate>
{
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
}

@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;

@property (nonatomic, retain) NSMutableData *inputData;
@property (nonatomic) NUUInt64 receivingMessageSize;
@property (nonatomic, retain) NUNurseryNetMessage *receivedMessage;
@property (nonatomic, retain) NUNurseryNetMessage *sendingMessage;
@property (nonatomic) NUUInt64 readBytesCount;
@property (nonatomic) NUUInt64 writtenBytesCount;

@property (nonatomic, retain) NSThread *thread;

- (void)streamDidOpen:(NSStream *)aStream;

- (void)sendMessageOnStream;
- (void)messageDidSend;

- (void)receiveMessageOnStream;
- (void)messageDidReceive;

@end
