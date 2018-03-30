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
    NUNurseryNetServiceStatusStopped
} NUNurseryNetServiceStatus;

@class NUMainBranchNursery, NUNurseryNetResponder;

@interface NUNurseryNetService : NSObject <NSNetServiceDelegate>
{
    NUNurseryNetServiceStatus status;
}
@property (nonatomic, retain) NSNetService *netService;
@property (nonatomic, retain) NSMutableArray *netResponders;
@property (nonatomic, retain) NUMainBranchNursery *nursery;
@property (nonatomic, retain) NSString *serviceName;
@property (nonatomic, retain) NSThread *netServiceThread;
@property (nonatomic, retain) NSLock *statusLock;
@property (nonatomic, retain) NSCondition *statusCondition;
@property (nonatomic) int port;

+ (instancetype)netServiceWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;
- (instancetype)initWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;

- (void)start;
- (void)stop;

- (NUMainBranchNursery *)nursery;

- (void)netResponderDidStop:(NUNurseryNetResponder *)sender;

@end
