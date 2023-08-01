//
//  NUNurseryNetService.h
//  Nursery
//
//  Created by Akifumi Takata on 2017/12/31.
//

#import <objc/NSObjCRuntime.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSNetServices.h>

@class NSString;

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

@class NUMainBranchNursery;

@interface NUNurseryNetService : NSObject <NSNetServiceDelegate>

+ (instancetype)netServiceWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;
- (instancetype)initWithNursery:(NUMainBranchNursery *)aNursery serviceName:(NSString *)aServiceName;

- (void)start;
- (void)stop;

- (BOOL)isRunning;

@end
