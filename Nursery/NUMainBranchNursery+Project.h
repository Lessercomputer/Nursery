//
//  NUMainBranchNursery+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/28.
//  Copyright © 2018年 Nursery-Framework. All rights reserved.
//

#import "NUMainBranchNursery.h"

@class NSFileHandle;
@class NUPages, NUMainBranchGarden, NUPairedMainBranchGarden;

@interface NUMainBranchNursery (ProjectAccessing)

- (NSFileHandle *)fileHandle;

- (NUPages *)pages;
- (NUSpaces *)spaces;
- (NUObjectTable *)objectTable;
- (NUReversedObjectTable *)reversedObjectTable;

- (NUUInt64)rootOOP;
- (NSMutableDictionary *)retainedGrades;

- (NUNurserySeeker *)seeker;
- (NUNurseryParader *)parader;

@end

@interface NUMainBranchNursery (Garden)

- (NUUInt64)newGardenID;
- (void)releaseGardenID:(NUInt64)anID;

@end

@interface NUMainBranchNursery (Private)

- (void)setSpaces:(NUSpaces *)aSpaces;
- (void)setObjectTable:(NUObjectTable *)anObjectTable;
- (void)setReversedObjectTable:(NUReversedObjectTable *)aReversedObjectTable;
- (void)setSeeker:(NUNurserySeeker *)aSeeker;
- (void)setParader:(NUNurseryParader *)aParader;
- (void)setGrade:(NUUInt64)aGrade;
- (void)setRetainedGrades:(NSMutableDictionary *)aGrades;

- (NUPairedMainBranchGarden *)makePairdGarden;

- (NUGarden *)gardenForSeeker;
- (NUGarden *)gardenForParader;

- (NUUInt64)gradeForSeeker;
- (NUUInt64)gradeForParader;

- (void)lockForFarmOut;
- (void)unlockForFarmOut;
- (void)lockForChange;
- (void)unlockForChange;
- (void)lockForRead;
- (void)unlockForRead;

- (BOOL)save;
- (void)backup;
- (void)close;

- (BOOL)open;
- (BOOL)saveChanges;
- (void)saveRootOOP:(NUUInt64)aRootOOP;
- (void)saveGrade;
- (void)loadGrade;
- (NUUInt64)newGrade;
- (BOOL)createFileAndOpenIfNeeded;
- (BOOL)createFileAndOpen;
- (BOOL)createFileAndInitialize;
- (BOOL)openFileHandle;
- (BOOL)verifyFile;
- (BOOL)writeFileHeader;
- (void)initializeFileHeader;
- (BOOL)verifyFileHeader;
- (BOOL)applyLogIfNeeded;
- (void)loadFileHeader;

- (void)validateObjectTableAndReversedObjectTable;

@end
