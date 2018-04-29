//
//  NUBell+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/29.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUBell.h"

@interface NUBell (Private)

- (NUUInt64)gradeForSeeker;

- (void)setBall:(NUBellBall)aBall;
- (void)setOOP:(NUUInt64)anOOP;
- (void)setGrade:(NUUInt64)aGrade;
- (void)setGradeAtCallFor:(NUUInt64)aGrade;
- (void)setGradeForSeeker:(NUUInt64)aGrade;
- (void)setGarden:(NUGarden *)aGarden;
- (void)setObject:(id)anObject;

- (id)loadObject;

- (void)invalidate;
- (void)invalidateObjectIfNotReferenced;

- (void)setIsLoaded:(BOOL)aLoadedFlag;

@end
