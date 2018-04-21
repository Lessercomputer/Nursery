//
//  NUGarden.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

typedef enum NUFarmOutStatus {
    NUFarmOutStatusSucceeded = 0,
    NUFarmOutStatusFailed = 1,
    NUFarmOutStatusNurseryGradeUnmatched = 2
} NUFarmOutStatus;

@class NUNursery, NUNurseryRoot, NUObjectWrapper, NUBell, NUCharacter, NUAliaser, NUGradeSeeker, NUMutableDictionary, NUU64ODictionary;

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

- (NUUInt64)ID;

- (NUUInt64)grade;
- (NSMutableIndexSet *)retainedGrades;

- (NUNurseryRoot *)nurseryRoot;
- (void)setNurseryRoot:(NUNurseryRoot *)aRoot;

- (id)root;
- (void)setRoot:(id)aRoot;

- (NUMutableDictionary *)characters;
- (void)setCharacters:(NUMutableDictionary *)aCharacters;

- (NSMutableDictionary *)objectToBellDictionary;
- (void)setObjectToBellDictionary:(NSMutableDictionary *)anObjectToBellDictionary;

- (NUU64ODictionary *)bells;
- (void)setBells:(NUU64ODictionary *)aBells;

- (NUU64ODictionary *)changedObjects;
- (void)setChangedObjects:(NUU64ODictionary *)aChangedObjects;

- (NUObjectWrapper *)keyObject;

- (NUBell *)keyBell;
- (void)setKeyBell:(NUBell *)aBell;

- (NUAliaser *)aliaser;
- (void)setAliaser:(NUAliaser *)anAliaser;

- (NUGradeSeeker *)gradeSeeker;
- (void)setGradeSeeker:(NUGradeSeeker *)aGradeSeeker;

@end

@interface NUGarden (Bell)

- (id)objectForBell:(NUBell *)aBell;
- (id)objectForOOP:(NUUInt64)anOOP;
- (id)loadObjectForBell:(NUBell *)aBell;

- (NUBell *)bellForObject:(id)anObject;
- (NUBell *)bellForOOP:(NUUInt64)anOOP;

- (NUBell *)allocateBellForBellBall:(NUBellBall)aBellBall;
- (NUBell *)allocateBellForBellBall:(NUBellBall)aBellBall isLoaded:(BOOL)anIsLoaded;

- (void)setObject:(id)anObject forBell:(NUBell *)aBell;
- (void)setObject:(id)anObject forOOP:(NUUInt64)anOOP;

- (void)removeBell:(NUBell *)aBell;

- (BOOL)OOPIsProbationary:(NUUInt64)anOOP;

@end

@interface NUGarden (SaveAndLoad)

- (void)moveUp;
- (void)moveUpTo:(NUUInt64)aGrade;

- (void)moveUpNurseryRoot;

- (void)moveUpObject:(id)anObject;

- (NUFarmOutStatus)farmOut;

@end

@interface NUGarden (Characters)

- (NSDictionary *)systemCharacterOOPToClassDictionary;

- (void)establishSystemCharacters;
- (void)establishCharacters;
- (void)moveUpSystemCharacters;

- (NUCharacter *)characterForClass:(Class)aClass;
- (void)setCharacter:(NUCharacter *)aCharacter forClass:(Class)aClass;

- (NUCharacter *)characterForName:(NSString *)aName;
- (void)setCharacter:(NUCharacter *)aCharacter forName:(NSString *)aName;

- (void)establishCharacterFor:(Class)aClass;

@end

@interface NUGarden (ObjectState)

- (void)markChangedObject:(id)anObject;
- (void)unmarkChangedObject:(id)anObject;

@end

@interface NUGarden (Testing)

- (BOOL)contains:(id)anObject;
- (BOOL)needsEncode:(id)anObject;

- (BOOL)isForMainBranch;
- (BOOL)gradeIsEqualToNurseryGrade;

- (BOOL)isInMoveUp;

@end

@interface NUGarden (Private) <NSLocking>

- (void)setNursery:(NUNursery *)aNursery;

- (void)saveNurseryRootOOP;
- (NUNurseryRoot *)loadNurseryRoot;
- (void)markSystemCharactersChanged;

- (NUUInt64)retainLatestGradeOfNursery;

- (void)setGrade:(NUUInt64)aGrade;
- (void)setID:(NUUInt64)anID;
- (void)setIsInMoveUp:(BOOL)aFlag;

- (BOOL)class:(Class)aClass isKindOfClass:(Class)anAnsestorClass;

- (void)setKeyObject:(NUObjectWrapper *)anObjectWrapper;

- (void)setRetainedGrades:(NSMutableIndexSet *)aGrades;

- (void)invalidateBellsWithNotReferencedObject;
- (void)invalidateObjectIfNotReferencedForBell:(NUBell *)aBell;
- (void)invalidateNotReferencedBells;
- (NSUInteger)basicRetainCountOfBellInGarden:(NUBell *)aBell;
- (void)invalidateBell:(NUBell *)aBell;

- (void)collectGradeLessThan:(NUUInt64)aGrade;
- (void)collectBellsWithGradeLessThan:(NUUInt64)aGrade;

- (void)close;

@end
