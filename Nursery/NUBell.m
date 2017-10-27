//
//  NUOOP.m
//  Nursery
//
//  Created by P,T,A on 11/02/24.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUBell.h"
#import "NUSandbox.h"
#import "NUCoding.h"
#import "NUBellBall.h"


@implementation NUBell

+ (id)bellWithBall:(NUBellBall)aBall
{
    return [[[self alloc] initWithBall:aBall isLoaded:NO sandbox:nil] autorelease];
}

+ (id)bellWithBall:(NUBellBall)aBall sandbox:(NUSandbox *)aSandbox
{
    return [[[self alloc] initWithBall:aBall isLoaded:NO sandbox:aSandbox] autorelease];
}

+ (id)bellWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded sandbox:(NUSandbox *)aSandbox
{
	return [[[self alloc] initWithBall:aBall isLoaded:anIsLoaded sandbox:aSandbox] autorelease];
}

- (id)initWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded sandbox:(NUSandbox *)aSandbox
{
	if (self = [super init])
    {
        ball = aBall;
        isLoaded = anIsLoaded;
        gradeAtCallFor = NUNilGrade;
        sandbox = aSandbox;
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

- (NUSandbox *)sandbox
{
	return sandbox;
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

- (NUUInt64)gradeForSeeker
{
    return gradeForSeeker;
}

- (void)setGradeForSeeker:(NUUInt64)aGrade
{
    gradeForSeeker = aGrade;
}

- (void)setSandbox:(NUSandbox *)aSandbox
{
	sandbox = aSandbox;
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
    id anObject = [[self sandbox] objectForBell:self];
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
	if (![[self sandbox] isEqual:[anOOP sandbox]]) return NO;
	
	return YES;
}

- (void)markChanged
{
    [[self sandbox] markChangedObject:[self object]];
}

- (void)invalidate
{
    [[self sandbox] invalidateBell:self];
}

- (void)invalidateObjectIfNotReferenced
{
    [[self sandbox] invalidateObjectIfNotReferencedForBell:self];
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
