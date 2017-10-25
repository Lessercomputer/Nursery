//
//  NUPlayLot.h
//  Nursery
//
//  Created by P,T,A on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

typedef enum NUFarmOutStatus {
    NUFarmOutStatusSucceeded = 0,
    NUFarmOutStatusFailed = 1,
    NUFarmOutStatusNurseryGradeUnmatched = 2
} NUFarmOutStatus;

@class NUNursery, NUNurseryRoot, NUObjectWrapper, NUBell, NUCharacter, NUAliaser, NUGradeKidnapper, NUMutableDictionary, NUU64ODictionary;

extern NSString * const NUObjectLoadingException;

@interface NUPlayLot : NSObject
{
    NUNursery *nursery;
    NUUInt64 grade;
    NSMutableIndexSet *retainedGrades;
    NUNurseryRoot *root;
	NUMutableDictionary *characters;
	NUObjectWrapper *keyObject;
	NSMutableDictionary *objectToOOPDictionary;
	NUBell *keyBell;
	NSMutableSet *bellSet;
	NUU64ODictionary *changedObjects;
	NUAliaser *aliaser;
    BOOL usesGradeKidnapper;
    NUGradeKidnapper *gradeKidnapper;
    NSRecursiveLock *lock;
    NUUInt64 playLotID;
    BOOL isInMoveUp;
}
@end

@interface NUPlayLot (InitializingAndRelease)

+ (id)playLotWithNursery:(NUNursery *)aNursery usesGradeKidnapper:(BOOL)aUsesGradeKidnapper;
+ (id)playLotWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeKidnapper:(BOOL)aUsesGradeKidnapper;

- (id)initWithNursery:(NUNursery *)aNursery usesGradeKidnapper:(BOOL)aUsesGradeKidnapper;
- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeKidnapper:(BOOL)aUsesGradeKidnapper;

@end

@interface NUPlayLot (Accessing)

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

- (NSMutableDictionary *)objectToOOPDictionary;
- (void)setObjectToOOPDictionary:(NSMutableDictionary *)anObjectToOOPDictionary;

- (NSMutableSet *)bellSet;
- (void)setBellSet:(NSMutableSet *)anOOPSet;

- (NUU64ODictionary *)changedObjects;
- (void)setChangedObjects:(NUU64ODictionary *)aChangedObjects;

- (NUObjectWrapper *)keyObject;

- (NUBell *)keyBell;
- (void)setKeyBell:(NUBell *)aBell;

- (NUAliaser *)aliaser;
- (void)setAliaser:(NUAliaser *)anAliaser;

- (NUGradeKidnapper *)gradeKidnapper;
- (void)setGradeKidnapper:(NUGradeKidnapper *)aGradeKidnapper;

@end

@interface NUPlayLot (Bell)

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

@interface NUPlayLot (SaveAndLoad)

- (void)moveUp;
- (void)moveUpTo:(NUUInt64)aGrade;

- (void)moveUpNurseryRoot;

- (void)moveUpObject:(id)anObject;

- (NUFarmOutStatus)farmOut;
- (void)close;

@end

@interface NUPlayLot (Characters)

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

@interface NUPlayLot (ObjectState)

- (void)markChangedObject:(id)anObject;
- (void)unmarkChangedObject:(id)anObject;

@end

@interface NUPlayLot (Testing)

- (BOOL)contains:(id)anObject;
- (BOOL)needsEncode:(id)anObject;

- (BOOL)isForMainBranch;
- (BOOL)gradeIsEqualToNurseryGrade;

- (BOOL)isInMoveUp;

@end

@interface NUPlayLot (Private) <NSLocking>

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
- (void)invalidateBell:(NUBell *)aBell;

- (void)kidnapGradeLessThan:(NUUInt64)aGrade;
- (void)kidnapBellsWithGradeLessThan:(NUUInt64)aGrade;

@end
