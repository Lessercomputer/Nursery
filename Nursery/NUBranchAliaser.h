//
//  NUBranchAliaser.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/07/06.
//
//

#import <Nursery/Nursery.h>

extern NSString *NUPupilNoteNotFoundException;

@interface NUBranchAliaser : NUAliaser

- (NUBranchSandbox *)branchSandbox;
- (NUBranchNursery *)branchNursery;
- (NUPupilAlbum *)pupilAlbum;
- (NSString *)branchNurseryName;
- (id <NUMainBranchNurseryAssociation>)mainBranchAssociation;

@end

@interface NUBranchAliaser (Decoding)

- (NUPupilNote *)callForPupilNoteWithBell:(NUBell *)aBell;
- (NUPupilNote *)callForPupilNoteWithBellBall:(NUBellBall)aBellBall;
- (NUPupilNote *)callForPupilNoteReallyWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade;
- (NSArray *)pupilNotesFromPupilNoteData:(NSData *)aPupilNoteData pupilNoteOOP:(NUUInt64)aTargetOOP pupilNoteInto:(NUPupilNote **)aTargetPupilNote;

- (NUPupilNote *)currentPupilNote;

@end

@interface NUBranchAliaser (Encoding)

- (NUPupilNote *)ensurePupilNoteFor:(NUBell *)aBell;
- (NSData *)encodedPupilData;

@end
