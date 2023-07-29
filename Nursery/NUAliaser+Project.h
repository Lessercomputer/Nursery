//
//  NUAliaser+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/29.
//

#import "NUAliaser.h"

@class NUPages, NUCodingContext, NUObjectTable, NUPupilNote, NUU64ODictionary;

@interface NUAliaser (Initializing)

+ (id)aliaserWithGarden:(NUGarden *)aGarden;

- (id)initWithGarden:(NUGarden *)aGarden;

@end

@interface NUAliaser (ProjectAccessing)

- (void)setGarden:(NUGarden *)aGarden;

- (NSMutableArray *)contexts;
- (void)setContexts:(NSMutableArray *)aContexts;

- (NSMutableArray *)roots;
- (void)setRoots:(NSMutableArray *)aRoots;

- (NUQueue *)objectsToEncode;
- (void)setObjectsToEncode:(NUQueue *)anObjectsToEncode;

- (NSMutableArray *)encodedPupils;
- (void)setEncodedPupils:(NSMutableArray *)anEncodedPupils;

- (void)setIndexedIvarOffset:(NUUInt64)anOffset;
- (void)setIndexedIvarsSize:(NUUInt64)aSize;

- (NUUInt64)grade;
- (NUUInt64)gradeForSave;

@end

@interface NUAliaser (ProjectTesting)

- (BOOL)isForMainBranch;

@end

@interface NUAliaser (Bell)

- (NUBell *)allocateBellForObject:(id)anObject;

@end

@interface NUAliaser (Contexts)

- (NUCodingContext *)currentContext;
- (void)pushContext:(NUCodingContext *)aContext;
- (NUCodingContext *)popContext;

@end

@interface NUAliaser (ProjectEncoding)

- (void)encodeObjects;
- (void)encodeRoots;
- (void)encodeChangedObjects;

- (void)encodeObjectsFromStarter;
- (void)encodeObjectReally:(id)anObject;
- (void)ensureCharacterRegistration:(NUCharacter *)aCharacter;
- (void)prepareCodingContextForEncode:(id)anObject;
- (NUU64ODictionary *)reducedEncodedPupilsDictionary:(NSArray *)anEncodedPupils;
- (NSArray *)reducedEncodedPupilsFor:(NSArray *)anEncodedPupils with:(NUU64ODictionary *)aReducedEncodedPupilsDictionary;
- (NUUInt64)sizeOfEncodedObjects:(NSArray *)aReducedEncodedPupils;
- (NUUInt64)sizeOfEncodedObjects:(NSArray *)aReducedEncodedPupils with:(NUU64ODictionary *)aReducedEncodedPupilsDictionary;
- (void)objectDidEncode:(NUBell *)aBell;
- (id)nextObjectToEncode;

- (void)validateObjectForEncoding:(id)anObject;
- (void)validateGardenOfEncodingObject:(id)anObject;

- (NUUInt64)preEncodeObject:(id)anObject;

@end

@interface NUAliaser (ProjectDecoding)

- (NSMutableArray *)decodeRoots;
- (NSMutableArray *)decodeObjectsFromStarter;

- (id)decodeObjectForOOP:(NUUInt64)aRawOOP really:(BOOL)aReallyDecode;
- (id)decodeObjectForBell:(NUBell *)aBell;
- (void)prepareCodingContextForDecode:(NUBell *)aBell;
- (id)decodeObjectForBell:(NUBell *)aBell classOOP:(NUUInt64)aClassOOP;
- (void)ensureCharacterForDecoding:(NUCharacter *)aCharacter;

- (void)prepareCodingContextForMoveUp:(NUBell *)aBell;

- (NUUInt64)objectLocationForBell:(NUBell *)aBell gradeInto:(NUUInt64 *)aGrade;

@end

@interface NUAliaser (ObjectSpace)

- (NUUInt64)computeSizeOfObject:(id)anObject;

@end

@interface NUAliaser (Pupil)

- (void)fixProbationaryOOPsInPupil:(NUPupilNote *)aPupilNote;
- (void)fixProbationaryOOPAtOffset:(NUUInt64)anIvarOffset inPupil:(NUPupilNote *)aPupilNote character:(NUCharacter *)aCharacter;

@end
