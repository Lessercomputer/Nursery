//
//  NUBell.h
//  Nursery
//
//  Created by Akifumi Takata on 11/02/24.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUTypes.h"

@class NUSandbox;


@interface NUBell : NSObject <NSCopying>
{
	NUBellBall ball;
    NUUInt64 gradeAtCallFor;
    NUUInt64 gradeForSeeker;
	NUSandbox *sandbox;
    BOOL isLoaded;
	id object;
}

+ (id)bellWithBall:(NUBellBall)aBall;
+ (id)bellWithBall:(NUBellBall)aBall sandbox:(NUSandbox *)aSandbox;
+ (id)bellWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded sandbox:(NUSandbox *)aSandbox;

- (id)initWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded sandbox:(NUSandbox *)aSandbox;

- (NUBellBall)ball;
- (void)setBall:(NUBellBall)aBall;

- (NUUInt64)OOP;
- (void)setOOP:(NUUInt64)anOOP;

- (NUUInt64)grade;
- (void)setGrade:(NUUInt64)aGrade;

- (NUUInt64)gradeAtCallFor;
- (void)setGradeAtCallFor:(NUUInt64)aGrade;

- (NUUInt64)gradeForSeeker;
- (void)setGradeForSeeker:(NUUInt64)aGrade;

- (NUSandbox *)sandbox;
- (void)setSandbox:(NUSandbox *)aSandbox;

- (id)object;
- (void)setObject:(id)anObject;

- (id)loadObject;

- (BOOL)isLoaded;
- (BOOL)hasObject;
- (BOOL)isEqualToBell:(NUBell *)anOOP;

- (void)markChanged;

- (void)invalidate;
- (void)invalidateObjectIfNotReferenced;

@end

@interface NUBell (Private)

- (void)setIsLoaded:(BOOL)aLoadedFlag;

@end

@interface NSObject (NUBell)

- (BOOL)isBell;

@end
