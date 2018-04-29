//
//  NUPairedMainBranchAliaser.h
//  Nursery
//
//  Created by Akifumi Takata on 2014/03/15.
//
//

#import "NUMainBranchAliaser.h"

@class NSMutableData;
@class NUPairedMainBranchGarden, NUPupilNote, NUU64ODictionary;

@interface NUPairedMainBranchAliaser : NUMainBranchAliaser

@property (nonatomic, retain) NSArray *pupils;
@property (nonatomic, retain) NUU64ODictionary *pupilsDictionary;
@property (nonatomic, retain) NUU64ODictionary *fixedOOPToProbationaryPupils;

- (NUPairedMainBranchGarden *)pairedMainBranchGarden;

@end

@interface NUPairedMainBranchAliaser (Pupil)

- (NSData *)callForPupilWithOOP:(NUUInt64)anOOP containsFellowPupils:(BOOL)aContainsFellowPupils;

- (void)addPupilsDataFromLocation:(NUUInt64)anObjectLocation toData:(NSMutableData *)aData;
- (void)addPupilDataAtLocation:(NUUInt64)anObjectLocation toData:(NSMutableData *)aData;
- (void)addPupilDataWithBellBall:(NUBellBall)aBellBall toData:(NSMutableData *)aData;

- (NSArray *)pupilsFromData:(NSData *)aPupilData;

- (void)fixProbationaryOOPsInPupils;
- (NUBellBall)fixedBellBallForPupilWithOOP:(NUUInt64)anOOP;
- (void)writeEncodedObjectsToPages;
- (NUUInt64)allocateObjectSpaceForPupil:(NUPupilNote *)aPupilNote;
- (NSData *)dataWithProbationaryOOPAndFixedOOP;
- (NUUInt64)fixedRootOOPForOOP:(NUUInt64)anOOP;

- (NSString *)descriptionForPupils;

@end
