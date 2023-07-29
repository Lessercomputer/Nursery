//
//  NUMainBranchNursery+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/28.
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

- (void)seekerDidFinishCollection:(NUNurserySeeker *)sender;
- (void)paraderDidFinishParade:(NUNurseryParader *)sender;

- (void)lock;
- (void)unlock;

- (BOOL)save;
- (void)backup;
- (void)close;

- (BOOL)open;
- (BOOL)isSavingForbidden;
- (void)setIsSavingForbidden:(BOOL)aFlag;
- (BOOL)saveChanges;
- (void)saveRootOOP:(NUUInt64)aRootOOP;
- (void)saveGrade;
- (void)loadGrade;
- (NUUInt64)newGrade;
- (BOOL)createFileAndOpenIfNeeded;
- (BOOL)createFileAndOpen;
- (BOOL)openFileHandle;
- (BOOL)verifyFile;
- (BOOL)writeFileHeader;
- (void)initializeFileHeader;
- (BOOL)verifyFileHeader;
- (BOOL)applyLogIfNeeded;
- (void)loadFileHeader;

- (void)validateMappingOfObjectTableToReversedObjectTable;

@end
