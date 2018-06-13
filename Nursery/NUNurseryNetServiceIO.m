//
//  NUNurseryNetServiceIO.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/10.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#include <stdlib.h>
#import <Foundation/NSData.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSByteOrder.h>
#import <CoreFoundation/CFStream.h>

#import "NUNurseryNetServiceIO.h"
#import "NUNurseryNetMessage.h"
//#include <sys/socket.h>
//#include <sys/socketvar.h>
//#include <netinet/in.h>
//#include <netinet/tcp.h>
//#include <netinet/tcp_var.h>

const NUUInt64 NUNurseryNetServiceIODefaultReadBufferSize = 4096;

@implementation NUNurseryNetServiceIO

- (instancetype)init
{
    if (self = [super init])
    {
        readBufferSize = NUNurseryNetServiceIODefaultReadBufferSize;
    }
    
    return self;
}

- (void)dealloc
{
    [_inputStream close];
    [_inputStream release];
    _inputStream = nil;
    
    [_outputStream close];
    [_outputStream release];
    _outputStream = nil;
    
    [_inputData release];
    _inputData = nil;
    
    [_receivedMessage release];
    _receivedMessage = nil;
    
    [_sendingMessage release];
    _sendingMessage = nil;
    
    [_thread release];
    _thread = nil;
    
    [super dealloc];
}

- (void)streamDidOpen:(NSStream *)aStream
{
    
}

- (void)sendMessageOnStream
{
    if (![self sendingMessage])
        return;
    
    NSData *aSendingMessageData = [[self sendingMessage] serializedData];
    
    NUUInt64 aWriteCount = [[self outputStream] write:[aSendingMessageData bytes] + [self writtenBytesCount] maxLength:[aSendingMessageData length] - [self writtenBytesCount]];
    
    [self setWrittenBytesCount:[self writtenBytesCount] + aWriteCount];
    
    if ([self writtenBytesCount] == [aSendingMessageData length])
    {
        [self messageDidSend];
        
        [self setWrittenBytesCount:0];
        [self setSendingMessage:nil];
    }
}

- (void)messageDidSend
{
}

- (void)receiveMessageOnStream
{
    NUUInt8 *aReadBuffer = NULL;
    NUInt64 aReadBytesCount;
    
    aReadBuffer = malloc([self readBufferSize]);
    
    aReadBytesCount = [[self inputStream] read:aReadBuffer maxLength:[self readBufferSize]];
    
    if (aReadBytesCount > 0  && ![self inputData])
        [self setInputData:[NSMutableData data]];
    
    if (aReadBytesCount > 0)
        [[self inputData] appendBytes:aReadBuffer length:aReadBytesCount];
        
    free(aReadBuffer);
    
    if (![self receivingMessageSize] && [[self inputData] length] >= sizeof(NUUInt64))
    {
        NUUInt64 aMessageSize = *(NUUInt64 *)[[self inputData] bytes];
        aMessageSize = NSSwapBigLongLongToHost(aMessageSize);
        [self setReceivingMessageSize:aMessageSize];
    }
    
    if ([[self inputData] length] && [[self inputData] length] == [self receivingMessageSize])
    {
        [self setReceivingMessageSize:0];
        
        [self setReceivedMessage:[[[NUNurseryNetMessage alloc] initWithData:[self inputData]] autorelease]];
        [[self receivedMessage] deserialize];
        
        [self setInputData:nil];
        
        [self messageDidReceive];
    }
}

- (void)messageDidReceive
{
}

- (NUUInt64)readBufferSize
{
    return readBufferSize;
}

- (int)nativeSocketHandleForStream:(NSStream *)aStream
{
    NSData *aNativeSocketHandleData = [aStream propertyForKey:(__bridge NSString *)kCFStreamPropertySocketNativeHandle];

    return *(const int *)[aNativeSocketHandleData bytes];
}

//- (void)setKeepAliveOptionsForSocket:(int)aSocket
//{
//    int anOption = 1;
//    setsockopt(aSocket, SOL_SOCKET, SO_KEEPALIVE, (void *)&anOption, sizeof(anOption));
//
//    anOption = 60;
//    setsockopt(aSocket, IPPROTO_TCP, TCPCTL_KEEPIDLE, (void *)&anOption, sizeof(anOption));
//    anOption = 30;
//    setsockopt(aSocket, IPPROTO_TCP, TCP_KEEPINTVL, (void *)&anOption, sizeof(anOption));
//    anOption =  4;
//    setsockopt(aSocket, IPPROTO_TCP, TCP_KEEPCNT, (void *)&anOption, sizeof(anOption));
//}

@end
