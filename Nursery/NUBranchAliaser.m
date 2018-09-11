//
//  NUBranchAliaser.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/07/06.
//
//

#import <Foundation/NSByteOrder.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSException.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSData.h>

#import "NUAliaser+Project.h"
#import "NUBranchAliaser.h"
#import "NUBranchNursery.h"
#import "NUBranchNursery+Project.h"
#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUBellBall.h"
#import "NUCodingContext.h"
#import "NUCodingContextWithPupilNote.h"
#import "NUCoder.h"
#import "NUPupilNote.h"
#import "NUPupilNoteCache.h"
#import "NUGarden+Project.h"
#import "NUBranchGarden.h"
#import "NUU64ODictionary.h"
#import "NUNurseryNetClient.h"

NSString *NUPupilNoteNotFoundException = @"NUPupilNoteNotFoundException";

@implementation NUBranchAliaser

- (void)dealloc
{
    [_reducedEncodedPupils release];
    _reducedEncodedPupils = nil;
    
    [_reducedEncodedPupilsDictionary release];
    _reducedEncodedPupilsDictionary = nil;
    
    [super dealloc];
}

- (NUUInt64)rootOOP
{
    return [[[self branchGarden] netClient] rootOOPForGardenWithID:[[self garden] ID]];
}

- (NUBranchGarden *)branchGarden
{
    return (NUBranchGarden *)[self garden];
}

- (NUBranchNursery *)branchNursery
{
    return (NUBranchNursery *)[[self garden] nursery];
}

- (NUPupilNoteCache *)pupilNoteCache
{
    return [[self branchNursery] pupilNoteCache];
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
    NUPupilNote *aPupilNote = nil;;
    
    aPupilNote = [[self pupilNoteCache] pupilNoteForOOP:aBellBall.oop grade:[self grade]];
    
    if (!aPupilNote)
        aPupilNote = [self callForPupilNoteReallyWithOOP:aBellBall.oop gradeLessThanOrEqualTo:[self grade]];
    
    return aPupilNote;
}

- (NUPupilNote *)callForPupilNoteReallyWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade
{
    NUNurseryNetClient *aNetClient = [[self branchGarden] netClient];
    NSData *aPupilNoteData = [aNetClient callForPupilWithOOP:anOOP gradeLessThanOrEqualTo:aGrade gardenWithID:[[self garden] ID] containsFellowPupils:YES];
    NUPupilNote *aPupilNote = nil;
    NSArray *aPupilNotes = [self pupilNotesFromPupilNoteData:aPupilNoteData pupilNoteOOP:anOOP pupilNoteInto:&aPupilNote];
    [[self pupilNoteCache] addPupilNotes:aPupilNotes grade:aGrade];
    
    if (!aPupilNote)
        [[NSException exceptionWithName:NUPupilNoteNotFoundException reason:NUPupilNoteNotFoundException userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@(anOOP),@"OOP", @(aGrade),@"Grade", nil]] raise];
    
    return aPupilNote;
}

+ (NSArray *)pupilNotesFromPupilNoteData:(NSData *)aPupilNoteData pupilNoteOOP:(NUUInt64)aTargetOOP pupilNoteInto:(NUPupilNote **)aTargetPupilNote
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
        
        if (anOOP == aTargetOOP && aTargetPupilNote) *aTargetPupilNote = aPupilNote;
    }
    
    return aPupils;
}

- (NSArray *)pupilNotesFromPupilNoteData:(NSData *)aPupilNoteData pupilNoteOOP:(NUUInt64)aTargetOOP pupilNoteInto:(NUPupilNote **)aTargetPupilNote
{
    return [[self class] pupilNotesFromPupilNoteData:aPupilNoteData pupilNoteOOP:aTargetOOP pupilNoteInto:aTargetPupilNote];
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

- (void)storeObjectsToEncode
{
    [self setStoredRoots:[[[self roots] mutableCopy] autorelease]];
    [self setStoredChangedObjects:[[[[self garden] changedObjects] copy] autorelease]];
}

- (void)restoreObjectsToEncode
{
    [self setRoots:[self storedRoots]];
    [[self garden] setChangedObjects:[self storedChangedObjects]];
    
    [self removeStoredObjectsToEncode];
}

- (void)removeStoredObjectsToEncode
{
    [self setStoredRoots:nil];
    [self setStoredChangedObjects:nil];
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

+ (NSData *)encodedPupilNotesDataFromPupilNotes:(NSArray *)aPupilNotes
{
    NSMutableData *aData = [NSMutableData data];
    
    [aPupilNotes enumerateObjectsUsingBlock:^(NUPupilNote * _Nonnull aPupilNote, NSUInteger idx, BOOL * _Nonnull stop) {
        NUUInt64 aValue = NSSwapHostLongLongToBig([aPupilNote OOP]);
        [aData appendBytes:&aValue length:sizeof(NUUInt64)];
        aValue = NSSwapHostLongLongToBig([aPupilNote dataSize]);
        [aData appendBytes:&aValue length:sizeof(NUUInt64)];
        [aData appendData:[aPupilNote data]];
    }];
    
    return aData;
}

- (NSData *)encodedPupilNotesData
{
    return [[self class] encodedPupilNotesDataFromPupilNotes:[self reducedEncodedPupils]];
}

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
