//
//  NUNurseryNetResponder.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/01.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUNurseryNetServiceIO.h"

@class NUNurseryNetService, NUPairedMainBranchGarden, NUMainBranchNursery;

@interface NUNurseryNetResponder : NUNurseryNetServiceIO

@property (nonatomic, retain) NSMutableDictionary *pairedGardenes;
@property (nonatomic, assign) NUNurseryNetService *netService;

- (instancetype)initWithNetService:(NUNurseryNetService *)aNetService inputStream:(NSInputStream *)anInputStream outputStream:(NSOutputStream *)anOutputStream;

- (void)start;
- (void)stop;

@end

@interface NUNurseryNetResponder (Private)

- (NUMainBranchNursery *)nursery;

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
