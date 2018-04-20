//
//  NUBranchAliaser.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/07/06.
//
//

#import "NUBranchAliaser.h"
#import "NUBranchNursery.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUCodingContext.h"
#import "NUCodingContextWithPupilNote.h"
#import "NUCoder.h"
#import "NUPupilNote.h"
#import "NUPupilAlbum.h"
#import "NUBranchGarden.h"
#import "NUU64ODictionary.h"
#import "NUNurseryNetClient.h"

NSString *NUPupilNoteNotFoundException = @"NUPupilNoteNotFoundException";

@implementation NUBranchAliaser

- (NUUInt64)rootOOP
{
    return [[[self branchNursery] netClient] rootOOPForGardenWithID:[[self garden] ID]];
}

- (NUBranchGarden *)branchGarden
{
    return (NUBranchGarden *)[self garden];
}

- (NUBranchNursery *)branchNursery
{
    return (NUBranchNursery *)[[self garden] nursery];
}

- (NUPupilAlbum *)pupilAlbum
{
    return [[self branchNursery] pupilAlbum];
}

- (void)removeAllEncodedPupils
{
    [[self encodedPupils] removeAllObjects];
    [self setReducedEncodedPupils:nil];
    [self setReducedEncodedPupilsDictionary:nil];
}

@end

@implementation NUBranchAliaser (Decoding)

- (void)prepareCodingContextForDecode:(NUBell *)aBell
{
    NUPupilNote *aPupilNote;
    
    [aBell setGradeAtCallFor:[self grade]];
    aPupilNote = [self callForPupilNoteWithBell:aBell];
    [aBell setGrade:[aPupilNote grade]];
    [self pushContext:[NUCodingContextWithPupilNote contextWithPupilNote:aPupilNote]];
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
    NUNurseryNetClient *aNetClient = [[self branchNursery] netClient];
    NSData *aPupilNoteData = [aNetClient callForPupilWithOOP:anOOP gradeLessThanOrEqualTo:aGrade gardenWithID:[[self garden] ID] containsFellowPupils:YES];
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
    return [(NUCodingContextWithPupilNote *)[self currentContext] pupilNote];
}

@end

@implementation NUBranchAliaser (Encoding)

- (void)encodeObjects
{
    [super encodeObjects];
    
    [self setReducedEncodedPupilsDictionary:[self reducedEncodedPupilsDictionary:[self encodedPupils]]];
    [self setReducedEncodedPupils:[self reducedEncodedPupilsFor:[self encodedPupils] with:[self reducedEncodedPupilsDictionary]]];
}

- (void)prepareCodingContextForEncode:(id)anObject
{
	NUBell *aBell = [[self garden] bellForObject:anObject];
	
	if (!aBell) aBell = [self allocateBellForObject:anObject];
    
    NUPupilNote *aPupilNote = [NUPupilNote pupilNoteWithOOP:[aBell OOP] grade:NUNilGrade size:[self computeSizeOfObject:[aBell object]]];
    [[self encodedPupils] addObject:aPupilNote];
	NUCodingContext *aContext = [NUCodingContextWithPupilNote contextWithPupilNote:aPupilNote];
	[aContext setBell:aBell];
	[aContext setObject:anObject];
	
	[self pushContext:aContext];
}

- (NSData *)encodedPupilData
{
    NSMutableData *aData = [NSMutableData data];

    [[self reducedEncodedPupils] enumerateObjectsUsingBlock:^(NUPupilNote * _Nonnull aPupilNote, NSUInteger idx, BOOL * _Nonnull stop) {
        NUUInt64 aValue = NSSwapHostLongLongToBig([aPupilNote OOP]);
        [aData appendBytes:&aValue length:sizeof(NUUInt64)];
//        if ([aPupilNote size] > 10000)
//            NSLog(@"[aPupilNote size] > 10000:%llu", [aPupilNote size]);
        aValue = NSSwapHostLongLongToBig([aPupilNote size]);
        [aData appendBytes:&aValue length:sizeof(NUUInt64)];
        [aData appendData:[aPupilNote data]];
    }];
    
//    NSArray *aPupils = [self pupilsFromData:aData];
//    NSLog(@"%@", aPupils);

//    return [NSData dataWithBytes:[aData bytes] length:[aData length]];
//    NSLog(@"In NUBranchAliaser encodedPupilData, aData length:%lu", [aData length]);
    return aData;
}

//- (NSArray *)pupilsFromData:(NSData *)aPupilData
//{
//    NSMutableArray *aPupils = [NSMutableArray array];
//    NUUInt8 *aPupilDataBtyes = (NUUInt8 *)[aPupilData bytes];
//    NUPupilNote *aPupilNote;
//    NUUInt64 i = 0;
//    
//    while( i < [aPupilData length])
//    {
//        NUUInt64 anOOP = NSSwapBigLongLongToHost(*((NUUInt64 *)&(aPupilDataBtyes[i])));
//        i += sizeof(NUUInt64);
//        NUUInt64 aSize = NSSwapBigLongLongToHost(*((NUUInt64 *)&(aPupilDataBtyes[i])));
//        i += sizeof(NUUInt64);
//        
//        if (aSize > 1000)
//            NSLog(@"in pupilsFromData:, aSize > 1000:%llu", aSize);
//        
//        aPupilNote = [NUPupilNote pupilNoteWithOOP:anOOP grade:[self gradeForSave] size:aSize bytes:(NUUInt8 *)&(aPupilDataBtyes[i])];
//        if (aSize != [aPupilNote size])
//            NSLog(@"aSize != [aPupilNote size], %llu:%llu", aSize, [aPupilNote size]);
//        [aPupils addObject:aPupilNote];
//        i += [aPupilNote size];
//        //NSLog(@"i += [aPupilNote size]:%llu",i);
//    }
//    
//    return aPupils;
//}

@end

@implementation NUBranchAliaser (Bell)

- (NUBell *)allocateBellForObject:(id)anObject
{
    NUBell *aBell = [[self garden] allocateBellForBellBall:NUMakeBellBall([[self branchGarden] allocProbationaryOOP], NUNilGrade)];
    [[self garden] setObject:anObject forBell:aBell];
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
    
    if ([[self branchGarden] OOPIsProbationary:aReferencedOOP])
    {
        NUPupilNote *aReferencedPupilNote = [[self reducedEncodedPupilsDictionary] objectForKey:aReferencedOOP];
        
        [aPupilNote writeUInt64:[aReferencedPupilNote OOP] at:anIvarOffset];
    }
}

@end
