//
//  NUNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSObject.h>
#import <Nursery/NUTypes.h>

@class NSString;
@class NUGarden;

extern NSString * const NUOOPNotFoundException;

extern NUUInt64 NUNilGardenID;
extern NUUInt64 NUFirstGardenID;

typedef enum : NSUInteger {
    NUNurseryOpenStatusClose,
    NUNurseryOpenStatusOpenWithoutFile,
    NUNurseryOpenStatusOpenWithFile,
} NUNurseryOpenStatus;

@interface NUNursery : NSObject
{
    NUNurseryOpenStatus openStatus;
}
@end

@interface NUNursery (InitializingAndRelease)

@end

@interface NUNursery (Accessing)

@end

@interface NUNursery (Testing)

- (BOOL)isMainBranch;

@end

@interface NUNursery (Garden)

- (NUGarden *)makeGarden;
- (NUGarden *)makeGardenWithGrade:(NUUInt64)aGrade;

@end
