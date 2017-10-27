//
//  NUSandbox.m
//  Nursery
//
//  Created by P,T,A on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUSandbox.h"
#import "NUObjectTable.h"
#import "NUCharacter.h"
#import "NUBell.h"
#import "NUObjectWrapper.h"
#import "NUAliaser.h"
#import "NUGradeSeeker.h"
#import "NUNursery.h"
#import "NUNurseryRoot.h"
#import "NUIvar.h"
#import "NUMainBranchSandbox.h"
#import "NUBranchSandbox.h"
#import "NUBellBall.h"
#import "NUCharacterDictionary.h"
#import "NUNSString.h"
#import "NUNSArray.h"
#import "NUNSDictionary.h"
#import "NUNSSet.h"
#import "NUU64ODictionary.h"
#import <objc/objc-runtime.h>

NSString * const NUObjectLoadingException = @"NUObjectLoadingException";

@implementation NUSandbox
@end

@implementation NUSandbox (InitializingAndRelease)

+ (id)sandboxWithNursery:(NUNursery *)aNursery usesGradeSeeker:(BOOL)aUsesGradeSeeker
{
    return [self sandboxWithNursery:aNursery grade:NUNilGrade usesGradeSeeker:aUsesGradeSeeker];
}

+ (id)sandboxWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker
{
    Class aSandboxClass = [aNursery isMainBranch] ? [NUMainBranchSandbox class] : [NUBranchSandbox class];
    return [[[aSandboxClass alloc] initWithNursery:aNursery grade:aGrade usesGradeSeeker:aUsesGradeSeeker] autorelease];
}

- (id)initWithNursery:(NUNursery *)aNursery usesGradeSeeker:(BOOL)aUsesGradeSeeker
{
    return [self initWithNursery:aNursery grade:NUNilGrade usesGradeSeeker:aUsesGradeSeeker];
}

- (id)initWithNursery:(NUNursery *)aNursery grade:(NUUInt64)aGrade usesGradeSeeker:(BOOL)aUsesGradeSeeker
{
    if (self = [super init])
    {
        lock = [NSRecursiveLock new];
        sandboxID = [aNursery isMainBranch] ? [(NUMainBranchNursery *)aNursery newSandboxID] : NUNilSandboxID;
        grade = aGrade;
        [self setNursery:aNursery];
        [self setObjectToOOPDictionary:[NSMutableDictionary dictionary]];
        [self setBellSet:[NSMutableSet set]];
        [self setChangedObjects:[NUU64ODictionary dictionary]];
        [self setKeyObject:[NUObjectWrapper objectWrapperWithObject:nil]];
        [self setKeyBell:[NUBell bellWithBall:NUNotFoundBellBall sandbox:self]];
        [self setAliaser:[NUAliaser aliaserWithSandbox:self]];
        [self setCharacters:[NUMutableDictionary dictionary]];
        [self setRetainedGrades:[NSMutableIndexSet indexSet]];
        [self establishSystemCharacters];
        usesGradeSeeker = aUsesGradeSeeker;
        if (aUsesGradeSeeker) gradeSeeker = [[NUGradeSeeker gradeSeekerWithSandbox:self] retain];
        [[self gradeSeeker] prepare];
    }
    
    return self;
}

- (void)dealloc
{
	[self setNurseryRoot:nil];
	[self setCharacters:nil];
	[self setObjectToOOPDictionary:nil];
	[self setBellSet:nil];
	[self setChangedObjects:nil];
	[self setKeyBell:nil];
	[self setAliaser:nil];
    [self setRetainedGrades:nil];
    [self setGradeSeeker:nil];
    [lock release];

	[super dealloc];
}

@end

@implementation NUSandbox (Accessing)

- (NUNursery *)nursery
{
    return nursery;
}

- (NUUInt64)ID
{
    return sandboxID;
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
    [lock lock];
    
    if (!root) [self loadNurseryRoot];

    [lock unlock];
    
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

- (NSMutableDictionary *)objectToOOPDictionary
{
	return objectToOOPDictionary;
}

- (void)setObjectToOOPDictionary:(NSMutableDictionary *)anObjectToOOPDictionary
{
	[objectToOOPDictionary autorelease];
	objectToOOPDictionary = [anObjectToOOPDictionary retain];
}

- (NSMutableSet *)bellSet
{
	return bellSet;
}

- (void)setBellSet:(NSMutableSet *)anOOPSet
{
	[bellSet autorelease];
	bellSet = [anOOPSet retain];
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

- (NUGradeSeeker *)gradeSeeker
{
    return gradeSeeker;
}

- (void)setGradeSeeker:(NUGradeSeeker *)aGradeSeeker
{
    [gradeSeeker autorelease];
    gradeSeeker = [aGradeSeeker retain];
}

@end

@implementation NUSandbox (SaveAndLoad)

- (void)moveUp
{
    [self moveUpTo:[self retainLatestGradeOfNursery]];
}

- (void)moveUpTo:(NUUInt64)aGrade
{
    if ([self grade] >= aGrade) return;
    
    [[self gradeSeeker] stop];
    [self lock];
    [self setIsInMoveUp:YES];
    
    [self setGrade:aGrade];
    [self moveUpNurseryRoot];
    [[self gradeSeeker] pushRootBell:[[self nurseryRoot] bell]];
    
    [self setIsInMoveUp:NO];
    [self unlock];
    [[self gradeSeeker] start];
}

- (void)moveUpNurseryRoot
{
    @try {
        [self lock];
        
        NUNurseryRoot *aNurseryRoot = [[[self nurseryRoot] retain] autorelease];
        
        if (![aNurseryRoot bell] || [[self aliaser] rootOOP] != [[aNurseryRoot bell] OOP])
            [self setNurseryRoot:nil];
        
        [[self nurseryRoot] moveUp];
    }
    @finally {
        [self unlock];
    }
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

- (void)close
{
    [[self gradeSeeker] terminate];
    
    @try {
        [self lock];
        
        [[[[self bellSet] copy] autorelease] enumerateObjectsUsingBlock:^(id aBell, BOOL *stop) {
            [aBell invalidate];
        }];
        
        [[self nursery] sandboxDidClose:self];
    }
    @finally {
        [self unlock];
    }
}

@end

@implementation NUSandbox (Bell)

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
		aBell = [[self objectToOOPDictionary] objectForKey:[self keyObject]];
	}
    
    [self unlock];
    
    return aBell;
}

- (NUBell *)bellForOOP:(NUUInt64)anOOP
{
    NUBell *aResultBell = nil;
    
    [self lock];
    
	NUBell *aKeyBell = [self keyBell];
	[aKeyBell setOOP:anOOP];
	aResultBell = [[self bellSet] member:aKeyBell];
    
    [self unlock];
    
    return aResultBell;
}

- (NUBell *)allocateBellForBellBall:(NUBellBall)aBellBall
{
	return [self allocateBellForBellBall:aBellBall isLoaded:NO];
}

- (NUBell *)allocateBellForBellBall:(NUBellBall)aBellBall isLoaded:(BOOL)anIsLoaded
{
    NUBell *aBell = [NUBell bellWithBall:aBellBall isLoaded:anIsLoaded sandbox:self];
    
    @try {
        [self lock];
        [[self bellSet] addObject:aBell];
        return aBell;
    }
    @finally {
        [self unlock];
    }
}

- (void)setObject:(id)anObject forBell:(NUBell *)aBell
{
    if (!anObject) [[NSException exceptionWithName:NSInvalidArgumentException reason:nil userInfo:nil] raise];
    
    [self lock];
    
	[aBell setObject:anObject];
	
	if ([anObject conformsToProtocol:@protocol(NUCoding)])
		[anObject setBell:aBell];
	else
		[[self objectToOOPDictionary] setObject:aBell forKey:[NUObjectWrapper objectWrapperWithObject:anObject]];
    
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
                [[aBell object] setBell:aBell];
            else
            {
                [[self keyObject] setObject:[aBell object]];
                [[self objectToOOPDictionary] removeObjectForKey:[self keyObject]];
            }
            
            [aBell setObject:nil];
        }

        [aBell setSandbox:nil];
        [[self bellSet] removeObject:aBell];
    }
    @finally {
        [self unlock];
    }
}

- (BOOL)OOPIsProbationary:(NUUInt64)anOOP
{
    return NUDefaultLastProbationaryOOP <= anOOP && anOOP <= NUDefaultFirstProbationayOOP;
}

@end

@implementation NUSandbox (Characters)

- (NSDictionary *)systemCharacterOOPToClassDictionary
{
    NSDictionary *aDictionary = [NSMutableDictionary dictionary];
    
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
            [self setObject:[aClass characterOn:self]
                    forBell:[self allocateBellForBellBall:NUMakeBellBall([anOOP unsignedLongLongValue], NUFirstGrade) isLoaded:YES]];
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
        
        int aClassCount = objc_getClassList(NULL, 0);
        Class *aClasses = malloc(sizeof(Class) * aClassCount);
        aClassCount = objc_getClassList(aClasses, aClassCount);
        int i;
        for (i = 0; i < aClassCount; i++)
        {
            Class aClass = aClasses[i];
            
            if (!class_isMetaClass(aClass)
                && [self class:aClass isKindOfClass:[NSObject class]]
				&& [aClass automaticallyEstablishCharacter]
                && ![NSStringFromClass(aClass) hasPrefix:@"NSKVONotifying_"])
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

- (NUCharacter *)characterForName:(NSString *)aName
{
	return [[[self nurseryRoot] characters] objectForKey:aName];
}

- (void)setCharacter:(NUCharacter *)aCharacter forName:(NSString *)aName
{
	[[[self nurseryRoot] characters] setObject:aCharacter forKey:aName];
}

- (void)establishCharacterFor:(Class)aClass
{
	[aClass characterOn:self];
}

@end

@implementation NUSandbox (ObjectState)

- (void)markChangedObject:(id)anObject
{
    [self lock];
    
	NUBell *aBell = [self bellForObject:anObject];
	if (aBell)
        [[self changedObjects] setObject:[aBell object] forKey:[aBell OOP]];
    
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

@implementation NUSandbox (Testing)

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

@implementation NUSandbox (Private)

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
    @try {
        [self lock];
        
        NUUInt64 aGrade = [[self nursery] retainLatestGradeBySandbox:self];
        [[self retainedGrades] addIndex:aGrade];
        return aGrade;
    }
    @finally {
        [self unlock];
    }
}

- (void)setGrade:(NUUInt64)aGrade
{
    grade = aGrade;
}

- (void)setID:(NUUInt64)anID
{
    sandboxID = anID;
}

- (void)setIsInMoveUp:(BOOL)aFlag
{
    isInMoveUp = aFlag;
}

- (NUNurseryRoot *)loadNurseryRoot
{
    if (![[self nursery] open]) return nil;
    
	NUUInt64 aNurseryRootOOP = [[self aliaser] rootOOP];
    NUNurseryRoot *aNurseryRoot;
    BOOL aShouldMoveUpSystemCharacters = NO;
    
    if (aNurseryRootOOP == NUNilOOP)
    {
        aNurseryRoot = [NUNurseryRoot root];
        [self markSystemCharactersChanged];
    }
    else
    {
        if ([self isInMoveUp] || [self grade] == NUNilGrade)
            [self setGrade:usesGradeSeeker ? [self retainLatestGradeOfNursery] : [[self nursery] latestGrade:self]];
        else
            [self setGrade:[[self nursery] retainGradeIfValid:[self grade] bySandbox:self]];
        
        NUBell *aNurseryRootBell = [self allocateBellForBellBall:NUMakeBellBall(aNurseryRootOOP, NUNilGrade)];
        aNurseryRoot = [self objectForBell:aNurseryRootBell];
        [[self gradeSeeker] pushRootBell:aNurseryRootBell];
        aShouldMoveUpSystemCharacters = YES;
    }
    
	[self setNurseryRoot:aNurseryRoot];
	[self establishCharacters];
    
    if (aShouldMoveUpSystemCharacters)
        [self moveUpSystemCharacters];

	return aNurseryRoot;
}

- (void)markSystemCharactersChanged
{
    [[self systemCharacterOOPToClassDictionary] enumerateKeysAndObjectsUsingBlock:^(NSNumber *anOOP, Class aClass, BOOL *aStop) {
        [self markChangedObject:[self objectForOOP:[anOOP unsignedLongLongValue]]];
    }];
}

- (BOOL)class:(Class)aClass isKindOfClass:(Class)anAnsestorClass
{
	Class aSuperClass = aClass;
	
	while (aSuperClass && aSuperClass != anAnsestorClass)
		aSuperClass = class_getSuperclass(aSuperClass);
	
	return aSuperClass ? YES : NO;
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

- (void)invalidateBellsWithNotReferencedObject
{
    @try {
        [self lock];
        
        [[self bellSet] enumerateObjectsUsingBlock:^(NUBell *aBell, BOOL *stop) {
            [aBell invalidateObjectIfNotReferenced];
        }];
    }
    @finally {
        [self unlock];
    }
}

- (void)invalidateObjectIfNotReferencedForBell:(NUBell *)aBell
{
    @try {
        [self lock];
                
        if ([aBell hasObject] && [[aBell object] retainCount] == 1)
        {
            [[self keyObject] setObject:[aBell object]];
            [[self objectToOOPDictionary] removeObjectForKey:[self keyObject]];
            [aBell setObject:nil];
        }
    }
    @finally {
        [self unlock];
    }
}

- (void)invalidateNotReferencedBells
{
    @try {
        [self lock];
        
        [[[[self bellSet] copy] autorelease] enumerateObjectsUsingBlock:^(NUBell *aBell, BOOL *stop) {
            if ([aBell retainCount] == 1 && (![aBell hasObject] || [[aBell object] retainCount] == 1))
                [self invalidateBell:aBell];
        }];
    }
    @finally {
        [self unlock];
    }
}

- (void)invalidateBell:(NUBell *)aBell
{
    [self removeBell:aBell];
}

- (void)kidnapGradeLessThan:(NUUInt64)aGrade
{
    @try {
        [self lock];
        
        [self kidnapBellsWithGradeLessThan:aGrade];
        [[self nursery] releaseGradeLessThan:aGrade bySandbox:self];            
    }
    @finally {
        [self unlock];
    }
}

- (void)kidnapBellsWithGradeLessThan:(NUUInt64)aGrade
{
    @try {
        [self lock];
        
        [[[[self bellSet] copy] autorelease] enumerateObjectsUsingBlock:^(NUBell *aBell, BOOL *stop) {
            if ([aBell gradeAtCallFor] < aGrade
                && ([aBell retainCount] == 1 && (![aBell hasObject] || [[aBell object] retainCount] == 1)))
                [self removeBell:aBell];
        }];
    }
    @finally {
        [self unlock];
    }
}

@end
