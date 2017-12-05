//
//  NUBranchAliaser.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/07/06.
//
//

#import "NUAliaser.h"

@class NUBranchSandbox, NUBranchNursery, NUPupilAlbum;
@protocol NUMainBranchNurseryAssociation;

extern NSString *NUPupilNoteNotFoundException;

@interface NUBranchAliaser : NUAliaser

@property (retain)NSArray *reducedEncodedPupils;
@property (retain)NUU64ODictionary *reducedEncodedPupilsDictionary;

- (NUBranchSandbox *)branchSandbox;
- (NUBranchNursery *)branchNursery;
- (NUPupilAlbum *)pupilAlbum;
- (NSString *)branchNurseryName;
- (id <NUMainBranchNurseryAssociation>)mainBranchAssociation;
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
