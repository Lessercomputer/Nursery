//
//  NUNurserySeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 11/08/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSException.h>

#import "NUNurserySeeker.h"
#import "NUUInt64Queue.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
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

const NUUInt8 NUSeekerNonePhase		= 0;
const NUUInt8 NUSeekerSeekPhase		= 1;
const NUUInt8 NUSeekerCollectPhase	= 2;

const NUUInt64 NUSeekerPhaseOffset	= 101;
const NUUInt64 NUSeekerCurrentGradeOffset = 109;
const NUUInt64 NUSeekerNextOOPOfBellBallToCollectOffset = 117;
const NUUInt64 NUSeekerNextGradeOfBellBallToCollectOffset = 125;

const NUUInt32 NUSeekerDefaultSeekCount = 300;

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

- (void)process
{
    [self preprocess];
    [self seekObjects];
    [self collectObjects];
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

- (void)seekObjects
{
    if (currentPhase == NUSeekerSeekPhase)
    {
        [self loadGrayOOPsIfNeeded];
        [[self garden] moveUpTo:[self grade]];
        [self seekObjectsUntilStop];
    }
    else if (currentPhase == NUSeekerCollectPhase)
    {
        [[self garden] moveUpTo:[self grade]];
    }
    else if (currentPhase == NUSeekerNonePhase)
    {
        [self setGrade:[[self nursery] gradeForSeeker]];
        
        if ([self grade] == NUNilGrade)
        {
            [self setShouldStop:YES];
            return;
        }
        
        currentPhase = NUSeekerSeekPhase;
        [[self garden] moveUpTo:[self grade]];
        [self pushRootOOP];
        [self seekObjectsUntilStop];
    }
}

- (void)seekObjectsUntilStop
{
	while (![self shouldStop] && ([grayOOPs count] || shouldLoadGrayOOPs))
	{
		NUUInt64 anOOP = NUNotFound64;
		int i = 0;
        
        [self loadGrayOOPsIfNeeded];
        
		for (; i < NUSeekerDefaultSeekCount && (anOOP = [self popGrayOOP]) != NUNotFound64; i++)
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
//#ifdef DEBUG
//            NUUInt8 aGCMarkColor = aGCMark & NUGCMarkColorBitsMask;
//
//            if (aGCMarkColor == NUGCMarkNone)
//                NSLog(@"seek %@, NUGCMarkNone", NUStringFromBellBall(aBellBall));
//            else if (aGCMarkColor == NUGCMarkWhite)
//                NSLog(@"seek %@, NUGCMarkWhite", NUStringFromBellBall(aBellBall));
//            else if (aGCMarkColor == NUGCMarkGray)
//                NSLog(@"seek %@, NUGCMarkGray", NUStringFromBellBall(aBellBall));
//            else if (aGCMarkColor == NUGCMarkBlack)
//                NSLog(@"seek %@, NUGCMarkBlack", NUStringFromBellBall(aBellBall));
//#endif
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

- (void)collectObjects
{
    if (currentPhase != NUSeekerCollectPhase) return;
    
    NUBellBall aBellBall = NUMakeBellBall(0, 0);
    
    while (![self shouldStop] && !NUBellBallEquals(aBellBall, NUNotFoundBellBall))
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
            
#ifdef DEBUG
            if (NUBellBallEquals(aBellBall, NUNotFoundBellBall))
                NSLog(@"<%@:%p> #collectObjects (aBellBall == NUNotFoundBellBall)", [self class], self);
#endif
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
        [[self nursery] seekerDidFinishSeek:self];
    }
}

- (void)collectObjectIfNeeded:(NUBellBall)aBellBall
{
    @try
    {
        [[self nursery] lock];
        
        NUBellBall aBellBall2 = NUMakeBellBall(3111, 1);
        NUBellBall aBellBall3 = NUMakeBellBall(9630, 2);

        if (aBellBall.oop == 3111)
            [self class];
        if (aBellBall.oop == 3289 && aBellBall.grade == 2)
            [self class];
        if (aBellBall.oop == 3250 && aBellBall.grade == 2)
            [self class];
        if (aBellBall.oop == 9630 && aBellBall.grade == 2)
            [self class];
        
        NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
        NUUInt8 aGCMarkColor = aGCMark & NUGCMarkColorBitsMask;
        
//#ifdef DEBUG
//    if (aGCMarkColor == NUGCMarkNone)
//        NSLog(@"#collectObjects:%@, NUGCMarkNone", NUStringFromBellBall(aBellBall));
//    else if (aGCMarkColor == NUGCMarkWhite)
//        NSLog(@"#collectObjects:%@, NUGCMarkWhite", NUStringFromBellBall(aBellBall));
//    else if (aGCMarkColor == NUGCMarkGray)
//        NSLog(@"#collectObjects:%@, NUGCMarkGray", NUStringFromBellBall(aBellBall));
//    else if (aGCMarkColor == NUGCMarkBlack)
//        NSLog(@"#collectObjects:%@, NUGCMarkBlack", NUStringFromBellBall(aBellBall));
//#endif
    
        if (aGCMarkColor == NUGCMarkWhite && aBellBall.grade <= [self grade])
        {
            NUUInt64 anObjectLocation = [[[self nursery] objectTable] objectLocationFor:aBellBall];
            [[[self nursery] objectTable] removeObjectFor:aBellBall];
            [[[self nursery] reversedObjectTable] removeBellBallForObjectLocation:anObjectLocation];
            
            if ([[[self nursery] objectTable] objectLocationFor:aBellBall] != NUNotFound64)
                [[NSException exceptionWithName:@"error" reason:@"error" userInfo:nil] raise];
            if (!NUBellBallEquals([[[self nursery] reversedObjectTable] bellBallForObjectLocation:anObjectLocation], NUNotFoundBellBall))
                [[NSException exceptionWithName:@"error" reason:@"error" userInfo:nil] raise];
        
#ifdef DEBUG
            NSLog(@"<%@:%p> #collectObjects (removeObjectFor: %@, removeOOPForObjectLocation: %llu)", [self class], self, NUStringFromBellBall(aBellBall), anObjectLocation);
#endif
        }
        else
        {
            [[[self nursery] objectTable] setGCMark:(aGCMark & NUGCMarkWithoutColorBitsMask) | NUGCMarkWhite for:aBellBall];
        }
        
        
        NUUInt64 anObjectLocationForBellBall2 = [[[self nursery] objectTable] objectLocationFor:aBellBall2];
        if (!NUBellBallEquals([[[self nursery] reversedObjectTable] bellBallForObjectLocation:anObjectLocationForBellBall2], aBellBall2))
            [self class];
        
        NUUInt64 anObjectLocationForBellBall3 = [[[self nursery] objectTable] objectLocationFor:aBellBall3];
        if (anObjectLocationForBellBall3 == NUNotFound64 || anObjectLocationForBellBall3 == 0)
            [self class];
    }
    @finally
    {
        [[self nursery] unlock];
    }
}

- (void)pushRootOOP
{
	NUBell *aBell = [[self garden] bellForObject:[[self garden] nurseryRoot]];
	if (aBell) [self pushOOPAsGrayIfWhite:[aBell OOP]];
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
        
        while (anOOP != NUNotFound64 && [grayOOPs count] < NUSeekerDefaultGrayOOPCapacity / 2)
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
