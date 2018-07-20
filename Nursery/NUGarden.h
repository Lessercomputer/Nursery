//
//  NUGarden.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Foundation/NSLock.h>

#import <Nursery/NUTypes.h>
#import <Nursery/NUCharacter.h>

typedef enum NUFarmOutStatus {
    NUFarmOutStatusSucceeded = 0,
    NUFarmOutStatusFailed = 1,
    NUFarmOutStatusNurseryGradeUnmatched = 2
} NUFarmOutStatus;

@class NSMutableDictionary, NSMutableIndexSet;
@class NUNursery, NUNurseryRoot, NUObjectWrapper, NUBell, NUAliaser, NUGardenSeeker, NUMutableDictionary, NUU64ODictionary;

extern NSString * const NUObjectLoadingException;

@interface NUGarden : NSObject
{
    NUNursery *nursery;
    NUUInt64 grade;
    NSMutableIndexSet *retainedGrades;
    NUNurseryRoot *root;
	NUMutableDictionary *characters;
    NSMutableDictionary *nameWithVersionKeyedCharacters;
    NUObjectWrapper *keyObject;
    NSMutableDictionary *objectToBellDictionary;
	NUBell *keyBell;
    NUU64ODictionary *bells;
	NUU64ODictionary *changedObjects;
	NUAliaser *aliaser;
    BOOL usesGardenSeeker;
    NUGardenSeeker *gardenSeeker;
    NSRecursiveLock *lock;
    NUUInt64 gardenID;
    BOOL isInMoveUp;
    BOOL retainNursery;
    NSMutableArray *characterTargetClassResolvers;
}
@end

@interface NUGarden (InitializingAndRelease)

+ (id)gardenWithNursery:(NUNursery *)aNursery;
+ (id)gardenWithNursery:(NUNursery *)aNursery usesGardenSeeker:(BOOL)aUsesGardenSeeker;
+ (id)gardenWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGardenSeeker:(BOOL)aUsesGardenSeeker;
+ (id)gardenWithNursery:(NUNursery *)aNursery usesGardenSeeker:(BOOL)aUsesGardenSeeker retainNursery:(BOOL)aRetainFlag;
+ (id)gardenWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGardenSeeker:(BOOL)aUsesGardenSeeker retainNursery:(BOOL)aRetainFlag;

- (id)initWithNursery:(NUNursery *)aNursery usesGardenSeeker:(BOOL)aUsesGardenSeeker retainNursery:(BOOL)aRetainFlag;
- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGardenSeeker:(BOOL)aUsesGardenSeeker retainNursery:(BOOL)aRetainFlag;

@end

@interface NUGarden (Accessing)

- (NUNursery *)nursery;
- (NUUInt64)grade;

- (id)root;
- (void)setRoot:(id)aRoot;

@end

@interface NUGarden (ResolvingCharacterTargetClass)

- (void)addCharacterTargetClassResolver:(id <NUCharacterTargetClassResolving>)aTargetClassResolver;
- (void)removeCharacterTargetClassResolver:(id <NUCharacterTargetClassResolving>)aTargetClassResolver;

@end

@interface NUGarden (SaveAndLoad)

- (void)moveUp;
- (void)moveUpWithPreventingReleaseOfCurrentGrade;
- (void)moveUpTo:(NUUInt64)aGrade;
- (void)moveUpTo:(NUUInt64)aGrade preventReleaseOfCurrentGrade:(BOOL)aPreventFlag;

- (void)moveUpObject:(id)anObject;

- (NUFarmOutStatus)farmOut;

@end

@interface NUGarden (ObjectState)

- (void)markChangedObject:(id)anObject;
- (void)unmarkChangedObject:(id)anObject;

@end
