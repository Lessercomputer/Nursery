//
//  NUMainBranchNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUNursery.h"

@class NSFileHandle, NSMutableDictionary,NSRecursiveLock;
@class NUObjectTable, NUReversedObjectTable, NUSpaces, NUPages, NUSeeker, NUParader, NUMainBranchGarden, NUPairedMainBranchGarden;

@interface NUMainBranchNursery : NUNursery
{
    NSString *filePath;
	NUObjectTable *objectTable;
    NUReversedObjectTable *reversedObjectTable;
	NUSpaces *spaces;
    NUUInt64 grade;
    NSMutableDictionary *retainedGrades;
	NUSeeker *seeker;
    NUParader *parader;
    NUUInt64 nextGardenID;
    NSRecursiveLock *lock;
    BOOL backups;
}
@end

@interface NUMainBranchNursery (InitializingAndRelease)

+ (id)nurseryWithContentsOfFile:(NSString *)aFilePath;

- (id)initWithContentsOfFile:(NSString *)aFilePath;

@end

@interface NUMainBranchNursery (Accessing)

- (NSString *)filePath;

- (NSFileHandle *)fileHandle;

- (NUPages *)pages;
- (NUSpaces *)spaces;
- (NUObjectTable *)objectTable;
- (NUReversedObjectTable *)reversedObjectTable;

- (NUUInt64)rootOOP;
- (NUUInt64)grade;
- (NSMutableDictionary *)retainedGrades;

- (NUSeeker *)seeker;
- (NUParader *)parader;

- (BOOL)backups;
- (void)setBackups:(BOOL)aBackupFlag;

@end

@interface NUMainBranchNursery (Garden)

- (NUUInt64)newGardenID;
- (void)releaseGardenID:(NUInt64)anID;

@end

@interface NUMainBranchNursery (Testing)

- (BOOL)isOpen;

@end

@interface NUMainBranchNursery (Private)

- (void)setFilePath:(NSString *)aFilePath;
- (void)setSpaces:(NUSpaces *)aSpaces;
- (void)setObjectTable:(NUObjectTable *)anObjectTable;
- (void)setReversedObjectTable:(NUReversedObjectTable *)aReversedObjectTable;
- (void)setSeeker:(NUSeeker *)aSeeker;
- (void)setParader:(NUParader *)aParader;
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
