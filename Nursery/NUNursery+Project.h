//
//  NUNursery+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/28.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUNursery.h"

@class NUCharacter, NUBell, NUObjectWrapper, NUAliaser, NUNurseryRoot;

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

@interface NUNursery (Testing)

- (BOOL)isMainBranch;

@end

@interface NUNursery (Private)

- (BOOL)open;
- (void)close;

- (NUNurseryOpenStatus)openStatus;
- (void)setOpenStatus:(NUNurseryOpenStatus)aStatus;

@end
