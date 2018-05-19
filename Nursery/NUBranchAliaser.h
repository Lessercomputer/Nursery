//
//  NUBranchAliaser.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/07/06.
//
//

#import "NUAliaser.h"

@class NUBranchGarden, NUBranchNursery, NUPupilNote, NUPupilNoteCache;
@protocol NUMainBranchNurseryAssociation;

extern NSString *NUPupilNoteNotFoundException;

@interface NUBranchAliaser : NUAliaser

@property (nonatomic, retain) NSArray *reducedEncodedPupils;
@property (nonatomic, retain) NUU64ODictionary *reducedEncodedPupilsDictionary;

@property (nonatomic) NUUInt64 cacheHitCount;

- (NUBranchGarden *)branchGarden;
- (NUBranchNursery *)branchNursery;
- (NUPupilNoteCache *)pupilNoteCache;

- (void)removeAllEncodedPupils;

@end

@interface NUBranchAliaser (Decoding)

- (NUPupilNote *)callForPupilNoteWithBell:(NUBell *)aBell;
- (NUPupilNote *)callForPupilNoteWithBellBall:(NUBellBall)aBellBall;
- (NUPupilNote *)callForPupilNoteReallyWithOOP:(NUUInt64)anOOP gradeLessThanOrEqualTo:(NUUInt64)aGrade;
+ (NSArray *)pupilNotesFromPupilNoteData:(NSData *)aPupilNoteData pupilNoteOOP:(NUUInt64)aTargetOOP pupilNoteInto:(NUPupilNote **)aTargetPupilNote;
- (NSArray *)pupilNotesFromPupilNoteData:(NSData *)aPupilNoteData pupilNoteOOP:(NUUInt64)aTargetOOP pupilNoteInto:(NUPupilNote **)aTargetPupilNote;

- (NUPupilNote *)currentPupilNote;

@end

@interface NUBranchAliaser (Encoding)

+ (NSData *)encodedPupilNotesDataFromPupilNotes:(NSArray *)aPupilNotes;
- (NSData *)encodedPupilNotesData;

@end
