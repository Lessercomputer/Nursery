//
//  NUNurseryNetService.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/31.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

extern NSString *NUNurseryNetServiceType;

extern NSString *NUNurseryNetServiceNetworkException;

typedef enum : NSUInteger {
    NUNurseryNetServiceStatusNone,
    NUNurseryNetServiceStatusPublishing,
    NUNurseryNetServiceStatusRunning,
    NUNurseryNetServiceStatusShouldStop,
    NUNurseryNetServiceStatusStopping,
    NUNurseryNetServiceStatusStopped,
    NUNurseryNetServiceStatusFailed
} NUNurseryNetServiceStatus;

@class NUMainBranchNursery, NUNurseryNetResponder;

@interface NUNurseryNetService : NSObject <NSNetServiceDelegate>

+ (instancetype)netServiceWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;
- (instancetype)initWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;

- (void)start;
- (void)stop;

- (NUMainBranchNursery *)nursery;

- (void)netResponderDidStop:(NUNurseryNetResponder *)sender;

@end
