//
//  NUBell.h
//  Nursery
//
//  Created by P,T,A on 11/02/24.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

@class NUPlayLot;


@interface NUBell : NSObject <NSCopying>
{
	NUBellBall ball;
    NUUInt64 gradeAtCallFor;
    NUUInt64 gradeForStalker;
	NUPlayLot *playLot;
    BOOL isLoaded;
	id object;
}

+ (id)bellWithBall:(NUBellBall)aBall;
+ (id)bellWithBall:(NUBellBall)aBall playLot:(NUPlayLot *)aPlayLot;
+ (id)bellWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded playLot:(NUPlayLot *)aPlayLot;

- (id)initWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded playLot:(NUPlayLot *)aPlayLot;

- (NUBellBall)ball;
- (void)setBall:(NUBellBall)aBall;

- (NUUInt64)OOP;
- (void)setOOP:(NUUInt64)anOOP;

- (NUUInt64)grade;
- (void)setGrade:(NUUInt64)aGrade;

- (NUUInt64)gradeAtCallFor;
- (void)setGradeAtCallFor:(NUUInt64)aGrade;

- (NUUInt64)gradeForKidnapper;
- (void)setGradeForKidnapper:(NUUInt64)aGrade;

- (NUPlayLot *)playLot;
- (void)setPlayLot:(NUPlayLot *)aPlayLot;

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
