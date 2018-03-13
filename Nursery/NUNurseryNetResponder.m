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

@implementation NUNurseryNetResponder

- (instancetype)initWithNetService:(NUNurseryNetService *)aNetService inputStream:(NSInputStream *)anInputStream outputStream:(NSOutputStream *)anOutputStream
{
    NSLog(@"initWithNetService:, %@", self);
    
    if (self = [super init])
    {
        _pairedSandboxes = [NSMutableDictionary new];
        _netService = aNetService;
        _inputStream = [anInputStream retain];
        [_inputStream setDelegate:self];
        [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _outputStream = [anOutputStream retain];
        [_outputStream setDelegate:self];
//        [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [_inputStream open];
        [_outputStream open];
    }
    
    return self;
}

- (void)messageDidReceive
{
//    NSLog(@"messageDidReceive: %@", self);
    
    NUUInt64 aMessageKind = [[self receivedMessage] messageKind];
    
    if (aMessageKind == NUNurseryNetMessageKindOpenSandbox)
    {
//        NSLog(@"NUNurseryNetMessageKindOpenSandbox");
        
        NUMainBranchNursery *aNursery = [[self netService] nursery];
        
        NUUInt64 aPairID = [aNursery newSandboxID];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindOpenSandboxResponse];
        [[self pairedSandboxes] setObject:[aNursery createPairdSandbox] forKey:@(aPairID)];
        [aResponse addArgumentOfTypeUInt64WithValue:aPairID];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindCloseSandbox)
    {
        NSNumber *aPairID = [[[self receivedMessage] argumentAt:0] value];
        NUPairedMainBranchSandbox *aPairedSandbox = [[self pairedSandboxes] objectForKey:aPairID];
        
        [aPairedSandbox close];
        [[self pairedSandboxes] removeObjectForKey:aPairID];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindCloseSandboxResponse];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindRootOOP)
    {
//        NSLog(@"NUNurseryNetMessageKindRootOOP");
        
        NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
        NUPairedMainBranchSandbox *aPairedMainBranchSandbox = [[self pairedSandboxes] objectForKey:@(aPairID)];
        
        NUUInt64 aRootOOP = [[aPairedMainBranchSandbox pairedMainBranchAliaser] rootOOP];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRootOOPResponse];
        [aResponse addArgumentOfTypeUInt64WithValue:aRootOOP];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindLatestGrade)
    {
        NUUInt64 aLatestGrade = [[[self netService] nursery] latestGrade:nil];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindLatestGradeResponse];
        [aResponse addArgumentOfTypeUInt64WithValue:aLatestGrade];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindOlderRetainedGrade)
    {
        NUUInt64 anOlderRetaindGrade = [[[self netService] nursery] olderRetainedGrade:nil];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindOlderRetainedGradeResponse];
        [aResponse addArgumentOfTypeUInt64WithValue:anOlderRetaindGrade];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindRetainLatestGrade)
    {
        NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
        NUPairedMainBranchSandbox *aPairedMainBranchSandbox = [self pairedMainBranchSandboxFor:aPairID];
        
        NUUInt64 aRetaindLatestGrade = [aPairedMainBranchSandbox retainLatestGradeOfNursery];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainLatestGradeResponse];
        [aResponse addArgumentOfTypeUInt64WithValue:aRetaindLatestGrade];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindRetainGradeIfValid)
    {
        NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
        NUUInt64 aGrade = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
        NUPairedMainBranchSandbox *aPairedMainBranchSandbox = [self pairedMainBranchSandboxFor:aPairID];
        
        NUUInt64 aRetaindGradeOrNilGrade = [[[self netService] nursery] retainGradeIfValid:aGrade bySandbox:aPairedMainBranchSandbox];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainGradeIfValidResponse];
        [aResponse addArgumentOfTypeUInt64WithValue:aRetaindGradeOrNilGrade];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindRetainGrade)
    {
        NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
        NUUInt64 aGrade = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
        
        [[[self netService] nursery] retainGrade:aGrade bySandboxWithID:aPairID];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainGradeResponse];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindReleaseGradeLessThan)
    {
        NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
        NUUInt64 aGrade = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
        
        [[[self netService] nursery] releaseGradeLessThan:aGrade bySandboxWithID:aPairID];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindReleaseGradeLessThanResponse];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindCallForPupil)
    {
        NUUInt64 anOOP = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
        NUUInt64 aGrade = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
          NUUInt64 aPairID = [[[self receivedMessage] argumentAt:2] UInt64FromValue];
        BOOL aContainsFellowPupils = [[[self receivedMessage] argumentAt:3] BOOLFromValue];
      
        NUPairedMainBranchSandbox *aPairdMainBranchSandbox = [self pairedMainBranchSandboxFor:aPairID];
        
        NSData *aPupilsData = [aPairdMainBranchSandbox callForPupilWithOOP:anOOP  gradeLessThanOrEqualTo:aGrade containsFellowPupils:aContainsFellowPupils];
        
        NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindCallForPupilResponse];
        
        [aResponse addArgumentOfTypeBytesWithValue:(void *)[aPupilsData bytes] length:[aPupilsData length]];
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    else if (aMessageKind == NUNurseryNetMessageKindFarmOutPupils)
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
        [aResponse serialize];
        [self setSendingMessage:aResponse];
    }
    
    [[self outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
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
