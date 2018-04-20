//
//  NUNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

@class NUCharacter, NUBell, NUObjectWrapper, NUAliaser, NUNurseryRoot, NUGarden;

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

@interface NUNursery (Grade)

- (NUUInt64)latestGrade:(NUGarden *)sender;
- (NUUInt64)olderRetainedGrade:(NUGarden *)sender;

- (NUUInt64)retainLatestGradeByGarden:(NUGarden *)sender;
- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade byGarden:(NUGarden *)sender;
- (void)retainGrade:(NUUInt64)aGrade byGarden:(NUGarden *)sender;
- (void)releaseGradeLessThan:(NUUInt64)aGrade byGarden:(NUGarden *)sender;

- (NUUInt64)retainLatestGradeByGardenWithID:(NUUInt64)anID;
- (void)retainGrade:(NUUInt64)aGrade byGardenWithID:(NUUInt64)anID;
- (void)releaseGradeLessThan:(NUUInt64)aGrade byGardenWithID:(NUUInt64)anID;

@end

@interface NUNursery (Garden)

- (NUGarden *)makeGarden;
- (NUGarden *)makeGardenWithGrade:(NUUInt64)aGrade;

@end

@interface NUNursery (Testing)

- (BOOL)isMainBranch;

@end

@interface NUNursery (Private)

- (BOOL)open;
- (void)close;

- (NUNurseryOpenStatus)openStatus;
- (void)setOpenStatus:(NUNurseryOpenStatus)aStatus;

@end
