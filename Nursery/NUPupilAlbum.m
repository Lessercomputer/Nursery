//
//  NUPupilAlbum.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUPupilAlbum.h"
#import "NUPupilNote.h"
#import "NUBell.h"
#import "NUBellBall.h"
#import "NUU64ODictionary.h"
#import "NUBellBallODictionary.h"

@implementation NUPupilAlbum

- (id)init
{
    if (self = [super init])
    {
        gradeToOOPDictionary = [NUU64ODictionary new];
        bellBallToPupilDictionary = [NUBellBallODictionary new];
    }
    
    return self;
}

- (void)dealloc
{
    [gradeToOOPDictionary release];
    [bellBallToPupilDictionary release];
    
    [super dealloc];
}

- (NUPupilNote *)pupilNoteForBellBall:(NUBellBall)aBellBall
{
    return [bellBallToPupilDictionary objectForKey:aBellBall];
}

- (NUPupilNote *)pupilNoteForBell:(NUBell *)aBell
{
    return [self pupilNoteForBellBall:[aBell ball]];
}

- (void)addPupilNotes:(NSArray *)aPupilNotes grade:(NUUInt64)aGrade
{
    [aPupilNotes enumerateObjectsUsingBlock:^(NUPupilNote *aPupilNote, NSUInteger idx, BOOL *stop) {
        [self addPupilNote:aPupilNote grade:aGrade];
    }];
}

- (void)addPupilNote:(NUPupilNote *)aPupilNote grade:(NUUInt64)aGrade
{
    NUBellBall aBellBall = NUMakeBellBall([aPupilNote OOP], [aPupilNote grade]);
    NUPupilNote *anExistingPupilNote = [self pupilNoteForBellBall:aBellBall];
    
    if (anExistingPupilNote)
        return;
    
//    [bellBallToPupilDictionary setObject:aPupilNote forKey:NUMakeBellBall(aBellBall.oop, aBellBall.grade)];
    [bellBallToPupilDictionary setObject:aPupilNote forKey:NUMakeBellBall(aBellBall.oop, aGrade)];

    NUU64ODictionary *anOOPToPupilNoteDictionary = [gradeToOOPDictionary objectForKey:aGrade];
    if (!anOOPToPupilNoteDictionary)
    {
        anOOPToPupilNoteDictionary = [NUU64ODictionary dictionary];
        [gradeToOOPDictionary setObject:anOOPToPupilNoteDictionary forKey:aGrade];
    }
    
    [anOOPToPupilNoteDictionary setObject:aPupilNote forKey:[aPupilNote OOP]];
}

@end
