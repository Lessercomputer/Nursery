//
//  NUXPCListenerEndpointNetService.m
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/12.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

#import "NUXPCListenerEndpointNetService.h"
#import "NUXPCListenerEndpointServer.h"
#import "NUTypes.h"

static NSUInteger NUXPCListenerEndpointServerNetServiceBufferDataLength = 4096;

@implementation NUXPCListenerEndpointNetService

- (instancetype)init
{
    if (self = [super init])
    {
        _netServicePublishedCondition = [NSCondition new];
        _endpointsDictionary = [NSMutableDictionary new];
        _streamUnitDictionary = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [_netService release];
    [_endpointsDictionary release];
    [_streamUnitDictionary release];
    [_netServicePublishedCondition release];
    
    [super dealloc];
}

- (void)startIfNeeded
{
    if (![self networkingThread])
        [self start];
}

- (void)start
{
    NSThread *aThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInNewThreadWith:) object:nil];
    
    [aThread setName:@"NUXPCListenerEndpointNetService Networking Thread"];
    [self setNetworkingThread:aThread];
    
    [aThread start];
    
    
    while (![self netServicePublished])
        [[self netServicePublishedCondition] wait];

    [[self netServicePublishedCondition] unlock];
}

- (void)startInNewThreadWith:(id)anObject
{
    _netService =  [[NSNetService alloc] initWithDomain:@"" type:NUXPCListenerEndpointServerServiceType name:[[NSHost currentHost] localizedName] port:0];

    [[self netService] setDelegate:self];
    [[self netService] publishWithOptions:NSNetServiceListenForConnections];

    while (YES)
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict
{
    NSLog(@"%@", errorDict);
    [[self netServicePublishedCondition] lock];
    [self setNetServicePublished:YES];
    [[self netServicePublishedCondition] signal];
    [[self netServicePublishedCondition] unlock];
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"%@", sender);
    
    [[self netServicePublishedCondition] lock];
    [self setNetServicePublished:YES];

    [[self netServicePublishedCondition] signal];
    [[self netServicePublishedCondition] unlock];
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)anInputStream outputStream:(NSOutputStream *)anOutputStream
{
    NSLog(@"%@", sender);
    
    NUXPCListenerEndpointServerStreamUnit *aStreamUnit = [[NUXPCListenerEndpointServerStreamUnit new] autorelease];
    
    [aStreamUnit setInputStream:anInputStream];
    [aStreamUnit setOutputStream:anOutputStream];
    
    [[self streamUnitDictionary] setObject:aStreamUnit forKey:[NSValue valueWithNonretainedObject:anInputStream]];
    [[self streamUnitDictionary] setObject:aStreamUnit forKey:[NSValue valueWithNonretainedObject:anOutputStream]];
    
    [self performSelector:@selector(scheduleStreamsOf:) onThread:[self networkingThread] withObject:aStreamUnit waitUntilDone:NO];
}

- (void)scheduleStreamsOf:(NUXPCListenerEndpointServerStreamUnit *)aStreamUnit
{
    [aStreamUnit setInputDataBuffer:[NSMutableData dataWithLength:NUXPCListenerEndpointServerNetServiceBufferDataLength]];
    
    [[aStreamUnit inputStream] setDelegate:self];
    [[aStreamUnit outputStream] setDelegate:self];
    
    [[aStreamUnit inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [[aStreamUnit outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    [[aStreamUnit inputStream] open];
    [[aStreamUnit outputStream] open];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)anEventCode
{
    NUXPCListenerEndpointServerStreamUnit *aStreamUnit = [[self streamUnitDictionary] objectForKey:[NSValue valueWithNonretainedObject:aStream]];
    NSUInteger aReadCount = 0;
    
    if (aStream == [aStreamUnit inputStream])
    {
        switch (anEventCode)
        {
            case NSStreamEventHasBytesAvailable:
                
                if (![aStreamUnit inputData])
                    [aStreamUnit setInputData:[NSMutableData data]];
                
                aReadCount = [[aStreamUnit inputStream] read:(uint8_t *)[[aStreamUnit inputDataBuffer] bytes] maxLength:NUXPCListenerEndpointServerNetServiceBufferDataLength];
                
                [[aStreamUnit inputData] appendBytes:[[aStreamUnit inputDataBuffer] bytes] length:aReadCount];
                
                if ([[aStreamUnit inputData] length] >= sizeof(NUUInt64))
                {
                    NUUInt64 anInputDataLength;
                    [[aStreamUnit inputData] getBytes:&anInputDataLength length:sizeof(NUUInt64)];
                    anInputDataLength = NSSwapBigLongLongToHost(anInputDataLength);
                    
                    if ([[aStreamUnit inputData] length] == anInputDataLength)
                    {
                        NSData *anArchivedDictionary = [[aStreamUnit inputData] subdataWithRange:NSMakeRange(sizeof(NUUInt64), [[aStreamUnit inputData] length] - sizeof(NUUInt64))];
                        NSDictionary *aDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:anArchivedDictionary];
                        NSLog(@"%@", aDictionary);
                        
                        NSXPCListenerEndpoint *anEndpoint = [[self endpointsDictionary] objectForKey:[aDictionary objectForKey:@"endpointname"]];
                        NSMutableDictionary *anOutputDictionary = [NSMutableDictionary dictionary];
                        
                        if (anEndpoint)
                            [anOutputDictionary setObject:anEndpoint forKey:@"endpoint"];
                        
                        NSData *anOutputDictionaryData = [NSKeyedArchiver archivedDataWithRootObject:anOutputDictionary];
                        NUUInt64 anOutputDictionaryDataLength = sizeof(NUUInt64) + [anOutputDictionaryData length];
                        anOutputDictionaryDataLength = NSSwapHostLongLongToBig(anOutputDictionaryDataLength);
                        NSMutableData *anOutputData = [NSMutableData data];
                        [anOutputData appendBytes:&anOutputDictionaryDataLength length:sizeof(NUUInt64)];
                        [anOutputData appendData:anOutputDictionaryData];
                        [aStreamUnit setOutputData:anOutputData];
                    }
                }
                
                break;
                
            case NSStreamEventEndEncountered:
                
                [[self streamUnitDictionary] removeObjectForKey:[NSValue valueWithNonretainedObject:aStream]];
                
                break;
                
            default:
                break;
        }
    }
    else if (aStream == [aStreamUnit outputStream])
    {
        NSInteger aWriteCount = 0;
        
        switch (anEventCode)
        {
            case NSStreamEventHasSpaceAvailable:
                
                if ([[aStreamUnit outputData] length])
                {
                    aWriteCount = [[aStreamUnit outputStream] write:(uint8_t *)[[aStreamUnit outputData] bytes] maxLength:[[aStreamUnit outputData] length]];
                    
                    [[aStreamUnit outputData] replaceBytesInRange:NSMakeRange(0, aWriteCount) withBytes:NULL length:0];
                }
                
                if ([aStreamUnit outputData] && ![[aStreamUnit outputData] length])
                    [aStreamUnit stop];
                
                break;
                
            case NSStreamEventEndEncountered:
                
                [[self streamUnitDictionary] removeObjectForKey:[NSValue valueWithNonretainedObject:aStream]];
                
                break;
                
            default:
                break;
        }
    }
}

- (void)setEndpoint:(NSXPCListenerEndpoint *)anEndpoint forName:(NSString *)aName
{
    [[self endpointsDictionary] setObject:anEndpoint forKey:aName];
}

- (void)removeEndpointForName:(NSString *)aName
{
    [[self endpointsDictionary] removeObjectForKey:aName];
}

@end
