//
//  NUNursery.h
//  Nursery
//
//  Created by P,T,A on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

@class NUCharacter, NUBell, NUObjectWrapper, NUAliaser, NUNurseryRoot, NUPlayLot;

extern NSString * const NUOOPNotFoundException;

extern NUUInt64 NUNilPlayLotID;
extern NUUInt64 NUFirstPlayLotID;

typedef enum : NSUInteger {
    NUNurseryOpenStatusClose,
    NUNurseryOpenStatusOpenWithoutFile,
    NUNurseryOpenStatusOpenWithFile,
} NUNurseryOpenStatus;

@interface NUNursery : NSObject
{
    NUNurseryOpenStatus openStatus;
	NUPlayLot *playLot;
}
@end

@interface NUNursery (InitializingAndRelease)

@end

@interface NUNursery (Accessing)

- (NUPlayLot *)playLot;

@end

@interface NUNursery (Grade)

- (NUUInt64)latestGrade:(NUPlayLot *)sender;
- (NUUInt64)olderRetainedGrade:(NUPlayLot *)sender;

- (NUUInt64)retainLatestGradeByPlayLot:(NUPlayLot *)sender;
- (NUUInt64)retainGradeIfValid:(NUUInt64)aGrade byPlayLot:(NUPlayLot *)sender;
- (void)retainGrade:(NUUInt64)aGrade byPlayLot:(NUPlayLot *)sender;
- (void)releaseGradeLessThan:(NUUInt64)aGrade byPlayLot:(NUPlayLot *)sender;

- (NUUInt64)retainLatestGradeByPlayLotWithID:(NUUInt64)anID;
- (void)retainGrade:(NUUInt64)aGrade byPlayLotWithID:(NUUInt64)anID;
- (void)releaseGradeLessThan:(NUUInt64)aGrade byPlayLotWithID:(NUUInt64)anID;

@end

@interface NUNursery (PlayLot)

- (NUPlayLot *)createPlayLot;
- (NUPlayLot *)createPlayLotWithGrade:(NUUInt64)aGrade;

- (void)playLotDidClose:(NUPlayLot *)aPlayLot;

@end

@interface NUNursery (Testing)

- (BOOL)isMainBranch;

@end

@interface NUNursery (Private)

- (void)setPlayLot:(NUPlayLot *)aPlayLot;

- (BOOL)open;
- (void)close;

- (NUNurseryOpenStatus)openStatus;
- (void)setOpenStatus:(NUNurseryOpenStatus)aStatus;

@end
