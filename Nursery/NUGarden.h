//
//  NUGarden.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSLock.h>
#import <Nursery/NUTypes.h>

typedef enum NUFarmOutStatus {
    NUFarmOutStatusSucceeded = 0,
    NUFarmOutStatusFailed = 1,
    NUFarmOutStatusNurseryGradeUnmatched = 2
} NUFarmOutStatus;

@class NSMutableDictionary, NSMutableIndexSet;
@class NUNursery, NUNurseryRoot, NUObjectWrapper, NUBell, NUAliaser, NUGradeSeeker, NUMutableDictionary, NUU64ODictionary;

extern NSString * const NUObjectLoadingException;

@interface NUGarden : NSObject
{
    NUNursery *nursery;
    NUUInt64 grade;
    NSMutableIndexSet *retainedGrades;
    NUNurseryRoot *root;
	NUMutableDictionary *characters;
    NUObjectWrapper *keyObject;
    NSMutableDictionary *objectToBellDictionary;
	NUBell *keyBell;
    NUU64ODictionary *bells;
	NUU64ODictionary *changedObjects;
	NUAliaser *aliaser;
    BOOL usesGradeSeeker;
    NUGradeSeeker *gradeSeeker;
    NSRecursiveLock *lock;
    NUUInt64 gardenID;
    BOOL isInMoveUp;
    BOOL retainNursery;
}
@end

@interface NUGarden (InitializingAndRelease)

+ (id)gardenWithNursery:(NUNursery *)aNursery;
+ (id)gardenWithNursery:(NUNursery *)aNursery usesGradeSeeker:(BOOL)aUsesGradeSeeker;
+ (id)gardenWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker;
+ (id)gardenWithNursery:(NUNursery *)aNursery usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag;
+ (id)gardenWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag;

- (id)initWithNursery:(NUNursery *)aNursery usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag;
- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker retainNursery:(BOOL)aRetainFlag;

@end

@interface NUGarden (Accessing)

- (NUNursery *)nursery;
- (NUUInt64)grade;

- (id)root;
- (void)setRoot:(id)aRoot;

@end

@interface NUGarden (SaveAndLoad)

- (void)moveUp;
- (void)moveUpTo:(NUUInt64)aGrade;

- (void)moveUpObject:(id)anObject;

- (NUFarmOutStatus)farmOut;

@end

@interface NUGarden (ObjectState)

- (void)markChangedObject:(id)anObject;
- (void)unmarkChangedObject:(id)anObject;

@end
