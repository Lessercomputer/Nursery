//
//  NUNurseryNetworker.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/10.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUNurseryNetServiceIO.h"
#import "NUNurseryNetMessage.h"

const NUUInt64 NUNurseryNetworkerReadBufferSize = 4096;

@implementation NUNurseryNetServiceIO

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
    {
//        NSLog(@"has sendingMessage?:%@, %@", [self sendingMessage] ? @"YES": @"NO", self);
        return;
    }
    
//    NSLog(@"sendMessageOnStream, %@", self);

    NSData *aSendingMessageData = [[self sendingMessage] serializedData];
    
    NUUInt64 aWriteCount = [[self outputStream] write:[aSendingMessageData bytes] + [self writtenBytesCount] maxLength:[aSendingMessageData length] - [self writtenBytesCount]];
    
    [self setWrittenBytesCount:[self writtenBytesCount] + aWriteCount];
//    NSLog(@"writeCount:%@", @(aWriteCount));
    
    if ([self writtenBytesCount] == [aSendingMessageData length])
    {
        [self messageDidSend];
//        NSLog(@"messageDidSend, %@", self);
        
        [self setWrittenBytesCount:0];
        [self setSendingMessage:nil];
    }
}

- (void)messageDidSend
{
}

- (void)receiveMessageOnStream
{
//    NSLog(@"receiveMessageOnStream, %@", self);
    
    NUUInt8 *aReadBuffer = NULL;
    NUUInt64 aReadBytesCount;
    
    aReadBuffer = malloc(NUNurseryNetworkerReadBufferSize);
    
    aReadBytesCount = [[self inputStream] read:aReadBuffer maxLength:NUNurseryNetworkerReadBufferSize];
    
    if (aReadBytesCount && ![self inputData])
        [self setInputData:[NSMutableData data]];
    
    [[self inputData] appendBytes:aReadBuffer length:aReadBytesCount];
    
//    NSLog(@"readCount:%@", @(aReadBytesCount));
    
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

@end
