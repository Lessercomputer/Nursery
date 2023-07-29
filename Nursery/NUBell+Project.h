//
//  NUBell+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/29.
//

#import "NUBell.h"

@interface NUBell (Private)

+ (NUBell *)invalidatedBell;

- (NUUInt64)gradeForGardenSeeker;

- (void)setBall:(NUBellBall)aBall;
- (void)setOOP:(NUUInt64)anOOP;
- (void)setGrade:(NUUInt64)aGrade;
- (void)setGradeAtCallFor:(NUUInt64)aGrade;
- (void)setGradeForGardenSeeker:(NUUInt64)aGrade;
- (void)setGarden:(NUGarden *)aGarden;
- (void)setObject:(id)anObject;

- (id)loadObject;

- (void)invalidate;

- (void)setIsLoaded:(BOOL)aLoadedFlag;

@end

@interface NUInvalidatedBell : NUBell

@end
