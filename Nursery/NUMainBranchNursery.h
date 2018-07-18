//
//  NUMainBranchNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUNursery.h"

@class NSMutableDictionary, NSRecursiveLock;
@class NUObjectTable, NUReversedObjectTable, NUSpaces, NUNurserySeeker, NUNurseryParader;

@interface NUMainBranchNursery : NUNursery
{
    NSString *filePath;
	NUObjectTable *objectTable;
    NUReversedObjectTable *reversedObjectTable;
	NUSpaces *spaces;
    NUUInt64 grade;
    NSMutableDictionary *retainedGrades;
	NUNurserySeeker *seeker;
    NUNurseryParader *parader;
    NUUInt64 nextGardenID;
    NSRecursiveLock *lock;
    BOOL backups;
}
@end

@interface NUMainBranchNursery (InitializingAndRelease)

+ (instancetype)nursery;
+ (id)nurseryWithContentsOfFile:(NSString *)aFilePath;

- (id)initWithContentsOfFile:(NSString *)aFilePath;

@end

@interface NUMainBranchNursery (Accessing)

- (NSString *)filePath;
- (void)setFilePath:(NSString *)aFilePath;

- (NUUInt64)grade;

- (BOOL)backups;
- (void)setBackups:(BOOL)aBackupFlag;

@end

@interface NUMainBranchNursery (Testing)

- (BOOL)isOpen;

@end
