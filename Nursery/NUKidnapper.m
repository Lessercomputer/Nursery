//
//  NUKidnapper.m
//  Nursery
//
//  Created by P,T,A on 11/08/17.
//  Copyright 2011 Nursery-Framework. All rights reserved.
//

#import "NUKidnapper.h"
#import "NUIndexArray.h"
#import "NUMainBranchNursery.h"
#import "NUPages.h"
#import "NUObjectTable.h"
#import "NUReversedObjectTable.h"
#import "NUPeephole.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUPlayLot.h"
#import "NUMainBranchPeephole.h"

const NUUInt8 NUKidnapperNonePhase		= 0;
const NUUInt8 NUKidnapperStalkPhase		= 1;
const NUUInt8 NUKidnapperKidnapPhase	= 2;

const NUUInt64 NUKidnapperPhaseOffset	= 101;
const NUUInt64 NUKidnapperCurrentGradeOffset = 109;

const NUUInt32 NUKidnapperDefaultStalkCount = 1000;

const NUUInt32 NUKidnapperDefaultGrayOOPCapacity = 50000;

@implementation NUKidnapper

+ (id)kidnapperWithPlayLot:(NUPlayLot *)aPlayLot
{
	return [[[self alloc] initWithPlayLot:aPlayLot] autorelease];
}

- (id)initWithPlayLot:(NUPlayLot *)aPlayLot
{
	if (self = [super initWithPlayLot:aPlayLot])
	{
        currentPhase = NUKidnapperNonePhase;
        shouldLoadGrayOOPs = NO;
        grayOOPs = [[NUIndexArray alloc] initWithCapacity:NUKidnapperDefaultGrayOOPCapacity comparator:[NUIndexArray comparator]];
        peephole = [[NUMainBranchPeephole alloc] initWithNursery:[aPlayLot nursery] playLot:aPlayLot];
    }
    
	return self;
}

- (void)dealloc
{
	[grayOOPs release];
	[peephole release];
	
	[super dealloc];
}

- (void)objectDidEncode:(NUUInt64)anOOP
{
	[self pushOOPAsGrayIfBlack:anOOP];
}

- (void)save
{
	[[[self nursery] pages] writeUInt8:currentPhase at:NUKidnapperPhaseOffset];
    [[[self nursery] pages] writeUInt64:[self grade] at:NUKidnapperCurrentGradeOffset];
}

- (void)load
{
	currentPhase = [[[self nursery] pages] readUInt8At:NUKidnapperPhaseOffset];
	if (currentPhase == NUKidnapperStalkPhase) shouldLoadGrayOOPs = YES;
    [self setGrade:[[[self nursery] pages] readUInt64At:NUKidnapperCurrentGradeOffset]];
}

- (NUMainBranchNursery *)nursery
{
    return (NUMainBranchNursery *)[[self playLot] nursery];
}

- (NUUInt64)grade
{
    return grade;
}

@end

@implementation NUKidnapper (Private)

- (void)process
{
    [self stalkObjects];
    [self kidnapObjects];
}

- (void)stalkObjects
{
	if (currentPhase == NUKidnapperStalkPhase)
	{
		if (shouldLoadGrayOOPs)
            [self loadGrayOOPs];
        [[self playLot] moveUpTo:[self grade]];
	}
	else if (currentPhase == NUKidnapperNonePhase)
	{
        [self setGrade:[[self nursery] gradeForKidnapper]];
        if ([self grade] == NUNilGrade)
        {
            [self setShouldStop:YES];
            return;
        }
		currentPhase = NUKidnapperStalkPhase;
        [[self playLot] moveUpTo:[self grade]];
        [self pushRootOOP];
	}
	
	[self stalkObjectsUntilStop];
}

- (void)stalkObjectsUntilStop
{
	if (![grayOOPs count]) [self setShouldStop:YES];

	while (![self shouldStop])
	{
		NUUInt64 anOOP = NUNotFound64;
		int i = 0;
		
		for (; i < NUKidnapperDefaultStalkCount && (anOOP = [self popGrayOOP]) != NUNotFound64; i++)
		{            
            [[self nursery] lockForChange];
            
            NUUInt64 aGrade;
            if ([[[self nursery] objectTable] objectLocationForOOP:anOOP gradeLessThanOrEqualTo:[self grade] gradeInto:&aGrade] == NUNotFound64)
                [[NSException exceptionWithName:NUObjectLocationNotFoundException reason:NUObjectLocationNotFoundException userInfo:nil] raise];
            
			[peephole peekAt:NUMakeBellBall(anOOP, aGrade)];
			
			while ([peephole hasNextFixedOOP])
			{
				NUUInt64 aFixedOOP = [peephole nextFixedOOP];
				if (aFixedOOP != NUNilOOP) [self pushOOPAsGrayIfWhite:aFixedOOP];
			}
			
			while ([peephole hasNextIndexedOOP])
			{
				NUUInt64 anIndexedOOP = [peephole nextIndexedOOP];
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
        currentPhase = NUKidnapperKidnapPhase;
}

- (void)kidnapObjects
{
	if (currentPhase != NUKidnapperKidnapPhase) return;
	
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
            NSLog(@"<%@:%p> #kidnapObjects (removeObjectFor: %@, removeOOPForObjectLocation: %llu)", [self class], self, NUStringFromBellBall(aBellBall), anObjectLocation);
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
            NSLog(@"<%@:%p> #kidnapObjects (aBellBall == NUNotFoundBellBall)", [self class], self);
#endif
	}
	
	currentPhase = NUKidnapperNonePhase;
}

- (void)pushRootOOP
{
	NUBell *anOOP = [[self playLot] bellForObject:[[self playLot] nurseryRoot]];
	if (anOOP) [self pushOOPAsGrayIfWhite:[anOOP OOP]];
}

- (void)loadGrayOOPs
{
	NUUInt64 anOOP = [[[self nursery] objectTable] firstGrayOOPGradeLessThanOrEqualTo:[self grade]];
	
	while (anOOP != NUNotFound64 && [grayOOPs count] < NUKidnapperDefaultGrayOOPCapacity / 2)
	{
		[grayOOPs addIndex:anOOP];
        anOOP = [[[self nursery] objectTable] grayOOPGreaterThanOOP:anOOP gradeLessThanOrEqualTo:[self grade]];
	}
    
    shouldLoadGrayOOPs = (anOOP != NUNotFound64);
}

- (void)pushOOPAsGrayIfWhite:(NUUInt64)anOOP
{	
	if (currentPhase != NUKidnapperStalkPhase) return;

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
	if (currentPhase != NUKidnapperStalkPhase) return;

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
