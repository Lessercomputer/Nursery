//
//  NUMainBranchNursery.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Nursery/NUNursery.h>

@class NSMutableDictionary, NSRecursiveLock;
@class NUObjectTable, NUReversedObjectTable, NUSpaces, NUNurserySeeker, NUNurseryParader;

@protocol NUNurseryDelegate <NSObject>

- (void)nurseryWillWriteLog:(NUNursery *)aNursery;
- (void)nurseryDidWriteLog:(NUNursery *)aNursery;

@end

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
    BOOL isSavingForbidden;
    id <NUNurseryDelegate> delegate;
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

@interface NUMainBranchNursery (Delegate)

- (id <NUNurseryDelegate>)delegate;
- (void)setDelegate:(id <NUNurseryDelegate>)aDelegate;

- (void)willWriteLog;
- (void)didWriteLog;

@end
