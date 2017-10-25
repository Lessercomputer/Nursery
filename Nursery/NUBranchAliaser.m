//
//  NUBranchAliaser.m
//  Nursery
//
//  Created by P,T,A on 2013/07/06.
//
//

#import "NUBranchAliaser.h"
#import "NUBranchNursery.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUCodingContext.h"
#import "NUBranchCodingContext.h"
#import "NUCoder.h"

NSString *NUPupilNoteNotFoundException = @"NUPupilNoteNotFoundException";

@implementation NUBranchAliaser

- (NUUInt64)rootOOP
{
    return [[self mainBranchAssociation] rootOOPForNurseryWithName:[self branchNurseryName] playLotWithID:[[self playLot] ID]];
}

- (NUBranchPlayLot *)branchPlayLot
{
    return (NUBranchPlayLot *)[self playLot];
}

- (NUBranchNursery *)branchNursery
{
    return (NUBranchNursery *)[[self playLot] nursery];
}

- (NUPupilAlbum *)pupilAlbum
{
    return [[self branchNursery] pupilAlbum];
}

- (NSString *)branchNurseryName
{
    return [[self branchNursery] name];
}

- (id <NUMainBranchNurseryAssociation>)mainBranchAssociation
{
    return [[self branchNursery] mainBranchAssociationForPlayLot:[self branchPlayLot]];
}

@end

@implementation NUBranchAliaser (Decoding)

- (void)prepareCodingContextForDecode:(NUBell *)aBell
{
    NUPupilNote *aPupilNote;
    
    [aBell setGradeAtCallFor:[self grade]];
    aPupilNote = [self callForPupilNoteWithBell:aBell];
    [aBell setGrade:[aPupilNote grade]];
    [self pushContext:[NUBranchCodingContext contextWithPupilNote:aPupilNote]];
}

- (NUPupilNote *)callForPupilNoteWithBell:(NUBell *)aBell
{
    return [self callForPupilNoteWithBellBall:[aBell ball]];
}

- (NUPupilNote *)callForPupilNoteWithBellBall:(NUBellBall)aBellBall
{
    NUPupilNote *aPupilNote;
    
    if (aBellBall.grade == NUNilGrade)
        aPupilNote = [[self pupilAlbum] pupilNoteForBellBall:NUMakeBellBall(aBellBall.oop, [self grade])];
    else
        aPupilNote = [[self pupilAlbum] pupilNoteForBellBall:aBellBall];
    
    if (!aPupilNote) aPupilNote = [self callForPupilNoteReallyWithOOP:aBellBall.oop gradeLessThanOrEqualTo:[self grade]];
    
    return aPupilNote;
}

- (NUPupilNote *)callForPupilNoteReallyWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade
{
    id <NUMainBranchNurseryAssociation> anAssociation = [self mainBranchAssociation];
    NSData *aPupilNoteData = [anAssociation callForPupilWithOOP:anOOP gradeLessThanOrEqualTo:aGrade playLotWithID:[[self playLot] ID] containsFellowPupils:YES inNurseryWithName:[self branchNurseryName]];
    NUPupilNote *aPupilNote = nil;
    NSArray *aPupilNotes = [self pupilNotesFromPupilNoteData:aPupilNoteData pupilNoteOOP:anOOP pupilNoteInto:&aPupilNote];
    [[self pupilAlbum] addPupilNotes:aPupilNotes grade:aGrade];
    
    if (!aPupilNote)
        [[NSException exceptionWithName:NUPupilNoteNotFoundException reason:NUPupilNoteNotFoundException userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(anOOP),@"OOP", @(aGrade),@"Grade", nil]] raise];
    
    return aPupilNote;
}

- (NSArray *)pupilNotesFromPupilNoteData:(NSData *)aPupilNoteData pupilNoteOOP:(NUUInt64)aTargetOOP pupilNoteInto:(NUPupilNote **)aTargetPupilNote
{
    NSMutableArray *aPupils = [NSMutableArray array];
    NUUInt8 *aBytes = (NUUInt8 *)[aPupilNoteData bytes];
    
    for (NUUInt64 i = 0; i < [aPupilNoteData length]; )
    {
        NUUInt64 aUInt64Value;
        NUUInt64 anOOP;
        NUUInt64 aGrade;
        NUUInt64 aSize;
        NUPupilNote *aPupilNote;

        aUInt64Value = *(NUUInt64 *)&aBytes[i];
        anOOP = NSSwapBigLongLongToHost(aUInt64Value);
        i += sizeof(NUUInt64);
        aUInt64Value = *(NUUInt64 *)&aBytes[i];
        aGrade = NSSwapBigLongLongToHost(aUInt64Value);
        i += sizeof(NUUInt64);
        aUInt64Value = *(NUUInt64 *)&aBytes[i];
        aSize = NSSwapBigLongLongToHost(aUInt64Value);
        i += sizeof(NUUInt64);

        aPupilNote = [NUPupilNote pupilNoteWithOOP:anOOP grade:aGrade size:aSize bytes:&aBytes[i]];
        [aPupils addObject:aPupilNote];
        i += aSize;
        
        if (anOOP == aTargetOOP) *aTargetPupilNote = aPupilNote;
    }
    
    return aPupils;
}

- (NUPupilNote *)currentPupilNote
{
    return [(NUBranchCodingContext *)[self currentContext] pupilNote];
}

@end

@implementation NUBranchAliaser (Encoding)

- (void)prepareCodingContextForEncode:(id)anObject
{
	NUBell *aBell = [[self playLot] bellForObject:anObject];
    NUPupilNote *aPupilNote;
	
	if (!aBell) aBell = [self allocateBellForObject:anObject];
    
	aPupilNote = [self ensurePupilNoteFor:aBell];
    
	NUCodingContext *aContext = [NUBranchCodingContext contextWithPupilNote:aPupilNote];
	[aContext setBell:aBell];
	[aContext setObject:anObject];
	
	[self pushContext:aContext];
}

- (NUPupilNote *)ensurePupilNoteFor:(NUBell *)aBell
{
    NUPupilNote *aPupilNote = [[[self branchPlayLot] probationaryPupils] objectForKey:aBell];
    
    if (aPupilNote)
    {
        NUUInt64 anObjectSize = [self computeSizeOfObject:[aBell object]];
        if ([aPupilNote size] != anObjectSize)
            [aPupilNote setSize:anObjectSize];
    }
    else
    {
        aPupilNote = [NUPupilNote pupilNoteWithOOP:[aBell OOP] grade:NUNilGrade size:[self computeSizeOfObject:[aBell object]]];
        [[[self branchPlayLot] probationaryPupils] setObject:aPupilNote forKey:aBell];
    }
    
    return aPupilNote;
}

- (NSData *)encodedPupilData
{
    NSMutableData *aData = [NSMutableData data];
    
    [[[self branchPlayLot] probationaryPupils] enumerateKeysAndObjectsUsingBlock:^(NUBell *aBell, NUPupilNote *aPupilNote, BOOL *aStop) {
        NUUInt64 aValue = NSSwapHostLongLongToBig([aBell OOP]);
        [aData appendBytes:&aValue length:sizeof(NUUInt64)];
        aValue = NSSwapHostLongLongToBig([aPupilNote size]);
        [aData appendBytes:&aValue length:sizeof(NUUInt64)];
        [aData appendData:[aPupilNote data]];
    }];
    
    return aData;
}

@end

@implementation NUBranchAliaser (Bell)

- (NUBell *)allocateBellForObject:(id)anObject
{
    NUBell *aBell = [[self playLot] allocateBellForBellBall:NUMakeBellBall([[self branchPlayLot] allocProbationaryOOP], NUNilGrade)];
    [[self playLot] setObject:anObject forBell:aBell];
    return aBell;
}

@end

@implementation NUBranchAliaser (Testing)

- (BOOL)isForMainBranch
{
    return NO;
}

@end

@implementation NUBranchAliaser (Pupil)

- (void)fixProbationaryOOPAtOffset:(NUUInt64)anIvarOffset inPupil:(NUPupilNote *)aPupilNote character:(NUCharacter *)aCharacter
{
    NUUInt64 aReferencedOOP = [aPupilNote readUInt64At:anIvarOffset];
    
    if ([[self branchPlayLot] OOPIsProbationary:aReferencedOOP])
    {
        NUBell *aReferencedBell = [[self playLot] bellForOOP:aReferencedOOP];
        NUPupilNote *aReferencedPupilNote = [[[self branchPlayLot] probationaryPupils] objectForKey:aReferencedBell];
        
        [aPupilNote writeUInt64:[aReferencedPupilNote OOP] at:anIvarOffset];
    }
}

@end