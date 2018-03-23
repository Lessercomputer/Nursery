//
//  NUSeeker.m
//  Nursery
//
//  Created by Akifumi Takata on 11/08/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUSeeker.h"
#import "NUIndexArray.h"
#import "NUMainBranchNursery.h"
#import "NUPages.h"
#import "NUObjectTable.h"
#import "NUReversedObjectTable.h"
#import "NUAperture.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUSandbox.h"
#import "NUMainBranchAperture.h"
#import "NUAliaser.h"

const NUUInt8 NUSeekerNonePhase		= 0;
const NUUInt8 NUSeekerSeekPhase		= 1;
const NUUInt8 NUSeekerCollectPhase	= 2;

const NUUInt64 NUSeekerPhaseOffset	= 101;
const NUUInt64 NUSeekerCurrentGradeOffset = 109;

const NUUInt32 NUSeekerDefaultSeekCount = 300;

const NUUInt32 NUSeekerDefaultGrayOOPCapacity = 50000;

@implementation NUSeeker

+ (id)seekerWithSandbox:(NUSandbox *)aSandbox
{
	return [[[self alloc] initWithSandbox:aSandbox] autorelease];
}

- (id)initWithSandbox:(NUSandbox *)aSandbox
{
	if (self = [super initWithSandbox:aSandbox])
	{
        sandbox = [aSandbox retain];
        currentPhase = NUSeekerNonePhase;
        shouldLoadGrayOOPs = NO;
        grayOOPs = [[NUIndexArray alloc] initWithCapacity:NUSeekerDefaultGrayOOPCapacity comparator:[NUIndexArray comparator]];
        aperture = [[NUMainBranchAperture alloc] initWithNursery:[aSandbox nursery] sandbox:aSandbox];
    }
    
	return self;
}

- (void)dealloc
{
    NSLog(@"dealloc:%@", self);
	[grayOOPs release];
	[aperture release];
    [sandbox release];
	
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
}

- (void)load
{
	currentPhase = [[[self nursery] pages] readUInt8At:NUSeekerPhaseOffset];
	if (currentPhase == NUSeekerSeekPhase) shouldLoadGrayOOPs = YES;
    [self setGrade:[[[self nursery] pages] readUInt64At:NUSeekerCurrentGradeOffset]];
}

- (NUMainBranchNursery *)nursery
{
    return (NUMainBranchNursery *)[[self sandbox] nursery];
}

- (NUUInt64)grade
{
    return grade;
}

@end

@implementation NUSeeker (Private)

- (void)process
{
    [self seekObjects];
    [self collectObjects];
}

- (void)seekObjects
{
	if (currentPhase == NUSeekerSeekPhase)
	{
		if (shouldLoadGrayOOPs)
            [self loadGrayOOPs];
        [[self sandbox] moveUpTo:[self grade]];
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
        [[self sandbox] moveUpTo:[self grade]];
        [self pushRootOOP];
	}
	
	[self seekObjectsUntilStop];
}

- (void)seekObjectsUntilStop
{
	if (![grayOOPs count]) [self setShouldStop:YES];

	while (![self shouldStop])
	{
		NUUInt64 anOOP = NUNotFound64;
		int i = 0;
		
		for (; i < NUSeekerDefaultSeekCount && (anOOP = [self popGrayOOP]) != NUNotFound64; i++)
		{            
            [[self nursery] lockForChange];
            
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
            
            [[self nursery] unlockForChange];
		}
        
        if (anOOP == NUNotFound64) [self setShouldStop:YES];
	}
	
	if (!shouldLoadGrayOOPs && ![grayOOPs count])
        currentPhase = NUSeekerCollectPhase;
}

- (void)collectObjects
{
	if (currentPhase != NUSeekerCollectPhase) return;
	
	NUBellBall aBellBall = [[[self nursery] objectTable] firstBellBall];
    
	while (![self shouldStop] && !NUBellBallEquals(aBellBall, NUNotFoundBellBall))
	{
		NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
        
		if ((aGCMark & NUGCMarkColorBitsMask) == NUGCMarkWhite && aBellBall.grade <= [self grade])
        {            
            [[self nursery] lockForChange];
            
            NUUInt64 anObjectLocation = [[[self nursery] objectTable] objectLocationFor:aBellBall];
			[[[self nursery] objectTable] removeObjectFor:aBellBall];
            [[[self nursery] reversedObjectTable] removeBellBallForObjectLocation:anObjectLocation];
            
            if ([[[self nursery] objectTable] objectLocationFor:aBellBall] != NUNotFound64)
                [[NSException exceptionWithName:@"error" reason:@"error" userInfo:nil] raise];
            if (!NUBellBallEquals([[[self nursery] reversedObjectTable] bellBallForObjectLocation:anObjectLocation], NUNotFoundBellBall))
                [[NSException exceptionWithName:@"error" reason:@"error" userInfo:nil] raise];
            
#ifdef DEBUG
            NSLog(@"<%@:%p> #collectObjects (removeObjectFor: %@, removeOOPForObjectLocation: %llu)", [self class], self, NUStringFromBellBall(aBellBall), anObjectLocation);
            if (aBellBall.oop == 12499)
                NSLog(@"aBellBall.oop == 12499");
#endif
            
            [[self nursery] unlockForChange];
        }
		else
			[[[self nursery] objectTable] setGCMark:(aGCMark & NUGCMarkWithoutColorBitsMask) | NUGCMarkWhite for:aBellBall];
        
		aBellBall = [[[self nursery] objectTable] bellBallGreaterThanBellBall:aBellBall];
        
#ifdef DEBUG
        if (NUBellBallEquals(aBellBall, NUNotFoundBellBall))
            NSLog(@"<%@:%p> #collectObjects (aBellBall == NUNotFoundBellBall)", [self class], self);
#endif
	}
	
	currentPhase = NUSeekerNonePhase;
}

- (void)pushRootOOP
{
	NUBell *anOOP = [[self sandbox] bellForObject:[[self sandbox] nurseryRoot]];
	if (anOOP) [self pushOOPAsGrayIfWhite:[anOOP OOP]];
}

- (void)loadGrayOOPs
{
	NUUInt64 anOOP = [[[self nursery] objectTable] firstGrayOOPGradeLessThanOrEqualTo:[self grade]];
	
	while (anOOP != NUNotFound64 && [grayOOPs count] < NUSeekerDefaultGrayOOPCapacity / 2)
	{
		[grayOOPs addIndex:anOOP];
        anOOP = [[[self nursery] objectTable] grayOOPGreaterThanOOP:anOOP gradeLessThanOrEqualTo:[self grade]];
	}
    
    shouldLoadGrayOOPs = (anOOP != NUNotFound64);
}

- (void)pushOOPAsGrayIfWhite:(NUUInt64)anOOP
{	
	if (currentPhase != NUSeekerSeekPhase) return;

    NUUInt64 aGrade;
    if ([[[self nursery] objectTable] objectLocationForOOP:anOOP gradeLessThanOrEqualTo:[self grade] gradeInto:&aGrade] == NUNotFound64)
        [[NSException exceptionWithName:NUObjectLocationNotFoundException reason:NUObjectLocationNotFoundException userInfo:nil] raise];
    
    NUBellBall aBellBall = NUMakeBellBall(anOOP, aGrade);
	NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
	if ((aGCMark & NUGCMarkColorBitsMask) == NUGCMarkWhite)
    {
		[[[self nursery] objectTable] setGCMark:(aGCMark & NUGCMarkWithoutColorBitsMask) | NUGCMarkGray for:aBellBall];
        if (![grayOOPs isFull])
            [grayOOPs addIndex:anOOP];
        else
            shouldLoadGrayOOPs = YES;
    }
}

- (void)pushOOPAsGrayIfBlack:(NUUInt64)anOOP
{
	if (currentPhase != NUSeekerSeekPhase) return;

    NUBellBall aBellBall = NUMakeBellBall(anOOP, [self grade]);
	NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
	if ((aGCMark & NUGCMarkColorBitsMask) == NUGCMarkBlack)
    {
		[[[self nursery] objectTable] setGCMark:(aGCMark & NUGCMarkWithoutColorBitsMask) | NUGCMarkGray for:aBellBall];
        if (![grayOOPs isFull])
            [grayOOPs addIndex:anOOP];
        else
            shouldLoadGrayOOPs = YES;
    }
}

- (NUUInt64)popGrayOOP
{
	NUUInt64 anOOP = NUNotFound64;
	BOOL aGrayOOPFound = NO;
	
	while (!aGrayOOPFound && [grayOOPs count])
	{
		anOOP = [grayOOPs indexAt:[grayOOPs count] - 1];
        NUBellBall aBellBall = [[[self nursery] objectTable] bellBallLessThanOrEqualTo:NUMakeBellBall(anOOP, [self grade])];
        if (aBellBall.oop == anOOP)
        {
            NUUInt8 aGCMark = [[[self nursery] objectTable] gcMarkFor:aBellBall];
            aGrayOOPFound =  (aGCMark & NUGCMarkColorBitsMask) == NUGCMarkGray;
        }
        [grayOOPs removeAt:[grayOOPs count] - 1];
	}
	
	return aGrayOOPFound ? anOOP : NUNotFound64;
}

- (void)setGrade:(NUUInt64)aGrade
{
    grade = aGrade;
}

@end
