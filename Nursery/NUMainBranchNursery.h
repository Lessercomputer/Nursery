//
//  NUMainBranchNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUNursery.h"

@class NSFileHandle, NSMutableDictionary, NSRecursiveLock;
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

- (NUUInt64)grade;

- (BOOL)backups;
- (void)setBackups:(BOOL)aBackupFlag;

@end

@interface NUMainBranchNursery (Testing)

- (BOOL)isOpen;

@end
