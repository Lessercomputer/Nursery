//
//  NUNurseryNetResponder.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/01.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUNurseryNetResponder.h"
#import "NUNurseryNetService.h"
#import "NUMainBranchNursery.h"
#import "NUNurseryNetMessage.h"
#import "NUNurseryNetMessageArgument.h"
#import "NUPairedMainBranchSandbox.h"
#import "NUPairedMainBranchAliaser.h"

const NSTimeInterval NUNurseryNetResponderSleepTimeInterval = 0.001;

@implementation NUNurseryNetResponder

- (instancetype)initWithNetService:(NUNurseryNetService *)aNetService inputStream:(NSInputStream *)anInputStream outputStream:(NSOutputStream *)anOutputStream
{
    if (self = [super init])
    {
        _pairedSandboxes = [NSMutableDictionary new];
        _netService = aNetService;
        _inputStream = [anInputStream retain];
        _outputStream = [anOutputStream retain];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc:%@", self);

    [_pairedSandboxes release];
    
    [super dealloc];
}

- (void)start
{
    NSThread *aThread = [[[NSThread alloc] initWithBlock:^{
        
        [[self inputStream] open];
        [[self outputStream] open];
        
        while (![[self thread] isCancelled])
        {
            [NSThread sleepForTimeInterval:NUNurseryNetResponderSleepTimeInterval];
            
            if ([[self inputStream] hasBytesAvailable])
                 [self receiveMessageOnStream];
                 
            if ([[self outputStream] hasSpaceAvailable])
                 [self sendMessageOnStream];
            
            if ([[self inputStream] streamStatus] == NSStreamStatusAtEnd
                || [[self outputStream] streamStatus] == NSStreamStatusAtEnd)
                [[self thread] cancel];
            
            if ([[self inputStream] streamStatus] == NSStreamStatusError
                || [[self outputStream] streamStatus] == NSStreamStatusError)
            {
                NSLog(@"inputStream error:%@, outputStream error:%@", [[self inputStream] streamError], [[self outputStream] streamError]);
//                @throw [NSException exceptionWithName:NUNurseryNetServiceNetworkException reason:NUNurseryNetServiceNetworkException userInfo:nil];
                [[self thread] cancel];
            }
        }
        
        [[self inputStream] close];
        [[self outputStream] close];
        [[self netService] netResponderDidStop:self];
    }] autorelease];
    
    [aThread setName:@"org.nursery-framework.NUNurseryNetResponder"];
    [self setThread:aThread];
    [aThread start];
}

- (void)stop
{
    [[self thread] cancel];
}

- (void)messageDidReceive
{
    NUUInt64 aMessageKind = [[self receivedMessage] messageKind];
    NUNurseryNetMessage *aResponse = nil;
    
    if (aMessageKind == NUNurseryNetMessageKindOpenSandbox)
    {
        aResponse = [self responseForOpenSandbox];
    }
    else if (aMessageKind == NUNurseryNetMessageKindCloseSandbox)
    {
        aResponse = [self responseForCloseSandbox];
    }
    else if (aMessageKind == NUNurseryNetMessageKindRootOOP)
    {
        aResponse = [self responseForRootOOP];
    }
    else if (aMessageKind == NUNurseryNetMessageKindLatestGrade)
    {
        aResponse = [self responseForLatestGrade];
    }
    else if (aMessageKind == NUNurseryNetMessageKindOlderRetainedGrade)
    {
        aResponse = [self responseForOlderRetainedGrade];
    }
    else if (aMessageKind == NUNurseryNetMessageKindRetainLatestGrade)
    {
        aResponse = [self responseForRetainLatestGrade];
    }
    else if (aMessageKind == NUNurseryNetMessageKindRetainGradeIfValid)
    {
        aResponse = [self responseForRetainGradeIfValid];
    }
    else if (aMessageKind == NUNurseryNetMessageKindRetainGrade)
    {
        aResponse = [self responseForRetainGrade];
    }
    else if (aMessageKind == NUNurseryNetMessageKindReleaseGradeLessThan)
    {
        aResponse = [self responseForReleaseGradeLessThan];
    }
    else if (aMessageKind == NUNurseryNetMessageKindCallForPupil)
    {
        aResponse = [self responseForCallForPupil];
    }
    else if (aMessageKind == NUNurseryNetMessageKindFarmOutPupils)
    {
        aResponse = [self responseForFarmOutPupils];
    }
    else if (aMessageKind == NUNurseryNetMessageKindNetClientWillStop)
    {
        aResponse = [self responseForNetClientWillStop];
    }
    
    [aResponse serialize];
    [self setSendingMessage:aResponse];
}

- (NUPairedMainBranchSandbox *)pairedMainBranchSandboxFor:(NUUInt64)aPairID
{
    return [[self pairedSandboxes] objectForKey:@(aPairID)];
}

- (void)messageDidSend
{
    [[self outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

@end

@implementation NUNurseryNetResponder (Private)

- (NUMainBranchNursery *)nursery
{
    return [[self netService] nursery];
}

- (NUNurseryNetMessage *)responseForOpenSandbox
{
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindOpenSandboxResponse];
    
    NUUInt64 aPairID = [[self nursery] newSandboxID];
    [[self pairedSandboxes] setObject:[[self nursery] makePairdSandbox] forKey:@(aPairID)];
    
    [aResponse addArgumentOfTypeUInt64WithValue:aPairID];

    return aResponse;
}

- (NUNurseryNetMessage *)responseForCloseSandbox
{
    NSNumber *aPairID = [[[self receivedMessage] argumentAt:0] value];
    [[self pairedSandboxes] removeObjectForKey:aPairID];
    
    return nil;
}

- (NUNurseryNetMessage *)responseForRootOOP
{
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUPairedMainBranchSandbox *aPairedMainBranchSandbox = [[self pairedSandboxes] objectForKey:@(aPairID)];
    
    NUUInt64 aRootOOP = [[aPairedMainBranchSandbox pairedMainBranchAliaser] rootOOP];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRootOOPResponse];
    [aResponse addArgumentOfTypeUInt64WithValue:aRootOOP];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForLatestGrade
{
    NUUInt64 aLatestGrade = [[[self netService] nursery] latestGrade:nil];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindLatestGradeResponse];
    [aResponse addArgumentOfTypeUInt64WithValue:aLatestGrade];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForOlderRetainedGrade
{
    NUUInt64 anOlderRetaindGrade = [[[self netService] nursery] olderRetainedGrade:nil];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindOlderRetainedGradeResponse];
    [aResponse addArgumentOfTypeUInt64WithValue:anOlderRetaindGrade];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForRetainLatestGrade
{
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUPairedMainBranchSandbox *aPairedMainBranchSandbox = [self pairedMainBranchSandboxFor:aPairID];
    
    NUUInt64 aRetaindLatestGrade = [aPairedMainBranchSandbox retainLatestGradeOfNursery];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainLatestGradeResponse];
    [aResponse addArgumentOfTypeUInt64WithValue:aRetaindLatestGrade];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForRetainGradeIfValid
{
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUUInt64 aGrade = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
    NUPairedMainBranchSandbox *aPairedMainBranchSandbox = [self pairedMainBranchSandboxFor:aPairID];
    
    NUUInt64 aRetaindGradeOrNilGrade = [[[self netService] nursery] retainGradeIfValid:aGrade bySandbox:aPairedMainBranchSandbox];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainGradeIfValidResponse];
    [aResponse addArgumentOfTypeUInt64WithValue:aRetaindGradeOrNilGrade];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForRetainGrade
{
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUUInt64 aGrade = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
    
    [[[self netService] nursery] retainGrade:aGrade bySandboxWithID:aPairID];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainGradeResponse];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForReleaseGradeLessThan
{
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUUInt64 aGrade = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    
    [[[self netService] nursery] releaseGradeLessThan:aGrade bySandboxWithID:aPairID];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindReleaseGradeLessThanResponse];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForCallForPupil
{
    NUUInt64 anOOP = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUUInt64 aGrade = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:2] UInt64FromValue];
    BOOL aContainsFellowPupils = [[[self receivedMessage] argumentAt:3] BOOLFromValue];
    
    NUPairedMainBranchSandbox *aPairdMainBranchSandbox = [self pairedMainBranchSandboxFor:aPairID];
    
    NSData *aPupilsData = [aPairdMainBranchSandbox callForPupilWithOOP:anOOP  gradeLessThanOrEqualTo:aGrade containsFellowPupils:aContainsFellowPupils];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindCallForPupilResponse];
    
    [aResponse addArgumentOfTypeBytesWithValue:(void *)[aPupilsData bytes] length:[aPupilsData length]];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForFarmOutPupils
{
    NSData *aPupilData = [[[self receivedMessage] argumentAt:0] dataFromValue];
    NUUInt64 aRootOOP = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:2] UInt64FromValue];
    NUPairedMainBranchSandbox *aPairedMainBranchSandbox = [self pairedMainBranchSandboxFor:aPairID];
    NSData *aFixedOOPs = nil;
    NUUInt64 aLatestGrade;
    
    NUFarmOutStatus aFarmOutStatus = [aPairedMainBranchSandbox farmOutPupils:aPupilData rootOOP:aRootOOP fixedOOPs:&aFixedOOPs latestGrade:&aLatestGrade];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindFarmOutPupilsResponse];
    [aResponse addArgumentOfTypeUInt64WithValue:aFarmOutStatus];
    [aResponse addArgumentOfTypeBytesWithValue:(void *)[aFixedOOPs bytes] length:[aFixedOOPs length]];
    [aResponse addArgumentOfTypeUInt64WithValue:aLatestGrade];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForNetClientWillStop
{
    [self stop];
    
    return nil;
}

@end
