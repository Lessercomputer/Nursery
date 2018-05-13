//
//  NUNurseryNetResponder.m
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/01.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSDictionary.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSData.h>
#import <Foundation/NSArray.h>

#import "NUNurseryNetResponder.h"
#import "NUNurseryNetService.h"
#import "NUNurseryNetService+Project.h"
#import "NUNursery+Project.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUNurseryNetMessage.h"
#import "NUNurseryNetMessageArgument.h"
#import "NUGarden+Project.h"
#import "NUPairedMainBranchGarden.h"
#import "NUPairedMainBranchAliaser.h"
#import "NUBranchAliaser.h"
#import "NUPupilNoteCache.h"

const NSTimeInterval NUNurseryNetResponderSleepTimeInterval = 0.001;

@implementation NUNurseryNetResponder

- (instancetype)initWithNetService:(NUNurseryNetService *)aNetService inputStream:(NSInputStream *)anInputStream outputStream:(NSOutputStream *)anOutputStream
{
    if (self = [super init])
    {
        _pairedGardens = [NSMutableDictionary new];
        _netService = aNetService;
        _inputStream = [anInputStream retain];
        _outputStream = [anOutputStream retain];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc:%@", self);

    [_pairedGardens release];
    
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
    
    if (aMessageKind == NUNurseryNetMessageKindOpenGarden)
    {
        aResponse = [self responseForOpenGarden];
    }
    else if (aMessageKind == NUNurseryNetMessageKindCloseGarden)
    {
        aResponse = [self responseForCloseGarden];
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

- (NUPairedMainBranchGarden *)pairedMainBranchGardenFor:(NUUInt64)aPairID
{
    return [[self pairedGardens] objectForKey:@(aPairID)];
}

@end

@implementation NUNurseryNetResponder (Private)

- (NUMainBranchNursery *)nursery
{
    return [[self netService] nursery];
}

- (NUPupilNoteCache *)pupilNoteCache
{
    return [[self netService] pupilNoteCache];
}

- (NUNurseryNetMessage *)responseForOpenGarden
{
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindOpenGardenResponse];
    
    [[self nursery] open];
    
    NUUInt64 aPairID = [[self nursery] newGardenID];
    NUPairedMainBranchGarden *aPairedMainBranchGarden = [[self nursery] makePairdGarden];
    
    [[self pairedGardens] setObject:aPairedMainBranchGarden forKey:@(aPairID)];
    
    [aResponse addArgumentOfTypeUInt64WithValue:aPairID];

    return aResponse;
}

- (NUNurseryNetMessage *)responseForCloseGarden
{
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindCloseGardenResponse];
    
    NSNumber *aPairID = [[[self receivedMessage] argumentAt:0] value];
    [[self pairedGardens] removeObjectForKey:aPairID];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForRootOOP
{
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUPairedMainBranchGarden *aPairedMainBranchGarden = [self pairedMainBranchGardenFor:aPairID];
        
    NUUInt64 aRootOOP = [[aPairedMainBranchGarden pairedMainBranchAliaser] rootOOP];
    
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
    NUPairedMainBranchGarden *aPairedMainBranchGarden = [self pairedMainBranchGardenFor:aPairID];
    
    NUUInt64 aRetaindLatestGrade = [aPairedMainBranchGarden retainLatestGradeOfNursery];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainLatestGradeResponse];
    [aResponse addArgumentOfTypeUInt64WithValue:aRetaindLatestGrade];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForRetainGradeIfValid
{
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUUInt64 aGrade = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
    NUPairedMainBranchGarden *aPairedMainBranchGarden = [self pairedMainBranchGardenFor:aPairID];
    
    NUUInt64 aRetaindGradeOrNilGrade = [[[self netService] nursery] retainGradeIfValid:aGrade byGarden:aPairedMainBranchGarden];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainGradeIfValidResponse];
    [aResponse addArgumentOfTypeUInt64WithValue:aRetaindGradeOrNilGrade];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForRetainGrade
{
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUUInt64 aGrade = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
    
    [[[self netService] nursery] retainGrade:aGrade byGardenWithID:aPairID];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindRetainGradeResponse];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForReleaseGradeLessThan
{
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUUInt64 aGrade = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    
    [[[self netService] nursery] releaseGradeLessThan:aGrade byGardenWithID:aPairID];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindReleaseGradeLessThanResponse];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForCallForPupil
{
    NUUInt64 anOOP = [[[self receivedMessage] argumentAt:0] UInt64FromValue];
    NUUInt64 aGrade = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:2] UInt64FromValue];
    BOOL aContainsFellowPupils = [[[self receivedMessage] argumentAt:3] BOOLFromValue];
    
    NUPairedMainBranchGarden *aPairdMainBranchGarden = [self pairedMainBranchGardenFor:aPairID];

    NSArray *aPupilNotes = nil;
    NUPupilNote *aPupilNote = [[self pupilNoteCache] pupilNoteForOOP:anOOP grade:aGrade containsFellowPupils:aContainsFellowPupils maxPupilNotesSizeInBytes:1024 * 4 * 4 pupilNotesInto:&aPupilNotes];
    NSData *aPupilNotesData = nil;
    
    if (aPupilNote)
    {
        aPupilNotesData = [[aPairdMainBranchGarden pairedMainBranchAliaser] dataFromPupilNotes:aPupilNotes];
    }
    else
    {
        aPupilNotesData = [aPairdMainBranchGarden callForPupilWithOOP:anOOP gradeLessThanOrEqualTo:aGrade containsFellowPupils:aContainsFellowPupils];
        aPupilNotes = [NUBranchAliaser pupilNotesFromPupilNoteData:aPupilNotesData pupilNoteOOP:anOOP pupilNoteInto:NULL];
        [[self pupilNoteCache] addPupilNotes:aPupilNotes grade:aGrade];
    }
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindCallForPupilResponse];
    
    [aResponse addArgumentOfTypeBytesWithValue:(void *)[aPupilNotesData bytes] length:[aPupilNotesData length]];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForFarmOutPupils
{
    NSData *aPupilData = [[[self receivedMessage] argumentAt:0] dataFromValue];
    NUUInt64 aRootOOP = [[[self receivedMessage] argumentAt:1] UInt64FromValue];
    NUUInt64 aPairID = [[[self receivedMessage] argumentAt:2] UInt64FromValue];
    NUPairedMainBranchGarden *aPairedMainBranchGarden = [self pairedMainBranchGardenFor:aPairID];
    NSData *aFixedOOPs = nil;
    NUUInt64 aLatestGrade;
    
    NUFarmOutStatus aFarmOutStatus = [aPairedMainBranchGarden farmOutPupils:aPupilData rootOOP:aRootOOP fixedOOPs:&aFixedOOPs latestGrade:&aLatestGrade];
    
    NUNurseryNetMessage *aResponse = [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindFarmOutPupilsResponse];
    [aResponse addArgumentOfTypeUInt64WithValue:aFarmOutStatus];
    [aResponse addArgumentOfTypeBytesWithValue:(void *)[aFixedOOPs bytes] length:[aFixedOOPs length]];
    [aResponse addArgumentOfTypeUInt64WithValue:aLatestGrade];
    
    return aResponse;
}

- (NUNurseryNetMessage *)responseForNetClientWillStop
{
    [self stop];
    
    return [NUNurseryNetMessage messageOfKind:NUNurseryNetMessageKindNetClientWillStopResponse];;
}

@end
