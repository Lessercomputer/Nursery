//
//  NUNurseryNetService.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/31.
//  Copyright © 2017年 Nursery-Framework. All rights reserved.
//

extern NSString *NUNurseryNetServiceType;

typedef enum : NSUInteger {
    NUNurseryNetServiceStatusNone,
    NUNurseryNetServiceStatusPublishing,
    NUNurseryNetServiceStatusRunning
} NUNurseryNetServiceStatus;

@class NUMainBranchNursery;

@interface NUNurseryNetService : NSObject <NSNetServiceDelegate>

@property (nonatomic, retain) NSNetService *netService;
@property (nonatomic, retain) NSMutableArray *netResponders;
@property (nonatomic, retain) NUMainBranchNursery *nursery;
@property (nonatomic, retain) NSString *serviceName;
@property (nonatomic, retain) NSThread *netServiceThread;
@property (nonatomic) NUNurseryNetServiceStatus status;
@property (nonatomic, retain) NSCondition *statusCondition;
@property (nonatomic) int port;

+ (instancetype)netServiceWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;
- (instancetype)initWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;

- (void)start;
- (void)stop;

- (NUMainBranchNursery *)nursery;

@end
