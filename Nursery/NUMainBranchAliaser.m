//
//  NUMainBranchAliaser.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/07/06.
//
//

#import <Foundation/NSArray.h>
#import <Foundation/NSException.h>

#import "NUAliaser+Project.h"
#import "NUMainBranchAliaser.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUCoder.h"
#import "NUPages.h"
#import "NUMainBranchCodingContext.h"
#import "NUCodingContextWithPupilNote.h"
#import "NUPupilNote.h"
#import "NUObjectTable.h"
#import "NUSeeker.h"
#import "NUGradeSeeker.h"
#import "NUReversedObjectTable.h"
#import "NUSpaces.h"
#import "NUCharacter.h"
#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUBellBall.h"
#import "NURegion.h"
#import "NUU64ODictionary.h"

@implementation NUMainBranchAliaser

@end

@implementation NUMainBranchAliaser (Accessing)

- (NUUInt64)rootOOP
{
    return [[self nursery] rootOOP];
}

- (NUMainBranchNursery *)nursery
{
    return (NUMainBranchNursery *)[[self garden] nursery];
}

- (NUPages *)pages
{
	return [[self nursery] pages];
}

- (NUObjectTable *)objectTable
{
	return [[self nursery] objectTable];
}

- (NUReversedObjectTable *)reversedObjectTable
{
    return [[self nursery] reversedObjectTable];
}

- (NUUInt64)gradeForSave
{
    return gradeForSave;
}

- (void)setGradeForSave:(NUUInt64)aGrade
{
    gradeForSave = aGrade;
}

@end

@implementation NUMainBranchAliaser (Bell)

- (NUBell *)allocateBellForObject:(id)anObject
{
	NUBell *aBell = [[self garden] allocateBellForBellBall:[[self objectTable] allocateBellBallWithGrade:[self gradeForSave]] isLoaded:YES];
    [[self garden] setObject:anObject forBell:aBell];
	return aBell;
}

@end

@implementation NUMainBranchAliaser (Contexts)

- (void)pushContextWithObjectLocation:(NUUInt64)anObjectLocation
{
    [self pushContext:[NUMainBranchCodingContext
                       contextWithObjectLocation:anObjectLocation pages:[self pages]]];
}

- (NUUInt64)currentObjectLocation
{
	return [[self currentContext] objectLocation];
}

@end

@implementation NUMainBranchAliaser (Encoding)

- (void)encodeObjects
{
    [super encodeObjects];

    [self writeEncodedObjectsToPages];
}

- (void)writeEncodedObjectsToPages
{
    NUU64ODictionary *aReducedEncodedPupilsDictionary = [self reducedEncodedPupilsDictionary:[self encodedPupils]];
    NSArray *aReducedEncodedPupils = [self reducedEncodedPupilsFor:[self encodedPupils] with:aReducedEncodedPupilsDictionary];
    NUUInt64 anEncodedObjectsSize = [self sizeOfEncodedObjects:aReducedEncodedPupils with:aReducedEncodedPupilsDictionary];
    
    NUUInt64 aSpaceForEncodedObjects = [[[self nursery] spaces] allocateSpace:anEncodedObjectsSize];
    __block NUUInt64 anObjectLocation = aSpaceForEncodedObjects;
    
    [aReducedEncodedPupils enumerateObjectsUsingBlock:^(NUPupilNote * _Nonnull aPupilNote, NSUInteger idx, BOOL * _Nonnull stop) {
        [[self objectTable] setObjectLocation:anObjectLocation for:[aPupilNote bellBall]];
        [[self reversedObjectTable] setBellBall:[aPupilNote bellBall] forObjectLocation:anObjectLocation];
        [[self pages] writeData:[aPupilNote data] at:anObjectLocation];
        anObjectLocation += [aPupilNote dataSize];
    }];
    
    [[self encodedPupils] removeAllObjects];
}

- (void)prepareCodingContextForEncode:(id)anObject
{
    NUBell *aBell = [[self garden] bellForObject:anObject];

    if (!aBell) aBell = [self allocateBellForObject:anObject];
    else if ([aBell grade] != [self gradeForSave]) [aBell setGrade:[self gradeForSave]];

    NUPupilNote *aPupilNote = [NUPupilNote pupilNoteWithOOP:aBell.OOP grade:aBell.grade size:[self computeSizeOfObject:anObject]];
    [[self encodedPupils] addObject:aPupilNote];
    NUCodingContext *aContext = [NUCodingContextWithPupilNote contextWithPupilNote:aPupilNote];
    [aContext setBell:aBell];
    [aContext setObject:anObject];

    [self pushContext:aContext];
}

- (void)objectDidEncode:(NUBell *)aBell
{
    [[[self nursery] seeker] objectDidEncode:[aBell OOP]];
}

@end

@implementation NUMainBranchAliaser (Decoding)

- (id)decodeObjectForBell:(NUBell *)aBell
{
    @try {
        [[self nursery] lockForRead];
        
        return [super decodeObjectForBell:aBell];
    }
    @finally {
        [[self nursery] unlockForRead];
    }
}

- (void)prepareCodingContextForDecode:(NUBell *)aBell
{
    NUUInt64 aGrade;
    NUUInt64 anObjectLocation = [self objectLocationForBell:aBell gradeInto:&aGrade];
    
    [aBell setGrade:aGrade];
    [aBell setGradeAtCallFor:[self grade]];
    
    [self pushContextWithObjectLocation:anObjectLocation];
}

@end

@implementation NUMainBranchAliaser (ObjectSpace)

- (NUUInt64)ensureObjectSpaceFor:(NUBell *)aBell
{
    NUUInt64 anObjectLocation = [[[self nursery] objectTable] objectLocationFor:[aBell ball]];
    
    if (anObjectLocation == NUNotFound64 || anObjectLocation == 0)
        anObjectLocation = [self allocateObjectSpaceFor:aBell];
    else
    {
        NURegion aPreviousRegion = NUMakeRegion(anObjectLocation, [self sizeOfObjectForBellBall:[aBell ball]]);
        NUUInt64 aCurrentObjectSize = [self computeSizeOfObject:[aBell object]];
        
        if (aPreviousRegion.length != aCurrentObjectSize)
            anObjectLocation = [self reallocateObjectSpaceFor:aBell oldSpace:aPreviousRegion withNewSize:aCurrentObjectSize];
    }
    
	return anObjectLocation;
}

- (NUUInt64)allocateObjectSpaceFor:(NUBell *)aBell
{
    NUUInt64 aSizeOfObject = [self computeSizeOfObject:[aBell object]];
	NUUInt64 aLocation = [[[self nursery] spaces] allocateSpace:aSizeOfObject];
    
    if ([aBell grade] == NUNilGrade) [aBell setGrade:[self gradeForSave]];
    
	[[[self nursery] objectTable] setObjectLocation:aLocation for:[aBell ball]];
    [[[self nursery] reversedObjectTable] setBellBall:[aBell ball] forObjectLocation:aLocation];
    
	return aLocation;
}

- (NUUInt64)reallocateObjectSpaceFor:(NUBell *)aBell oldSpace:(NURegion)anOldRegion withNewSize:(NUUInt64)aNewSize
{
    [[[self nursery] spaces] releaseSpace:anOldRegion];
    [[[self nursery] reversedObjectTable] removeBellBallForObjectLocation:anOldRegion.location];
    NUUInt64 anObjectLocation = [self allocateObjectSpaceFor:aBell];
    [[[self nursery] objectTable] setObjectLocation:anObjectLocation for:[aBell ball]];
    [[[self nursery] reversedObjectTable] setBellBall:[aBell ball] forObjectLocation:anObjectLocation];
    
    return anObjectLocation;
}

- (NUUInt64)sizeOfObject:(id)anObject
{
	return [self sizeOfObjectForBellBall:[[[self garden] bellForObject:anObject] ball]];
}

- (NUUInt64)sizeOfObjectForBellBall:(NUBellBall)aBellBall
{
	NUUInt64 aLocation = [[[self nursery] objectTable] objectLocationFor:aBellBall];
    if (aLocation == NUNotFound64) [[NSException exceptionWithName:NUObjectLocationNotFoundException reason:NUObjectLocationNotFoundException userInfo:nil] raise];
	NUCharacter *aCharacter = [[self garden] objectForOOP:[[self pages] readUInt64At:aLocation]];
	NUUInt64 aSize = [aCharacter basicSize];
	
	if (aLocation == NUNotFound64 || aLocation == 0) return 0;
	
	if ([aCharacter isVariable])
	{
		aSize += [[self pages] readUInt64At:sizeof(NUUInt64) of:aLocation];
	}
	
	return aSize;
}

- (NUUInt64)objectLocationForBell:(NUBell *)aBell gradeInto:(NUUInt64 *)aGrade
{
    return [self objectLocationForOOP:[aBell OOP] gradeLessThanOrEqualTo:[self grade] gradeInto:aGrade];
}

- (NUUInt64)objectLocationForOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade gradeInto:(NUUInt64 *)aFoundGrade
{
    NUUInt64 anObjectLocation = [[self objectTable] objectLocationForOOP:anOOP gradeLessThanOrEqualTo:aGrade gradeInto:aFoundGrade];
	
	if (anObjectLocation == NUNotFound64)
		[[NSException exceptionWithName:NUObjectLocationNotFoundException reason:NUObjectLocationNotFoundException userInfo:nil] raise];
    
    return anObjectLocation;
}

@end

@implementation NUMainBranchAliaser (QueryingObjectLocation)

- (NUUInt64)locationForObject:(id)anObject
{
	NUBell *anOOP = [[self garden] bellForObject:anObject];
	if (anOOP) return [self locationForOOP:anOOP];
	return NUNotFound64;
}

- (NUUInt64)locationForOOP:(NUBell *)aBell
{
	return [[self objectTable] objectLocationFor:[aBell ball]];
}

@end

