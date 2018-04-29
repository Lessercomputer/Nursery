//
//  NUBranchAliaser.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/07/06.
//
//

#import "NUAliaser.h"

@class NUBranchGarden, NUBranchNursery, NUPupilNote, NUPupilAlbum;
@protocol NUMainBranchNurseryAssociation;

extern NSString *NUPupilNoteNotFoundException;

@interface NUBranchAliaser : NUAliaser

@property (nonatomic, retain) NSArray *reducedEncodedPupils;
@property (nonatomic, retain) NUU64ODictionary *reducedEncodedPupilsDictionary;

- (NUBranchGarden *)branchGarden;
- (NUBranchNursery *)branchNursery;
- (NUPupilAlbum *)pupilAlbum;

- (void)removeAllEncodedPupils;

@end

@interface NUBranchAliaser (Decoding)

- (NUPupilNote *)callForPupilNoteWithBell:(NUBell *)aBell;
- (NUPupilNote *)callForPupilNoteWithBellBall:(NUBellBall)aBellBall;
- (NUPupilNote *)callForPupilNoteReallyWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade;
- (NSArray *)pupilNotesFromPupilNoteData:(NSData *)aPupilNoteData pupilNoteOOP:(NUUInt64)aTargetOOP pupilNoteInto:(NUPupilNote **)aTargetPupilNote;

- (NUPupilNote *)currentPupilNote;

@end

@interface NUBranchAliaser (Encoding)

- (NSData *)encodedPupilData;

@end
