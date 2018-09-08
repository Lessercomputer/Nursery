//
//  NUBell.h
//  Nursery
//
//  Created by Akifumi Takata on 11/02/24.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSObject.h>

#import "NUTypes.h"

@class NUGarden;


@interface NUBell : NSObject <NSCopying>
{
	NUBellBall ball;
    NUUInt64 gradeAtCallFor;
    NUUInt64 gradeForGardenSeeker;
	NUGarden *garden;
    BOOL isLoaded;
	id object;
}

+ (id)bellWithBall:(NUBellBall)aBall;
+ (id)bellWithBall:(NUBellBall)aBall garden:(NUGarden *)aGarden;
+ (id)bellWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded garden:(NUGarden *)aGarden;

- (id)initWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded garden:(NUGarden *)aGarden;

- (NUBellBall)ball;
- (NUUInt64)OOP;
- (NUUInt64)grade;
- (NUUInt64)gradeAtCallFor;
- (NUGarden *)garden;

- (id)object;

- (BOOL)isLoaded;
- (BOOL)hasObject;
- (BOOL)isEqualToBell:(NUBell *)anOOP;

- (void)markChanged;
- (void)unmarkChanged;

- (BOOL)gradeIsUnmatched;

- (BOOL)isInvalidated;

@end

@interface NSObject (NUBell)

- (BOOL)isBell;

@end
