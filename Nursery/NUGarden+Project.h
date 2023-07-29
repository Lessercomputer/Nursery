//
//  NUGarden+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/28.
//

#import "NUGarden.h"

@class NUCharacter;

@interface NUGarden (ProjectAccessing)

- (NUUInt64)ID;

- (NSMutableIndexSet *)retainedGrades;

- (NUUInt64)retainedGradeLessThan:(NUUInt64)aGrade;

- (NUNurseryRoot *)nurseryRoot;
- (void)setNurseryRoot:(NUNurseryRoot *)aRoot;

- (NUMutableDictionary *)characters;
- (void)setCharacters:(NUMutableDictionary *)aCharacters;

- (NSMutableDictionary *)objectToBellDictionary;
- (void)setObjectToBellDictionary:(NSMutableDictionary *)anObjectToBellDictionary;

- (NUU64ODictionary *)bells;
- (void)setBells:(NUU64ODictionary *)aBells;

- (NUU64ODictionary *)copyBells;

- (NUU64ODictionary *)changedObjects;
- (void)setChangedObjects:(NUU64ODictionary *)aChangedObjects;

- (NUObjectWrapper *)keyObject;

- (NUBell *)keyBell;
- (void)setKeyBell:(NUBell *)aBell;

- (NUAliaser *)aliaser;
- (void)setAliaser:(NUAliaser *)anAliaser;

- (NUGardenSeeker *)gardenSeeker;
- (void)setGardenSeeker:(NUGardenSeeker *)aGardenSeeker;

+ (Class)aliaserClass;
+ (Class)apertureClass;
+ (Class)gardenSeekerClass;

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

- (BOOL)bellGradeIsUnmatched:(NUBell *)aBell;

@end

@interface NUGarden (ProjectSaveAndLoad)

- (void)moveUpNurseryRoot;

@end

@interface NUGarden (Characters)

- (NSDictionary *)systemCharacterOOPToClassDictionary;

- (void)establishSystemCharacters;
- (void)establishCharacters;
- (void)moveUpSystemCharacters;

- (NUCharacter *)characterForClass:(Class)aClass;
- (void)setCharacter:(NUCharacter *)aCharacter forClass:(Class)aClass;

- (NUCharacter *)characterForNameWithVersion:(NSString *)aName;
- (void)setCharacter:(NUCharacter *)aCharacter forNameWithVersion:(NSString *)aName;

- (NUCharacter *)characterForInheritanceNameWithVersion:(NSString *)aName;
- (void)setCharacter:(NUCharacter *)aCharacter forInheritanceNameWithVersion:(NSString *)aName;

- (void)establishCharacterFor:(Class)aClass;

@end

@interface NUGarden (Testing)

- (BOOL)contains:(id)anObject;
- (BOOL)needsEncode:(id)anObject;

- (BOOL)isForMainBranch;
- (BOOL)gradeIsEqualToNurseryGrade;

- (BOOL)isFarmingOutForbidden;

- (BOOL)isInMoveUp;

@end

@interface NUGarden (Private) <NSLocking>

- (void)setNursery:(NUNursery *)aNursery;

- (void)saveNurseryRootOOP;
- (NUNurseryRoot *)loadNurseryRoot;
- (void)prepareNameWithVersionKeyedCharacters;
- (void)resolveTargetClassForTargetClassUnresolvedCharacters;
- (void)registerSystemCharactersTo:(NUNurseryRoot *)aNurseryRoot;

- (NUUInt64)retainLatestGradeOfNursery;

- (void)setGrade:(NUUInt64)aGrade;
- (void)setID:(NUUInt64)anID;
- (void)setIsFarmingOutForbidden:(BOOL)aFlag;
- (void)setIsInMoveUp:(BOOL)aFlag;

- (BOOL)classAutomaticallyEstablishCharacter:(Class)aClass;

- (void)setKeyObject:(NUObjectWrapper *)anObjectWrapper;

- (void)setRetainedGrades:(NSMutableIndexSet *)aGrades;

- (void)invalidateBell:(NUBell *)aBell;

- (void)collectGradeLessThan:(NUUInt64)aGrade;

@end
