//
//  NUPupilAlbum.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Nursery/NUTypes.h>

@class NUBell, NUPupilNote, NUU64ODictionary, NUBellBallODictionary;

@interface NUPupilAlbum : NSObject
{
    NUU64ODictionary *gradeToOOPDictionary;
    NUBellBallODictionary *bellBallToPupilDictionary;
}

- (NUPupilNote *)pupilNoteForBellBall:(NUBellBall)aBellBall;
- (NUPupilNote *)pupilNoteForBell:(NUBell *)aBell;

- (void)addPupilNotes:(NSArray *)aPupilNotes grade:(NUUInt64)aGrade;
- (void)addPupilNote:(NUPupilNote *)aPupilNote grade:(NUUInt64)aGrade;

@end
