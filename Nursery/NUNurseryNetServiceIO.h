//
//  NUNurseryNetServiceIO.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/10.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSStream.h>

#import <Nursery/NUTypes.h>

@class NSMutableData, NSThread;
@class NUNurseryNetMessage;

extern const NUUInt64 NUNurseryNetworkerReadBufferSize;

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

- (int)nativeSocketHandleForStream:(NSStream *)aStream;
//- (void)setKeepAliveOptionsForSocket:(int)aSocket;

@end
