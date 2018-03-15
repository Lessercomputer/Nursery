//
//  NUNurseryNetResponder.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/01/01.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUNurseryNetServiceIO.h"

@class NUNurseryNetService, NUPairedMainBranchSandbox, NUMainBranchNursery;

@interface NUNurseryNetResponder : NUNurseryNetServiceIO
{
    BOOL shouldStop;
}

@property (nonatomic, retain) NSMutableDictionary *pairedSandboxes;
@property (nonatomic, assign) NUNurseryNetService *netService;
@property (nonatomic, retain) NSLock *lockForShouldStop;

- (instancetype)initWithNetService:(NUNurseryNetService *)aNetService inputStream:(NSInputStream *)anInputStream outputStream:(NSOutputStream *)anOutputStream;

- (void)start;
- (void)stop;

@end

