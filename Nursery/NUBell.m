//
//  NUBell.m
//  Nursery
//
//  Created by Akifumi Takata on 11/02/24.
//

#import <Foundation/NSString.h>

#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUCoding.h"
#import "NUBellBall.h"
#import "NUObjectTable.h"

NSString *NUInvalidatedObjectException = @"NUInvalidatedObjectException";

static NUInvalidatedBell *invalidatedBell = nil;

@implementation NUBell

+ (void)initialize
{
    if (!invalidatedBell)
    {
        invalidatedBell = [[NUInvalidatedBell alloc] initWithBall:NUMakeBellBall(NUNilOOP, NUNilGrade) isLoaded:NO garden:nil];
    }
}

+ (NUBell *)invalidatedBell
{
    return invalidatedBell;
}

+ (id)bellWithBall:(NUBellBall)aBall
{
    return [[[self alloc] initWithBall:aBall isLoaded:NO garden:nil] autorelease];
}

+ (id)bellWithBall:(NUBellBall)aBall garden:(NUGarden *)aGarden
{
    return [[[self alloc] initWithBall:aBall isLoaded:NO garden:aGarden] autorelease];
}

+ (id)bellWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded garden:(NUGarden *)aGarden
{
	return [[[self alloc] initWithBall:aBall isLoaded:anIsLoaded garden:aGarden] autorelease];
}

- (id)initWithBall:(NUBellBall)aBall isLoaded:(BOOL)anIsLoaded garden:(NUGarden *)aGarden
{
	if (self = [super init])
    {
        ball = aBall;
        isLoaded = anIsLoaded;
        gradeAtCallFor = NUNilGrade;
        garden = aGarden;
	}
    
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (void)dealloc
{
    [object setBell:nil];
    
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

- (NUGarden *)garden
{
	return garden;
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

- (NUUInt64)gradeForGardenSeeker
{
    return gradeForGardenSeeker;
}

- (void)setGradeForGardenSeeker:(NUUInt64)aGrade
{
    gradeForGardenSeeker = aGrade;
}

- (void)setGarden:(NUGarden *)aGarden
{
	garden = aGarden;
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
    id anObject = [[self garden] objectForBell:self];
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
    return (NSUInteger)ball.oop;
}

- (BOOL)isEqual:(id)anObject
{
	return [anObject isBell] ? [self isEqualToBell:anObject] : NO;
}

- (BOOL)isEqualToBell:(NUBell *)anOOP
{
	if (self == anOOP) return YES;
	if ([self OOP] != [anOOP OOP]) return NO;
	if (![[self garden] isEqual:[anOOP garden]]) return NO;
	
	return YES;
}

- (void)markChanged
{
    [[self garden] markChangedObject:[self object]];
}

- (void)unmarkChanged
{
    [[self garden] unmarkChangedObject:[self object]];
}

- (BOOL)gradeIsUnmatched
{
    return [[self garden] bellGradeIsUnmatched:self];
}

- (void)invalidate
{
    [[self garden] invalidateBell:self];
}

- (void)setIsLoaded:(BOOL)aLoadedFlag
{
    isLoaded = aLoadedFlag;
}

- (BOOL)isInvalidated
{
    return NO;
}

- (NSString *)description
{
	return [NSString stringWithFormat:
				@"<%@:%p>rawOOP: %llu", NSStringFromClass([self class]), self, [self OOP]];
}

@end

@implementation NUInvalidatedBell

- (instancetype)retain
{
    return self;
}

- (oneway void)release
{
}

- (BOOL)isInvalidated
{
    return YES;
}

@end

@implementation NSObject (NUBell)

- (BOOL)isBell { return NO; }

@end
