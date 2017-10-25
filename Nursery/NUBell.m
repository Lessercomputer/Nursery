//
//  NUOOP.m
//  Nursery
//
//  Created by P,T,A on 11/02/24.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUBell.h"
#import "NUPlayLot.h"
#import "NUCoding.h"
#import "NUBellBall.h"


@implementation NUBell

+ (id)bellWithBall:(NUBellBall)aBall
{
    return [[[self alloc] initWithBall:aBall isLoaded:NO playLot:nil] autorelease];
}

+ (id)bellWithBall:(NUBellBall)aBall playLot:(NUPlayLot *)aPlayLot
{
    return [[[self alloc] initWithBall:aBall isLoaded:NO playLot:aPlayLot] autorelease];
}

+ (id)bellWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded playLot:(NUPlayLot *)aPlayLot
{
	return [[[self alloc] initWithBall:aBall isLoaded:anIsLoaded playLot:aPlayLot] autorelease];
}

- (id)initWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded playLot:(NUPlayLot *)aPlayLot
{
	if (self = [super init])
    {
        ball = aBall;
        isLoaded = anIsLoaded;
        gradeAtCallFor = NUNilGrade;
        playLot = aPlayLot;
	}
    
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (void)dealloc
{
    [object release];
    object = nil;
    
    [super dealloc];
}

- (NUBellBall)ball
{
    return ball;
}

- (void)setBall:(NUBellBall)aBall
{
    ball = aBall;
}

- (NUUInt64)OOP
{
	return ball.oop;
}

- (void)setOOP:(NUUInt64)anOOP
{
	ball.oop = anOOP;
}

- (NUPlayLot *)playLot
{
	return playLot;
}

- (NUUInt64)grade
{
    return ball.grade;
}

- (void)setGrade:(NUUInt64)aGrade
{
    ball.grade = aGrade;
}

- (NUUInt64)gradeAtCallFor
{
    return gradeAtCallFor;
}

- (void)setGradeAtCallFor:(NUUInt64)aGrade
{
    gradeAtCallFor = aGrade;
}

- (NUUInt64)gradeForKidnapper
{
    return gradeForStalker;
}

- (void)setGradeForKidnapper:(NUUInt64)aGrade
{
    gradeForStalker = aGrade;
}

- (void)setPlayLot:(NUPlayLot *)aPlayLot
{
	playLot = aPlayLot;
}

- (id)object
{
    id anObject = object;
    if (!anObject) anObject = [self loadObject];
	return anObject;
}

- (void)setObject:(id)anObject
{
	[object autorelease];
	object = [anObject retain];
}

- (id)loadObject
{
    id anObject = [[self playLot] objectForBell:self];
	return anObject;
}

- (BOOL)isBell { return YES; }

- (BOOL)isLoaded
{
	return isLoaded;
}

- (BOOL)hasObject
{
    return object ? YES : NO;
}

- (NSUInteger)hash
{
    return ball.oop;
}

- (BOOL)isEqual:(id)anObject
{
	return [anObject isBell] ? [self isEqualToBell:anObject] : NO;
}

- (BOOL)isEqualToBell:(NUBell *)anOOP
{
	if (self == anOOP) return YES;
	if ([self OOP] != [anOOP OOP]) return NO;
	if (![[self playLot] isEqual:[anOOP playLot]]) return NO;
	
	return YES;
}

- (void)markChanged
{
    [[self playLot] markChangedObject:[self object]];
}

- (void)invalidate
{
    [[self playLot] invalidateBell:self];
}

- (void)invalidateObjectIfNotReferenced
{
    [[self playLot] invalidateObjectIfNotReferencedForBell:self];
}

- (NSString *)description
{
	return [NSString stringWithFormat:
				@"<%@:%p>rawOOP: %llu", NSStringFromClass([self class]), self, [self OOP]];
}

@end

@implementation NUBell (Private)

- (void)setIsLoaded:(BOOL)aLoadedFlag
{
    isLoaded = aLoadedFlag;
}

@end

@implementation NSObject (NUBell)

- (BOOL)isBell { return NO; }

@end
