//
//  NUGarden.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <stdlib.h>
#import <objc/runtime.h>
#import <Foundation/NSIndexSet.h>
#import <Foundation/NSException.h>

#import "NUGarden.h"
#import "NUGarden+Project.h"
#import "NUObjectTable.h"
#import "NUCharacter.h"
#import "NUDefaultCharacterTargetClassResolver.h"
#import "NUBell.h"
#import "NUBell+Project.h"
#import "NUObjectWrapper.h"
#import "NUAliaser.h"
#import "NUAliaser+Project.h"
#import "NUGardenSeeker.h"
#import "NUNursery.h"
#import "NUNurseryRoot.h"
#import "NUIvar.h"
#import "NUMainBranchGarden.h"
#import "NUNursery+Project.h"
#import "NUMainBranchNursery.h"
#import "NUMainBranchNursery+Project.h"
#import "NUBranchGarden.h"
#import "NUBellBall.h"
#import "NUCharacterDictionary.h"
#import "NUMutableDictionary.h"
#import "NUNSString.h"
#import "NUNSArray.h"
#import "NUNSDictionary.h"
#import "NUNSSet.h"
#import "NUU64ODictionary.h"

NSString * const NUObjectLoadingException = @"NUObjectLoadingException";

@implementation NUGarden
@end

@implementation NUGarden (InitializingAndRelease)

+ (id)gardenWithNursery:(NUNursery *)aNursery
{
    return [self gardenWithNursery:aNursery usesGardenSeeker:YES];
}

+ (id)gardenWithNursery:(NUNursery *)aNursery usesGardenSeeker:(BOOL)aUsesGardenSeeker
{
    return [self gardenWithNursery:aNursery usesGardenSeeker:aUsesGardenSeeker retainNursery:YES];
}

+ (id)gardenWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGardenSeeker:(BOOL)aUsesGardenSeeker
{
    return [self gardenWithNursery:aNursery grade:aGrade usesGardenSeeker:aUsesGardenSeeker retainNursery:YES];
}

+ (id)gardenWithNursery:(NUNursery *)aNursery usesGardenSeeker:(BOOL)aUsesGardenSeeker retainNursery:(BOOL)aRetainFlag
{
    return [self gardenWithNursery:aNursery grade:NUNilGrade usesGardenSeeker:aUsesGardenSeeker retainNursery:aRetainFlag];
}

+ (id)gardenWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGardenSeeker:(BOOL)aUsesGardenSeeker retainNursery:(BOOL)aRetainFlag
{
    return [[[self alloc] initWithNursery:aNursery grade:aGrade usesGardenSeeker:aUsesGardenSeeker retainNursery:aRetainFlag] autorelease];
}

- (id)initWithNursery:(NUNursery *)aNursery usesGardenSeeker:(BOOL)aUsesGardenSeeker retainNursery:(BOOL)aRetainFlag
{
    return [self initWithNursery:aNursery grade:NUNilGrade usesGardenSeeker:aUsesGardenSeeker retainNursery:aRetainFlag];
}

- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGardenSeeker:(BOOL)aUsesGardenSeeker  retainNursery:(BOOL)aRetainFlag
{
    if (self = [super init])
    {
        lock = [NSRecursiveLock new];
        gardenID = [aNursery isMainBranch] ? [(NUMainBranchNursery *)aNursery newGardenID] : NUNilGardenID;
        grade = aGrade;
        nursery = aRetainFlag ? [aNursery retain] : aNursery;
        retainNursery = aRetainFlag;
        [self setObjectToBellDictionary:[NSMutableDictionary dictionary]];
        bells = [NUU64ODictionary new];
        [self setChangedObjects:[NUU64ODictionary dictionary]];
        [self setKeyObject:[NUObjectWrapper objectWrapperWithObject:nil]];
        [self setKeyBell:[NUBell bellWithBall:NUNotFoundBellBall garden:self]];
        [self setAliaser:[[[self class] aliaserClass] aliaserWithGarden:self]];
        [self setCharacters:[NUMutableDictionary dictionary]];
        nameWithVersionKeyedCharacters = [NSMutableDictionary new];
        characterTargetClassResolvers = [NSMutableArray new];
        [characterTargetClassResolvers addObject:[[NUDefaultCharacterTargetClassResolver new] autorelease]];
        [self setRetainedGrades:[NSMutableIndexSet indexSet]];
        [self establishSystemCharacters];
        usesGardenSeeker = aUsesGardenSeeker;
        if (aUsesGardenSeeker)
            gardenSeeker = [[[[self class] gardenSeekerClass] gardenSeekerWithGarden:self] retain];
        [[self gardenSeeker] start];
    }
    
    return self;
}

- (void)dealloc
{
    [[self gardenSeeker] stop];
    
    [[[[self bells] copy] autorelease] enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, NUBell *aBell, BOOL *stop){
        [aBell invalidate];
    }];
    
    if (retainNursery)
        [nursery release];
    
    nursery = nil;
    
	[self setNurseryRoot:nil];
    [characterTargetClassResolvers release];
    characterTargetClassResolvers = nil;
    [nameWithVersionKeyedCharacters release];
    nameWithVersionKeyedCharacters = nil;
	[self setCharacters:nil];
	[self setObjectToBellDictionary:nil];
    [bells release];
    bells = nil;
	[self setChangedObjects:nil];
	[self setKeyBell:nil];
	[self setAliaser:nil];
    [self setRetainedGrades:nil];
    [self setGardenSeeker:nil];
    [lock release];
    lock = nil;

	[super dealloc];
}

@end

@implementation NUGarden (Accessing)

- (NUNursery *)nursery
{
    return nursery;
}

- (NUUInt64)ID
{
    return gardenID;
}

- (NUUInt64)grade
{
    return grade;
}

- (NSMutableIndexSet *)retainedGrades
{
    return retainedGrades;
}

- (NUNurseryRoot *)nurseryRoot
{
    [self lock];
    
    if (!root) [self loadNurseryRoot];

    [self unlock];
    
	return root;
}

- (void)setNurseryRoot:(NUNurseryRoot *)aRoot
{
	[root autorelease];
	root = [aRoot retain];
}

- (id)root
{
    return [[self nurseryRoot] userRoot];
}

- (void)setRoot:(id)aRoot
{
    [[self nurseryRoot] setUserRoot:aRoot];
}

- (NUMutableDictionary *)characters
{
	return characters;
}

- (void)setCharacters:(NUMutableDictionary *)aCharacters
{
	[characters autorelease];
	characters = [aCharacters retain];
}

- (NSMutableDictionary *)objectToBellDictionary
{
    return objectToBellDictionary;
}

- (void)setObjectToBellDictionary:(NSMutableDictionary *)anObjectToBellDictionary
{
    [objectToBellDictionary autorelease];
    objectToBellDictionary = [anObjectToBellDictionary retain];
}

- (NUU64ODictionary *)bells
{
    return bells;
}

- (void)setBells:(NUU64ODictionary *)aBells
{
    [bells autorelease];
    bells = [aBells retain];
}

- (NUU64ODictionary *)copyBells
{
    NUU64ODictionary *aCopyOfBells;
    
    [self lock];
    
    aCopyOfBells = [[self bells] copy];
    
    [self unlock];
    
    return aCopyOfBells;
}

- (NUU64ODictionary *)changedObjects
{
	return changedObjects;
}

- (void)setChangedObjects:(NUU64ODictionary *)aChangedObjects
{
	[changedObjects autorelease];
	changedObjects = [aChangedObjects retain];
}

- (NUObjectWrapper *)keyObject
{
    return keyObject;
}

- (NUBell *)keyBell
{
	return keyBell;
}

- (void)setKeyBell:(NUBell *)aBell
{
	[keyBell autorelease];
	keyBell = [aBell retain];
}

- (NUAliaser *)aliaser
{
	return aliaser;
}

- (void)setAliaser:(NUAliaser *)anAliaser
{
	[aliaser autorelease];
	aliaser = [anAliaser retain];
}

- (NUGardenSeeker *)gardenSeeker
{
    return gardenSeeker;
}

- (void)setGardenSeeker:(NUGardenSeeker *)aGardenSeeker
{
    [gardenSeeker autorelease];
    gardenSeeker = [aGardenSeeker retain];
}

@end

@implementation NUGarden (ResolvingCharacterTargetClass)

- (void)addCharacterTargetClassResolver:(id <NUCharacterTargetClassResolving>)aTargetClassResolver
{
    [self lock];
    [characterTargetClassResolvers addObject:aTargetClassResolver];
    [self unlock];
}

- (void)removeCharacterTargetClassResolver:(id <NUCharacterTargetClassResolving>)aTargetClassResolver
{
    [self lock];
    [characterTargetClassResolvers removeObject:aTargetClassResolver];
    [self unlock];
}

@end

@implementation NUGarden (SaveAndLoad)

- (void)moveUp
{
    [self moveUpTo:[self retainLatestGradeOfNursery]];
}

- (void)moveUpWithPreventingReleaseOfCurrentGrade
{
    [self moveUpTo:[self retainLatestGradeOfNursery] preventReleaseOfCurrentGrade:YES];
}

- (void)moveUpTo:(NUUInt64)aGrade
{
    [self moveUpTo:aGrade preventReleaseOfCurrentGrade:NO];
}

- (void)moveUpTo:(NUUInt64)aGrade preventReleaseOfCurrentGrade:(BOOL)aPreventFlag
{
    if ([self grade] >= aGrade) return;
    
    @try
    {
        [self lock];
        if ([self isForMainBranch])
            [(NUMainBranchNursery *)[self nursery] lock];
        
        if (aPreventFlag)
            [[self gardenSeeker] preventReleaseOfGrade:[self grade]];
        
        [self setIsInMoveUp:YES];
        
        [self setGrade:aGrade];
        [self moveUpNurseryRoot];
        [[self gardenSeeker] pushRootBell:[[self nurseryRoot] bell]];
        
        [self setIsInMoveUp:NO];
    }
    @finally
    {
        if ([self isForMainBranch])
            [(NUMainBranchNursery *)[self nursery] unlock];
        [self unlock];
    }
}

- (void)moveUpNurseryRoot
{
    @try {
        [self lock];
        
        NUNurseryRoot *aNurseryRoot = [[[self nurseryRoot] retain] autorelease];
        
        if (![aNurseryRoot bell] || [[self aliaser] rootOOP] != [[aNurseryRoot bell] OOP])
            [self setNurseryRoot:nil];
        
        [[self aliaser] moveUp:[self nurseryRoot] ignoreGradeAtCallFor:NO];
        [self mergeCharacters];
    }
    @finally {
        [self unlock];
    }
}

- (void)mergeCharacters
{
    [[[[self characters] copy] autorelease] enumerateKeysAndObjectsUsingBlock:^(Class _Nonnull aClassForCharacter, NUCharacter * _Nonnull aCharacterInGarden, BOOL * _Nonnull aStop) {
        NUCharacter *aCharacterInNurseryRoot = [self characterForInheritanceNameWithVersion:[aCharacterInGarden inheritanceNameWithVersion]];
        
        if (!aCharacterInNurseryRoot)
            return;
        
        [aCharacterInNurseryRoot setTargetClass:[aCharacterInGarden targetClass]];
        [aCharacterInNurseryRoot setCoderClass:[aCharacterInGarden coderClass]];
        
        if ([self characterForClass:[aCharacterInNurseryRoot targetClass]] != aCharacterInNurseryRoot)
            [self setCharacter:aCharacterInNurseryRoot forClass:[aCharacterInNurseryRoot targetClass]];
    }];
}

- (void)moveUpObject:(id)anObject
{
    [self lock];
    
    @try {
        [[self aliaser] moveUp:anObject ignoreGradeAtCallFor:YES];
    }
    @finally {
        [self unlock];
    }
}

- (NUFarmOutStatus)farmOut
{    
    return NUFarmOutStatusFailed;
}

@end

@implementation NUGarden (Bell)

- (id)objectForBell:(NUBell *)aBell
{
    id anObject = nil;
    
    [self lock];
    
	if ([aBell hasObject]) anObject = [aBell object];
	else if ([aBell OOP] != NUNilOOP) anObject = [self loadObjectForBell:aBell];
	    
    [self unlock];
    
    if ([aBell OOP] != NUNilOOP && !anObject)
        [[NSException exceptionWithName:NUObjectLoadingException reason:NUObjectLoadingException userInfo:nil] raise];
    
    return anObject;
}

- (id)objectForOOP:(NUUInt64)anOOP
{
    id anObject;
    
    [self lock];
    
	NUBell *aBell = [self bellForOOP:anOOP];
	if (!aBell) aBell = [self allocateBellForBellBall:NUMakeBellBall(anOOP, NUNilGrade)];
	anObject = [self objectForBell:aBell];
    
    [self unlock];
    
    return anObject;
}

- (id)loadObjectForBell:(NUBell *)aBell
{
	return [[self aliaser] decodeObjectForBell:aBell];
}

- (NUBell *)bellForObject:(id)anObject
{
    NUBell *aBell = nil;
    
    [self lock];
    
	if ([anObject conformsToProtocol:@protocol(NUCoding)])
		aBell = [anObject bell];
	else
	{
        [[self keyObject] setObject:anObject];
        aBell = [[self objectToBellDictionary] objectForKey:[self keyObject]];
	}
    
    [self unlock];
    
    return aBell;
}

- (NUBell *)bellForOOP:(NUUInt64)anOOP
{
    NUBell *aResultBell = nil;
    
    [self lock];
    
    aResultBell = [bells objectForKey:anOOP];
    
    [self unlock];
    
    return aResultBell;
}

- (NUBell *)allocateBellForBellBall:(NUBellBall)aBellBall
{
	return [self allocateBellForBellBall:aBellBall isLoaded:NO];
}

- (NUBell *)allocateBellForBellBall:(NUBellBall)aBellBall isLoaded:(BOOL)anIsLoaded
{
    NUBell *aBell = [NUBell bellWithBall:aBellBall isLoaded:anIsLoaded garden:self];
    
    @try {
        [self lock];
        [[self bells] setObject:aBell forKey:[aBell OOP]];
    }
    @finally {
        [self unlock];
    }
    
    return aBell;
}

- (void)setObject:(id)anObject forBell:(NUBell *)aBell
{
    if (!anObject) [[NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil] raise];
    
    [self lock];
    
	[aBell setObject:anObject];
	
	if ([anObject conformsToProtocol:@protocol(NUCoding)])
		[anObject setBell:aBell];
	else
        [[self objectToBellDictionary] setObject:aBell forKey:[NUObjectWrapper objectWrapperWithObject:anObject]];
    
    [self unlock];
}

- (void)setObject:(id)anObject forOOP:(NUUInt64)anOOP
{
	[self setObject:anObject forBell:[self bellForOOP:anOOP]];
}

- (void)removeBell:(NUBell *)aBell
{
    @try {
        [self lock];
        
        if ([aBell hasObject])
        {
            if ([[aBell object] conformsToProtocol:@protocol(NUCoding)])
                [[aBell object] setBell:nil];
            else
            {
                [[self keyObject] setObject:[aBell object]];
                [[self objectToBellDictionary] removeObjectForKey:[self keyObject]];
            }
            
            [aBell setObject:nil];
        }

        [aBell setGarden:nil];
        [[self bells] removeObjectForKey:[aBell OOP]];
    }
    @finally {
        [self unlock];
    }
}

- (BOOL)OOPIsProbationary:(NUUInt64)anOOP
{
    return NUDefaultLastProbationaryOOP <= anOOP && anOOP <= NUDefaultFirstProbationayOOP;
}

- (BOOL)bellGradeIsUnmatched:(NUBell *)aBell
{
    return NO;
}

@end

@implementation NUGarden (Characters)

- (NSDictionary *)systemCharacterOOPToClassDictionary
{
    NSDictionary *aDictionary = nil;
    
    aDictionary = @{
                    @(NUCharacterOOP) : [NUCharacter class],
                    @(NSStringOOP) : [NSString class],
                    @(NUNSStringOOP) : [NUNSString class],
                    @(NSArrayOOP) : [NSArray class],
                    @(NUNSArrayOOP) : [NUNSArray class],
                    @(NSMutableArrayOOP) : [NSMutableArray class],
                    @(NUNSMutableArrayOOP) : [NUNSMutableArray class],
                    @(NUIvarOOP) : [NUIvar class],
                    @(NSDictionaryOOP) : [NSDictionary class],
                    @(NUNSDictionaryOOP) : [NUNSDictionary class],
                    @(NSMutableDictionaryOOP) : [NSMutableDictionary class],
                    @(NUNSMutableDictionaryOOP) : [NUNSMutableDictionary class],
                    @(NSObjectOOP) : [NSObject class],
                    @(NUNurseryRootOOP) : [NUNurseryRoot class],
                    @(NUCharacterDictionaryOOP) : [NUCharacterDictionary class],
                    @(NUMutableDictionaryOOP) : [NUMutableDictionary class],
                    @(NSSetOOP) : [NSSet class],
                    @(NUNSSetOOP) : [NUNSSet class],
                    @(NSMutableSetOOP) : [NSMutableSet class],
                    @(NUNSMutableSetOOP) : [NUNSMutableSet class]
                    };

    return aDictionary;
}

- (void)establishSystemCharacters
{
    @try
    {
        [self lock];
        
        [self setNurseryRoot:[NUNurseryRoot root]];
        
        [[self systemCharacterOOPToClassDictionary] enumerateKeysAndObjectsUsingBlock:^(NSNumber *anOOP, Class aClass, BOOL *aStop) {
            NUCharacter *aSystemCharacter = [aClass characterOn:self];
            NUBell *aSystemCharacterBell = [self allocateBellForBellBall:NUMakeBellBall([anOOP unsignedLongLongValue], NUNilGrade) isLoaded:YES];
            [self setObject:aSystemCharacter forBell:aSystemCharacterBell];
        }];
        
        [self setNurseryRoot:nil];
    }
    @finally
    {
        [self unlock];
    }
}

- (void)establishCharacters
{
    @try {
        [self lock];

        unsigned int aClassCount = objc_getClassList(NULL, 0);
        Class *aClasses = objc_copyClassList(&aClassCount);

        for (unsigned int i = 0; i < aClassCount; i++)
        {
            Class aClass = aClasses[i];
            
            if ([self classAutomaticallyEstablishCharacter:aClass])
                [aClass characterOn:self];
        }
        
        free(aClasses);
    }
    @finally {
        [self unlock];
    }
}

- (void)moveUpSystemCharacters
{
    [[self systemCharacterOOPToClassDictionary] enumerateKeysAndObjectsUsingBlock:^(NSNumber *anOOP, Class aClass, BOOL *aStop) {
        [[self objectForOOP:[anOOP unsignedLongLongValue]] moveUp];
    }];
}

- (NUCharacter *)characterForClass:(Class)aClass
{
	return [[self characters] objectForKey:aClass];
}

- (void)setCharacter:(NUCharacter *)aCharacter forClass:(Class)aClass
{
	[[self characters] setObject:aCharacter forKey:(id <NSCopying>)aClass];
}

- (NUCharacter *)characterForNameWithVersion:(NSString *)aName
{
    return [nameWithVersionKeyedCharacters objectForKey:aName];
}

- (void)setCharacter:(NUCharacter *)aCharacter forNameWithVersion:(NSString *)aName
{
    [nameWithVersionKeyedCharacters setObject:aCharacter forKey:aName];
    [self setCharacter:aCharacter forInheritanceNameWithVersion:[aCharacter inheritanceNameWithVersion]];
}

- (NUCharacter *)characterForInheritanceNameWithVersion:(NSString *)aName
{
	return [[[self nurseryRoot] characters] objectForKey:aName];
}

- (void)setCharacter:(NUCharacter *)aCharacter forInheritanceNameWithVersion:(NSString *)aName
{
	[[[self nurseryRoot] characters] setObject:aCharacter forKey:aName];
}

- (void)establishCharacterFor:(Class)aClass
{
	[aClass characterOn:self];
}

@end

@implementation NUGarden (ObjectState)

- (void)markChangedObject:(id)anObject
{
    [self lock];
    
	NUBell *aBell = [self bellForObject:anObject];
	if (aBell)
    {
        if (!([anObject isKindOfClass:[NUCharacter class]] || [anObject isKindOfClass:[NUIvar class]])
            || ([aBell grade] == NUNilGrade || [aBell grade] == [[self aliaser] gradeForSave]))
        {
                [[self changedObjects] setObject:[aBell object] forKey:[aBell OOP]];
        }
    }
    
    [self unlock];
}

- (void)unmarkChangedObject:(id)anObject
{
    [self lock];
    
	NUBell *aBell = [self bellForObject:anObject];
	if (aBell) [[self changedObjects] removeObjectForKey:[aBell OOP]];
    
    [self unlock];
}

@end

@implementation NUGarden (Testing)

- (BOOL)contains:(id)anObject
{
	return [self bellForObject:anObject] ? YES : NO;
}

- (BOOL)needsEncode:(id)anObject
{
	NUBell *aBell = [self bellForObject:anObject];
	return !aBell || [[self changedObjects] objectForKey:[aBell OOP]];
}

- (BOOL)isForMainBranch
{
    return [[self nursery] isMainBranch];
}

- (BOOL)gradeIsEqualToNurseryGrade
{
    return [self grade] == [[self nursery] latestGrade:self];
}

- (BOOL)isInMoveUp
{
    return isInMoveUp;
}

@end

@implementation NUGarden (Private)

- (void)lock
{
    [lock lock];
}

- (void)unlock
{
    [lock unlock];
}

- (void)setNursery:(NUNursery *)aNursery
{
    nursery = aNursery;
}

- (void)saveNurseryRootOOP
{
}

- (NUUInt64)retainLatestGradeOfNursery
{
    NUUInt64 aGrade;
    
    @try {
        [self lock];
        
        aGrade = [[self nursery] retainLatestGradeByGarden:self];
        [[self retainedGrades] addIndex:(NSUInteger)aGrade];
    }
    @finally {
        [self unlock];
    }
    
    return aGrade;
}

- (void)setGrade:(NUUInt64)aGrade
{
    grade = aGrade;
#ifdef DEBUG
    NSLog(@"%@, grade:%@", self, @(aGrade));
#endif
}

- (void)setID:(NUUInt64)anID
{
    gardenID = anID;
}

- (void)setIsInMoveUp:(BOOL)aFlag
{
    isInMoveUp = aFlag;
}

- (NUNurseryRoot *)loadNurseryRoot
{
    if (![[self nursery] open]) return nil;

    [self lock];
    if ([self isForMainBranch])
        [(NUMainBranchNursery *)[self nursery] lock];
    
	NUUInt64 aNurseryRootOOP = [[self aliaser] rootOOP];
    NUNurseryRoot *aNurseryRoot;
    BOOL aShouldMoveUpSystemCharacters = NO;
    
    if (aNurseryRootOOP == NUNilOOP)
    {
        aNurseryRoot = [NUNurseryRoot root];
        [self registerSystemCharactersTo:aNurseryRoot];
    }
    else
    {
        if ([self isInMoveUp] || [self grade] == NUNilGrade)
            [self setGrade:usesGardenSeeker ? [self retainLatestGradeOfNursery] : [[self nursery] latestGrade:self]];
        else
            [self setGrade:[[self nursery] retainGradeIfValid:[self grade] byGarden:self]];
        
        NUBell *aNurseryRootBell = [self allocateBellForBellBall:NUMakeBellBall(aNurseryRootOOP, NUNilGrade)];
        aNurseryRoot = [self objectForBell:aNurseryRootBell];
        [[self gardenSeeker] pushRootBell:aNurseryRootBell];
        aShouldMoveUpSystemCharacters = YES;
    }
    
	[self setNurseryRoot:aNurseryRoot];
    [self prepareNameWithVersionKeyedCharacters];
	[self establishCharacters];
    
    if (aShouldMoveUpSystemCharacters)
        [self moveUpSystemCharacters];
    
    [self resolveTargetClassForTargetClassUnresolvedCharacters];

    if ([self isForMainBranch])
        [(NUMainBranchNursery *)[self nursery] unlock];
    [self unlock];
    
	return aNurseryRoot;
}

- (void)prepareNameWithVersionKeyedCharacters
{
    [[[self nurseryRoot] characters] enumerateUsingBlock:^(NSString *anInheritanceNameWithVersion, NUCharacter *aCharacter, BOOL *aStop) {
        [nameWithVersionKeyedCharacters setObject:aCharacter forKey:[aCharacter nameWithVersion]];
    }];
}

- (void)resolveTargetClassForTargetClassUnresolvedCharacters
{
    [[[self nurseryRoot] characters] enumerateUsingBlock:^(NSString *anInheritanceNameWithVersion, NUCharacter *aCharacter, BOOL *aStop) {
        if (![aCharacter targetClass] && ![aCharacter coderClass])
        {
            [characterTargetClassResolvers enumerateObjectsUsingBlock:^(id <NUCharacterTargetClassResolving>  _Nonnull aCharacterTargetClassResolver, NSUInteger anIndex, BOOL * _Nonnull aStop) {
                BOOL aCharacterTargetClassResolved = [aCharacterTargetClassResolver resolveTargetClassOrCoderForCharacter:aCharacter onGarden:self];
                *aStop = aCharacterTargetClassResolved;
            }];
        }
    }];
}

- (void)registerSystemCharactersTo:(NUNurseryRoot *)aNurseryRoot
{
    [[self systemCharacterOOPToClassDictionary] enumerateKeysAndObjectsUsingBlock:^(NSNumber *anOOP, Class aClass, BOOL *aStop) {
        NUCharacter *aSystemCharacter = [aClass characterOn:self];
        [[aNurseryRoot characters] setObject:aSystemCharacter forKey:[aSystemCharacter inheritanceNameWithVersion]];
        [self markChangedObject:[self objectForOOP:[anOOP unsignedLongLongValue]]];
    }];
}

- (BOOL)classAutomaticallyEstablishCharacter:(Class)aClass
{
    const char *aClassName = class_getName(aClass);
    
    if (!objc_getClass(aClassName))
        return NO;
    
    Class aMetaClass = objc_getMetaClass(aClassName);
    
    do
    {
        unsigned int aCountOfMethods = 0;
        Method *aMethodList = class_copyMethodList(aMetaClass, &aCountOfMethods);
        BOOL aMethodIsFound = NO;
        
        for (unsigned i = 0; i < aCountOfMethods; i++)
        {
            Method aMethod = aMethodList[i];
            
            if (method_getName(aMethod) == @selector(automaticallyEstablishCharacter))
            {
                aMethodIsFound = YES;
                break;
            }
        }
        
        free(aMethodList);
        
        if (aMethodIsFound)
            return [aClass automaticallyEstablishCharacter];
        
        aMetaClass = class_getSuperclass(aMetaClass);
    }
    while (aMetaClass);
    
    return NO;
}

- (void)setKeyObject:(NUObjectWrapper *)anObjectWrapper
{
    [keyObject autorelease];
    keyObject = [anObjectWrapper retain];
}

- (void)setRetainedGrades:(NSMutableIndexSet *)aGrades
{
    [retainedGrades autorelease];
    retainedGrades = [aGrades retain];
}

- (void)invalidateBell:(NUBell *)aBell
{
    [self removeBell:aBell];
}

- (void)collectGradeLessThan:(NUUInt64)aGrade
{
    @try {
        [self lock];
        
        [[self nursery] releaseGradeLessThan:aGrade byGarden:self];
    }
    @finally {
        [self unlock];
    }
}

@end
