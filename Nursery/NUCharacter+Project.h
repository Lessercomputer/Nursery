//
//  NUCharacter+Project.h
//  Nursery
//
//  Created by Akifumi Takata on 2018/04/29.
//

#import "NUCharacter.h"

@interface NUCharacter (Private)

+ (id)characterWithName:(NSString *)aName super:(NUCharacter *)aSuper;

- (id)initWithName:(NSString *)aName super:(NUCharacter *)aSuper;

- (void)setSuperCharacter:(NUCharacter *)aSuper;
- (void)setName:(NSString *)aName;

- (NSMutableArray *)ivars;
- (void)setIvars:(NSMutableArray *)anIvars;
- (NSArray *)allOOPIvars;
- (NSUInteger)allOOPIvarsCount;
- (void)setAllOOPIvars:(NSArray *)anOOPIvars;
- (NSArray *)allIvars;
- (NSArray *)getAllIvars;
- (void)setAllIvars:(NSArray *)anIvars;
- (NSDictionary *)allIvarDictionary;
- (NSDictionary *)allIvarDictionaryFrom:(NSArray *)anIvars;
- (NUIvar *)ivarInAllOOPIvarsAt:(NSUInteger)anIndex;
- (NSArray *)getAllOOPIvars;
- (NUIvar *)ivarInAllIvarsAt:(NSUInteger)anIndex;
- (NUUInt64)ivarOffsetForName:(NSString *)aName;
- (NSString *)getInheritanceNameWithVersion;
- (void)setInheritanceNameWithVersion:(NSString *)anInheritanceNameWithVersion;
- (NSMutableSet *)subCharacters;
- (void)setSubCharacters:(NSMutableSet *)aSubCharacters;
- (void)addSubCharacter:(NUCharacter *)aCharacter;
- (void)removeSubCharacter:(NUCharacter *)aCharacter;
- (void)addToSuperCharacter;
- (void)removeFromSuperCharacter;

- (NUUInt64)basicSize;
- (NUUInt64)computeBasicSize;
- (void)computeIvarOffset;
- (NUUInt64)indexedIvarOffset;

- (void)moveUp;

@end
