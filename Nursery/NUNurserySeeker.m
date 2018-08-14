//
//  NUNurserySeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 11/08/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSException.h>
#import <Foundation/NSThread.h>
#import <Foundation/NSDate.h>

#import "NUNurserySeeker.h"
#import "NUUInt64Queue.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUSpaces.h"
#import "NUPages.h"
#import "NUObjectTable.h"
#import "NUReversedObjectTable.h"
#import "NUAperture.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUMainBranchAperture.h"
#import "NUAliaser.h"

const NUUInt64 NUSeekerPhaseOffset	= 101;
const NUUInt64 NUSeekerCurrentGradeOffset = 109;
const NUUInt64 NUSeekerNextOOPOfBellBallToCollectOffset = 117;
const NUUInt64 NUSeekerNextGradeOfBellBallToCollectOffset = 125;

const NUUInt32 NUSeekerDefaultGrayOOPCapacity = 50000;

@implementation NUNurserySeeker

+ (id)seekerWithGarden:(NUGarden *)aGarden
{
	return [[[self alloc] initWithGarden:aGarden] autorelease];
}

- (id)initWithGarden:(NUGarden *)aGarden
{
	if (self = [super initWithGarden:aGarden])
	{
        garden = [aGarden retain];
        currentPhase = NUSeekerNonePhase;
        shouldLoadGrayOOPs = NO;
        grayOOPs = [[NUUInt64Queue alloc] initWithCapacity:NUSeekerDefaultGrayOOPCapacity];
        aperture = [[NUMainBranchAperture alloc] initWithNursery:[aGarden nursery] garden:aGarden];
        nextBellBallToCollect = NUNotFoundBellBall;
    }
    
	return self;
}

- (void)dealloc
{
	[grayOOPs release];
	[aperture release];
    [garden release];
	
	[super dealloc];
}

- (void)objectDidEncode:(NUUInt64)anOOP
{
	[self pushOOPAsGrayIfBlack:anOOP];
}

- (void)save
{
	[[[self nursery] pages] writeUInt8:currentPhase at:NUSeekerPhaseOffset];
    [[[self nursery] pages] writeUInt64:[self grade] at:NUSeekerCurrentGradeOffset];
    [[[self nursery] pages] writeUInt64:nextBellBallToCollect.oop at:NUSeekerNextOOPOfBellBallToCollectOffset];
    [[[self nursery] pages] writeUInt64:nextBellBallToCollect.grade at:NUSeekerNextGradeOfBellBallToCollectOffset];
}

- (void)load
{
	currentPhase = [[[self nursery] pages] readUInt8At:NUSeekerPhaseOffset];
	if (currentPhase == NUSeekerSeekPhase) shouldLoadGrayOOPs = YES;
    [self setGrade:[[[self nursery] pages] readUInt64At:NUSeekerCurrentGradeOffset]];
    nextBellBallToCollect.oop = [[[self nursery] pages] readUInt64At:NUSeekerNextOOPOfBellBallToCollectOffset];
    nextBellBallToCollect.grade = [[[self nursery] pages] readUInt64At:NUSeekerNextGradeOfBellBallToCollectOffset];
}

- (NUMainBranchNursery *)nursery
{
    return (NUMainBranchNursery *)[[self garden] nursery];
}

- (NUUInt64)grade
{
    return grade;
}

@end

@implementation NUNurserySeeker (Private)

- (void)processOneUnit
{
    [self preprocess];

    [[self nursery] lock];

    switch (currentPhase)
    {
        case NUSeekerSeekPhase:
            [self loadGrayOOPsIfNeeded];
            [[self garden] moveUpTo:[self grade]];
            [self seekObjectsOneUnit];
            break;
        case NUSeekerCollectPhase:
            [[self garden] moveUpTo:[self grade]];
            [self collectObjectsOneUnit];
            break;
        case NUSeekerNonePhase:
//            [[[self nursery] spaces] validate];
//            [[self nursery] validateMappingOfObjectTableToReversedObjectTable];
            if ([self grade] != [[self nursery] gradeForSeeker])
            {
                currentPhase = NUSeekerSeekPhase;
                [self setGrade:[[self nursery] gradeForSeeker]];
                [[self garden] moveUpTo:[self grade]];
                [self pushRootOOP];
            }
    }

    [[self nursery] unlock];
}

- (void)preprocess
{
    [self resetAllGCMarksIfNeeded];
}

- (void)resetAllGCMarksIfNeeded
{
    if (nextBellBallToCollect.oop == 0 && nextBellBallToCollect.grade == 0)
    {
        @try
        {
            [[self nursery] lock];
        
            NUBellBall aBellBall = [[[self nursery] objectTable] firstBellBall];
            
            while (!NUBellBallEquals(aBellBall, NUNotFoundBellBall))
            {
                NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
                
                [[[self nursery] objectTable] setGCMark:(aGCMark & NUGCMarkWithoutColorBitsMask) | NUGCMarkWhite for:aBellBall];
                aBellBall = [[[self nursery] objectTable] bellBallGreaterThanBellBall:aBellBall];
            }
            
            nextBellBallToCollect = NUNotFoundBellBall;
            currentPhase = NUSeekerNonePhase;
            shouldLoadGrayOOPs = NO;
        }
        @finally
        {
            [[self nursery] unlock];
        }
    }
}

- (void)seekObjectsOneUnit
{
    if (currentPhase != NUSeekerSeekPhase)
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil];
    
    NSDate *aStopDate = [NSDate dateWithTimeIntervalSinceNow:0.001];
    
	while ([aStopDate timeIntervalSinceNow] > 0 && ([grayOOPs count] || shouldLoadGrayOOPs))
	{
        [self loadGrayOOPsIfNeeded];

		NUUInt64 anOOP = [self popGrayOOP];
        
		if (anOOP != NUNotFound64)
		{
            @try
            {
                [[self nursery] lock];
                
                NUUInt64 aGrade;
                if ([[[self nursery] objectTable] objectLocationForOOP:anOOP gradeLessThanOrEqualTo:[self grade] gradeInto:&aGrade] == NUNotFound64)
                    [[NSException exceptionWithName:NUObjectLocationNotFoundException reason:NUObjectLocationNotFoundException userInfo:nil] raise];
                
                [aperture peekAt:NUMakeBellBall(anOOP, aGrade)];
                
                while ([aperture hasNextFixedOOP])
                {
                    NUUInt64 aFixedOOP = [aperture nextFixedOOP];
                    if (aFixedOOP != NUNilOOP) [self pushOOPAsGrayIfWhite:aFixedOOP];
                }
                
                while ([aperture hasNextIndexedOOP])
                {
                    NUUInt64 anIndexedOOP = [aperture nextIndexedOOP];
                    if (anIndexedOOP != NUNilOOP) [self pushOOPAsGrayIfWhite:anIndexedOOP];
                }
                
                NUBellBall aBellBall = NUMakeBellBall(anOOP, aGrade);
                NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
                [[[self nursery] objectTable] setGCMark:(aGCMark & NUGCMarkWithoutColorBitsMask) | NUGCMarkBlack for:aBellBall];
            }
            @finally
            {
                [[self nursery] unlock];
            }
		}
	}
	
	if (!shouldLoadGrayOOPs && ![grayOOPs count])
        currentPhase = NUSeekerCollectPhase;
}

- (void)collectObjectsOneUnit
{
    if (currentPhase != NUSeekerCollectPhase)
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil];
    
    NSDate *aStopDate = [NSDate dateWithTimeIntervalSinceNow:0.001];
    NUBellBall aBellBall = NUMakeBellBall(0, 0);
    
    while ([aStopDate timeIntervalSinceNow] > 0 && !NUBellBallEquals(aBellBall, NUNotFoundBellBall))
    {
        @try
        {
            [[self nursery] lock];
            
            if (NUBellBallEquals(aBellBall, NUMakeBellBall(0, 0)))
            {
                if (NUBellBallEquals(nextBellBallToCollect, NUNotFoundBellBall))
                    aBellBall = [[[self nursery] objectTable] firstBellBall];
                else
                    aBellBall = nextBellBallToCollect;
            }
            
            [self collectObjectIfNeeded:aBellBall];
            aBellBall = [[[self nursery] objectTable] bellBallGreaterThanBellBall:aBellBall];
        }
        @finally
        {
            [[self nursery] unlock];
        }
    }
        
    nextBellBallToCollect = aBellBall;
    
    if (NUBellBallEquals(aBellBall, NUNotFoundBellBall))
    {
        currentPhase = NUSeekerNonePhase;
        [[self nursery] seekerDidFinishCollect:self];
        NSLog(@"%@:didFinishCollect", self);
    }
}

- (void)collectObjectIfNeeded:(NUBellBall)aBellBall
{
    BOOL aBellBallFound = [[[self nursery] objectTable] containsBellBall:aBellBall];
    
    if (!aBellBallFound)
        [self class];
    if (aBellBall.oop == 15)
        [self class];
    
    NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
    NUUInt8 aGCMarkColor = aGCMark & NUGCMarkColorBitsMask;
    
    if (aGCMarkColor == NUGCMarkWhite && aBellBall.grade <= [self grade])
    {
        NUUInt64 anObjectLocation = [[[self nursery] objectTable] objectLocationFor:aBellBall];
        [[[self nursery] objectTable] removeObjectFor:aBellBall];
        
//        NUBellBall aBellBall2 = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:28390];
//        if (NUBellBallEquals(aBellBall2, NUNotFoundBellBall))
//            [self class];
        
        [[[self nursery] reversedObjectTable] removeBellBallForObjectLocation:anObjectLocation];
        
//        NUBellBall aBellBall3 = [[[self nursery] reversedObjectTable] bellBallForObjectLocation:28390];
//        if (anObjectLocation != 28390 && NUBellBallEquals(aBellBall3, NUNotFoundBellBall))
//            [self class];
        
        NUUInt64 anObjectLocationForOOP15 = [[[self nursery] objectTable] objectLocationFor:NUMakeBellBall(15, 1)];
        if (anObjectLocationForOOP15 == NUNotFound64 || anObjectLocationForOOP15 == 0)
            [self class];
        if ([[[self nursery] objectTable] objectLocationFor:aBellBall] != NUNotFound64)
            [[NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil] raise];
        if (!NUBellBallEquals([[[self nursery] reversedObjectTable] bellBallForObjectLocation:anObjectLocation], NUNotFoundBellBall))
            [[NSException exceptionWithName:NSInternalInconsistencyException reason:nil userInfo:nil] raise];
    }
    else
    {
        [[[self nursery] objectTable] setGCMark:(aGCMark & NUGCMarkWithoutColorBitsMask) | NUGCMarkWhite for:aBellBall];
        NUUInt64 anObjectLocationForOOP15 = [[[self nursery] objectTable] objectLocationFor:NUMakeBellBall(15, 1)];
        if (anObjectLocationForOOP15 == NUNotFound64 || anObjectLocationForOOP15 == 0)
            [self class];
    }
}

- (void)pushRootOOP
{
    [[self nursery] lock];
    
	NUBell *aBell = [[self garden] bellForObject:[[self garden] nurseryRoot]];
	if (aBell) [self pushOOPAsGrayIfWhite:[aBell OOP]];
    
    [[self nursery] unlock];
}

- (void)loadGrayOOPsIfNeeded
{
    if (shouldLoadGrayOOPs)
        [self loadGrayOOPs];
}

- (void)loadGrayOOPs
{
    @try
    {
        [[self nursery] lock];
        
        NUUInt64 anOOP = [[[self nursery] objectTable] firstGrayOOPGradeLessThanOrEqualTo:[self grade]];
        
        while (anOOP != NUNotFound64)
        {
            [grayOOPs push:anOOP];
            anOOP = [[[self nursery] objectTable] grayOOPGreaterThanOOP:anOOP gradeLessThanOrEqualTo:[self grade]];
        }
        
        shouldLoadGrayOOPs = (anOOP != NUNotFound64);
    }
    @finally
    {
        [[self nursery] unlock];
    }
}

- (void)pushOOPAsGrayIfWhite:(NUUInt64)anOOP
{	
	if (currentPhase != NUSeekerSeekPhase) return;

    @try
    {
        [[self nursery] lock];
        
        NUUInt64 aGrade;
        if ([[[self nursery] objectTable] objectLocationForOOP:anOOP gradeLessThanOrEqualTo:[self grade] gradeInto:&aGrade] == NUNotFound64)
            [[NSException exceptionWithName:NUObjectLocationNotFoundException reason:NUObjectLocationNotFoundException userInfo:nil] raise];
        
        NUBellBall aBellBall = NUMakeBellBall(anOOP, aGrade);
        NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
        
        if ((aGCMark & NUGCMarkColorBitsMask) == NUGCMarkWhite)
        {
            [[[self nursery] objectTable] setGCMark:(aGCMark & NUGCMarkWithoutColorBitsMask) | NUGCMarkGray for:aBellBall];
            [grayOOPs push:anOOP];
        }
    }
    @finally
    {
        [[self nursery] unlock];
    }
}

- (void)pushOOPAsGrayIfBlack:(NUUInt64)anOOP
{
	if (currentPhase != NUSeekerSeekPhase) return;
    
    @try
    {
        [[self nursery] lock];
        
        NUBellBall aBellBall = NUMakeBellBall(anOOP, [self grade]);
        NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
        
        if ((aGCMark & NUGCMarkColorBitsMask) == NUGCMarkBlack)
        {
            [[[self nursery] objectTable] setGCMark:(aGCMark & NUGCMarkWithoutColorBitsMask) | NUGCMarkGray for:aBellBall];
            [grayOOPs push:anOOP];
        }
    }
    @finally
    {
        [[self nursery] unlock];
    }
}

- (NUUInt64)popGrayOOP
{
	NUUInt64 anOOP = NUNotFound64;
	BOOL aGrayOOPFound = NO;
	
	while (!aGrayOOPFound && [grayOOPs count])
	{
        @try
        {
            [[self nursery] lock];
            
            anOOP = [grayOOPs pop];
            NUBellBall aBellBall = [[[self nursery] objectTable] bellBallLessThanOrEqualTo:NUMakeBellBall(anOOP, [self grade])];
            if (aBellBall.oop == anOOP)
            {
                NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
                aGrayOOPFound =  (aGCMark & NUGCMarkColorBitsMask) == NUGCMarkGray;
            }
        }
		@finally
        {
            [[self nursery] unlock];
        }
	}
	
	return aGrayOOPFound ? anOOP : NUNotFound64;
}

- (void)setGrade:(NUUInt64)aGrade
{
//#ifdef DEBUG
    NSLog(@"%@ currentGrade:%@, aNewGrade:%@", self, @(grade), @(aGrade));
//#endif
    
    grade = aGrade;
}

@end
