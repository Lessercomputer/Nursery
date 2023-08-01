//
//  NUNurseryNetServiceIO.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/10.
//

#import <Foundation/NSStream.h>

#import <Nursery/NUTypes.h>

@class NSMutableData, NSThread;
@class NUNurseryNetMessage;

extern const NUUInt64 NUNurseryNetServiceIODefaultReadBufferSize;

@interface NUNurseryNetServiceIO : NSObject <NSStreamDelegate>
{
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    NUUInt64 readBufferSize;
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

- (NUUInt64)readBufferSize;
- (int)nativeSocketHandleForStream:(NSStream *)aStream;
//- (void)setKeepAliveOptionsForSocket:(int)aSocket;

@end
