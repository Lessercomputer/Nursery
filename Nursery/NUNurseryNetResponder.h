//
//  NUNurseryNetResponder.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/01.
//

#import "NUNurseryNetServiceIO.h"

@class NSMutableDictionary;
@class NUNurseryNetService, NUPairedMainBranchGarden, NUMainBranchNursery, NUPupilNoteCache;

@interface NUNurseryNetResponder : NUNurseryNetServiceIO

@property (nonatomic, retain) NSMutableDictionary *pairedGardens;
@property (nonatomic, assign) NUNurseryNetService *netService;
@property (nonatomic) NUUInt64 maxFellowPupilNotesSizeInBytes;
@property (nonatomic) BOOL stopsAfterMessegeSend;

- (instancetype)initWithNetService:(NUNurseryNetService *)aNetService inputStream:(NSInputStream *)anInputStream outputStream:(NSOutputStream *)anOutputStream;

- (void)start;
- (void)stop;

@end

@interface NUNurseryNetResponder (Private)

- (NUMainBranchNursery *)nursery;
- (NUPupilNoteCache *)pupilNoteCache;

- (NUNurseryNetMessage *)responseForOpenGarden;
- (NUNurseryNetMessage *)responseForCloseGarden;
- (NUNurseryNetMessage *)responseForRootOOP;
- (NUNurseryNetMessage *)responseForLatestGrade;
- (NUNurseryNetMessage *)responseForOlderRetainedGrade;
- (NUNurseryNetMessage *)responseForRetainLatestGrade;
- (NUNurseryNetMessage *)responseForRetainGradeIfValid;
- (NUNurseryNetMessage *)responseForRetainGrade;
- (NUNurseryNetMessage *)responseForReleaseGradeLessThan;
- (NUNurseryNetMessage *)responseForCallForPupil;
- (NUNurseryNetMessage *)responseForFarmOutPupils;
- (NUNurseryNetMessage *)responseForNetClientWillStop;

@end
