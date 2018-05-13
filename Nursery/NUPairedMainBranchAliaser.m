//
//  NUPairedMainBranchAliaser.m
//  Nursery
//
//  Created by Akifumi Takata on 2014/03/15.
//
//

#import <Foundation/NSArray.h>
#import <Foundation/NSByteOrder.h>
#import <Foundation/NSData.h>
#import <Foundation/NSException.h>

#import "NUAliaser+Project.h"
#import "NUPairedMainBranchAliaser.h"
#import "NUGarden+Project.h"
#import "NUPages.h"
#import "NUObjectTable.h"
#import "NUReversedObjectTable.h"
#import "NUPairedMainBranchGarden.h"
#import "NUU64ODictionary.h"
#import "NUSpaces.h"
#import "NUCodingContextWithPupilNote.h"
#import "NUPupilNote.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUBellBall.h"

@implementation NUPairedMainBranchAliaser

- (id)initWithGarden:(NUGarden *)aGarden
{
    if (self = [super initWithGarden:aGarden])
    {
        _pupilsDictionary = [NUU64ODictionary new];
    }
    
    return self;
}

- (NUPairedMainBranchGarden *)pairedMainBranchGarden
{
    return (NUPairedMainBranchGarden *)[self garden];
}

- (void)setPupils:(NSArray *)aPupils
{
    [_pupils autorelease];
    _pupils = [aPupils retain];
    
    [self setPupilsDictionary:[NUU64ODictionary dictionary]];
    
    [[self pupils] enumerateObjectsUsingBlock:^(NUPupilNote *aPupil, NSUInteger idx, BOOL *stop) {
        [[self pupilsDictionary] setObject:aPupil forKey:[aPupil OOP]];
    }];
    
    [self setFixedOOPToProbationaryPupils:[NUU64ODictionary dictionary]];
}

- (void)dealloc
{
    [_pupilsDictionary release];
    _pupilsDictionary = nil;
    
    [super dealloc];
}

@end

@implementation NUPairedMainBranchAliaser (Decoding)

- (void)prepareCodingContextForDecode:(NUBell *)aBell
{
    NUPupilNote *aPupilNote = [[self pupilsDictionary] objectForKey:[aBell OOP]];
    
    if (!aPupilNote && ![[self pairedMainBranchGarden] OOPIsProbationary:[aBell OOP]])
            aPupilNote = [[self fixedOOPToProbationaryPupils] objectForKey:[aBell OOP]];
    
    if (aPupilNote)
    {
        [aBell setGrade:[self gradeForSave]];
        [aBell setGradeAtCallFor:[self gradeForSave]];
        [self pushContext:[NUCodingContextWithPupilNote contextWithPupilNote:aPupilNote]];
    }
    else
        [super prepareCodingContextForDecode:aBell];
}

@end

@implementation NUPairedMainBranchAliaser (Pupil)

- (NSData *)callForPupilWithOOP:(NUUInt64)anOOP containsFellowPupils:(BOOL)aContainsFellowPupils
{
    NSMutableData *aPupilsData = [NSMutableData data];
    
    @try {
        [[self nursery] lockForRead];
        
        NUUInt64 aGrade;
        NUUInt64 anObjectLocation = [self objectLocationForOOP:anOOP gradeLessThanOrEqualTo:[self grade] gradeInto:&aGrade];
        
//#ifdef DEBUG
//        NSLog(@"callForPupilWithOOP:containsFellowPupils:");
//        NSLog(@"anOOP: %llu aContainsFellowPupils: %@", anOOP, aContainsFellowPupils ? @"YES" : @"NO");
//        NSLog(@"aGrade: %llu anObjectLocation: %llu", aGrade, anObjectLocation);
//#endif
        
        if (aContainsFellowPupils)
            [self addPupilsDataFromLocation:anObjectLocation toData:aPupilsData];
        else
            [self addPupilDataAtLocation:anObjectLocation toData:aPupilsData];
        
        return aPupilsData;
    }
    @finally {
        [[self nursery] unlockForRead];
    }
}

- (void)addPupilsDataFromLocation:(NUUInt64)anObjectLocation toData:(NSMutableData *)aData
{
    NUUInt64 aPageStartingLocation = [[self pages] pageStatingLocationFor:anObjectLocation];
    NUUInt64 aNextPageStartingLocation = aPageStartingLocation + [[self pages] pageSize] * 4;
    NUBellBall aBellBall;
    
//#ifdef DEBUG
//    NSLog(@"addPupilsDataFromLocation:toData:");
//    NSLog(@"anObjectLocation: %llu", anObjectLocation);
//    NSLog(@"aPageStartingLocation: %llu aNextPageStartingLocation: %llu", aPageStartingLocation, aNextPageStartingLocation);
//#endif

    for (NUUInt64 aLocation = aPageStartingLocation; aLocation < aNextPageStartingLocation; aLocation += [self sizeOfObjectForBellBall:aBellBall])
    {
        aBellBall = [[self reversedObjectTable] bellBallForObjectLocationGreaterThanOrEqualTo:aLocation];
                
        if (NUBellBallEquals(aBellBall, NUNotFoundBellBall))
            break;
        
        aLocation = [[self objectTable] objectLocationFor:aBellBall];

        NUBellBall anElderBellBall = [[self objectTable] bellBallLessThanOrEqualTo:NUMakeBellBall(aBellBall.oop, [self grade])];
        
        if (NUBellBallEquals(aBellBall, anElderBellBall))
            [self addPupilDataWithBellBall:aBellBall toData:aData];
#ifdef DEBUG
        else
        {
            NSLog(@"aBellBall:{%llu, %llu}, anElderBellBall:{%llu, %llu}", aBellBall.oop, aBellBall.grade, anElderBellBall.oop, anElderBellBall.grade);
        }
#endif
    }
}

- (void)addPupilDataAtLocation:(NUUInt64)anObjectLocation toData:(NSMutableData *)aData
{
    NUBellBall aBellBall = [[self reversedObjectTable] bellBallForObjectLocation:anObjectLocation];
    
    if (NUBellBallEquals(aBellBall, NUNotFoundBellBall))
        [[NSException exceptionWithName:NUBellBallNotFoundException reason:NUBellBallNotFoundException userInfo:nil] raise];
    
    [self addPupilDataWithBellBall:aBellBall toData:aData];
}

- (void)addPupilDataWithBellBall:(NUBellBall)aBellBall toData:(NSMutableData *)aData
{
    NUUInt64 anObjectLocation = [[self objectTable] objectLocationFor:aBellBall];
    NUUInt64 aCharacterOOP;
    NUCharacter *aCharacter;
    NUUInt64 anObjectSize;
    NUUInt64 aUInt64Value;
    NUUInt64 anOffset;
    
    if (anObjectLocation == NUNotFound64)
        [[NSException exceptionWithName:NUObjectLocationNotFoundException reason:NUObjectLocationNotFoundException userInfo:nil] raise];
    
    aCharacterOOP = [[self pages] readUInt64At:anObjectLocation];
    aCharacter = [[self garden] objectForOOP:aCharacterOOP];
    anObjectSize = [self sizeOfObjectForBellBall:aBellBall];
    
    aUInt64Value = NSSwapHostLongLongToBig(aBellBall.oop);
    [aData appendBytes:&aUInt64Value length:sizeof(NUUInt64)];
    aUInt64Value = NSSwapHostLongLongToBig(aBellBall.grade);
    [aData appendBytes:&aUInt64Value length:sizeof(NUUInt64)];
    aUInt64Value = NSSwapHostLongLongToBig(anObjectSize);
    [aData appendBytes:&aUInt64Value length:sizeof(NUUInt64)];
    
    anOffset = [aData length];
    [aData increaseLengthBy:anObjectSize];
    [[self pages] read:(NUUInt8 *)[aData mutableBytes] + anOffset length:anObjectSize at:anObjectLocation];
    
//#ifdef DEBUG
//    NSLog(@"addPupilDataWithBellBall:toData:");
//    NSLog(@"aBellBall: {%llu, %llu}", aBellBall.oop, aBellBall.grade);
//#endif
}

- (NSData *)dataFromPupilNotes:(NSArray *)aPupilNotes
{
    NSMutableData *aData = [NSMutableData data];
    
    [aPupilNotes enumerateObjectsUsingBlock:^(NUPupilNote *  _Nonnull aPupilNote, NSUInteger idx, BOOL * _Nonnull stop) {
        NUUInt64 aUInt64Value = NSSwapHostLongLongToBig([aPupilNote OOP]);
        [aData appendBytes:&aUInt64Value length:sizeof(NUUInt64)];
        aUInt64Value = NSSwapHostLongLongToBig([aPupilNote grade]);
        [aData appendBytes:&aUInt64Value length:sizeof(NUUInt64)];
        aUInt64Value = NSSwapHostLongLongToBig([aPupilNote size]);
        [aData appendBytes:&aUInt64Value length:sizeof(NUUInt64)];
        [aData appendData:[aPupilNote data]];
    }];
    
    return aData;
}

- (NSArray *)pupilNotesFromData:(NSData *)aPupilData
{
    NSMutableArray *aPupils = [NSMutableArray array];
    NUUInt8 *aPupilDataBtyes = (NUUInt8 *)[aPupilData bytes];
    NUPupilNote *aPupilNote;
    NUUInt64 i = 0;
    
    while(i < [aPupilData length])
    {
        NUUInt64 anOOP = NSSwapBigLongLongToHost(*((NUUInt64 *)&(aPupilDataBtyes[i])));
        i += sizeof(NUUInt64);
        NUUInt64 aSize = NSSwapBigLongLongToHost(*((NUUInt64 *)&(aPupilDataBtyes[i])));
        i += sizeof(NUUInt64);
        
        aPupilNote = [NUPupilNote pupilNoteWithOOP:anOOP grade:[self gradeForSave] size:aSize bytes:(NUUInt8 *)&(aPupilDataBtyes[i])];
        
        [aPupils addObject:aPupilNote];
        i += [aPupilNote size];
    }
    
    return aPupils;
}

- (void)fixProbationaryOOPsInPupils
{
    [[self pupilsDictionary] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 anOOP, NUPupilNote *aPupilNote, BOOL *stop) {
        
        if ([[self pairedMainBranchGarden] OOPIsProbationary:[aPupilNote OOP]])
        {
            NUBellBall aFixedBellBall = [self fixedBellBallForPupilWithOOP:[aPupilNote OOP]];

            [aPupilNote setBellBall:aFixedBellBall];
            [[self fixedOOPToProbationaryPupils] setObject:aPupilNote forKey:aFixedBellBall.oop];
        }
        
        [self fixProbationaryOOPsInPupil:aPupilNote];
    }];
}

- (NUBellBall)fixedBellBallForPupilWithOOP:(NUUInt64)anOOP
{
    if ([[self pairedMainBranchGarden] OOPIsProbationary:anOOP])
        return [[self objectTable] allocateBellBallWithGrade:[self gradeForSave]];
    else
        return NUMakeBellBall(anOOP, [self gradeForSave]);
}

- (void)fixProbationaryOOPAtOffset:(NUUInt64)anIvarOffset inPupil:(NUPupilNote *)aPupilNote character:(NUCharacter *)aCharacter
{
    NUUInt64 aReferencedOOP = [aPupilNote readUInt64At:anIvarOffset];
    
//#ifdef DEBUG
//    NSLog(@"fixProbationaryOOPAtOffset:%llu inPupil:%@ character:%@", anIvarOffset, aPupilNote, aCharacter);
//    NSLog(@"aReferencedOOP:%llu", aReferencedOOP);
//#endif
    
    if ([[self pairedMainBranchGarden] OOPIsProbationary:aReferencedOOP])
    {
        NUPupilNote *aReferencedPupilNote = [[self pupilsDictionary] objectForKey:aReferencedOOP];
        NUBellBall aFixedBellBall = NUNotFoundBellBall;
        
        if (!aReferencedPupilNote)
            @throw [NSException exceptionWithName:NSGenericException reason:NSGenericException userInfo:nil];
        
        if ([[self pairedMainBranchGarden] OOPIsProbationary:aReferencedPupilNote.OOP])
        {
            aFixedBellBall = [self fixedBellBallForPupilWithOOP:[aReferencedPupilNote OOP]];
            [aReferencedPupilNote setBellBall:aFixedBellBall];
            
            [[self fixedOOPToProbationaryPupils] setObject:aReferencedPupilNote forKey:aFixedBellBall.oop];
        }
        else
            aFixedBellBall = [aReferencedPupilNote bellBall];
        
        [aPupilNote writeUInt64:aFixedBellBall.oop at:anIvarOffset];
    }
}

- (void)writeEncodedObjectsToPages
{
    NUUInt64 anEncodedObjectsSize = [self sizeOfEncodedObjects:[self pupils]];
    
    NUUInt64 aSpaceForEncodedObjects = [[[self nursery] spaces] allocateSpace:anEncodedObjectsSize];
    __block NUUInt64 anObjectLocation = aSpaceForEncodedObjects;
    
    [[self pupils] enumerateObjectsUsingBlock:^(NUPupilNote * _Nonnull aPupilNote, NSUInteger idx, BOOL * _Nonnull stop) {
        [[self objectTable] setObjectLocation:anObjectLocation for:[aPupilNote bellBall]];
        [[self reversedObjectTable] setBellBall:[aPupilNote bellBall] forObjectLocation:anObjectLocation];
        [[self pages] writeData:[aPupilNote data] at:anObjectLocation];
        anObjectLocation += [aPupilNote size];
    }];
}

- (NUUInt64)allocateObjectSpaceForPupil:(NUPupilNote *)aPupilNote
{
    return [[[self nursery] spaces] allocateSpace:[aPupilNote size]];
}

- (NSData *)dataWithProbationaryOOPAndFixedOOP
{
    NSMutableData *aProbationaryOOPAndFixedOOPData = [NSMutableData data];
    
    [[self pupilsDictionary] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 anOOP, NUPupilNote *aPupilNote, BOOL *stop) {
        if ([[self pairedMainBranchGarden] OOPIsProbationary:anOOP])
        {
            NUUInt64 aProbationaryOOP = NSSwapHostLongLongToBig(anOOP);
            NUUInt64 aFixedOOP = NSSwapHostLongLongToBig([aPupilNote OOP]);
            [aProbationaryOOPAndFixedOOPData appendBytes:(const void *)&aProbationaryOOP length:sizeof(NUUInt64)];
            [aProbationaryOOPAndFixedOOPData appendBytes:(const void *)&aFixedOOP length:sizeof(NUUInt64)];
        }
    }];
    
    return aProbationaryOOPAndFixedOOPData;
}

- (NUUInt64)fixedRootOOPForOOP:(NUUInt64)anOOP
{
    if ([[self pairedMainBranchGarden] OOPIsProbationary:anOOP])
        return [[[self pupilsDictionary] objectForKey:anOOP] OOP];
    else
        return anOOP;
}

- (NSString *)descriptionForPupils
{
    NSMutableString *aDescription = [[[[self pupilsDictionary] description] mutableCopy] autorelease];
    
    [aDescription appendString:@"{\n"];
    
    [[self pupilsDictionary] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, id anObject, BOOL *stop) {
        [aDescription appendFormat:@"%llu:%@\n", aKey, anObject];
    }];
    
    [aDescription appendString:@"\n}"];
    
    return aDescription;
}

@end
