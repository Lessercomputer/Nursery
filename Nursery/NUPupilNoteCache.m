//
//  NUPupilNoteCache.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Foundation/NSArray.h>
#import <Foundation/NSLock.h>
#import <Foundation/NSIndexSet.h>

#import "NUPupilNoteCache.h"
#import "NUPupilNote.h"
#import "NUBellBall.h"
#import "NUBellBallODictionary.h"
#import "NULibrary.h"

@implementation NUPupilNoteCache

+ (instancetype)pupilNoteCacheWithMaxCacheSizeInBytes:(NUUInt64)aMaxCacheSizeInBytes cacheablePupilNoteMaxSizeInBytes:(NUUInt64)aCacheablePupilNoteMaxSizeInBytes
{
    return [[[self alloc] initWithMaxCacheSizeInBytes:aMaxCacheSizeInBytes cacheablePupilNoteMaxSizeInBytes:aCacheablePupilNoteMaxSizeInBytes] autorelease];
}

- (instancetype)initWithMaxCacheSizeInBytes:(NUUInt64)aMaxCacheSizeInBytes cacheablePupilNoteMaxSizeInBytes:(NUUInt64)aCacheablePupilNoteMaxSizeInBytes
{
    if (self = [super init])
    {
        lock = [NSLock new];
        bellBallToLinkedListElementDictionary = [NUBellBallODictionary new];
        gradeAndOOPToLinkedListElementLibrary = [NULibrary new];
        maxCacheSizeInBytes = aMaxCacheSizeInBytes;
        cacheablePupilNoteMaxSizeInBytes = aCacheablePupilNoteMaxSizeInBytes;
    }
    
    return self;
}

- (id)init
{
    return [self initWithMaxCacheSizeInBytes:1024 * 1024 * 30 cacheablePupilNoteMaxSizeInBytes:1024 * 4];
}

- (void)dealloc
{
    [bellBallToLinkedListElementDictionary release];
    [gradeAndOOPToLinkedListElementLibrary release];
    [lock release];
    
    [super dealloc];
}

- (NUUInt64)maxCacheSizeInBytes
{
    return maxCacheSizeInBytes;
}

- (NUUInt64)cacheablePupilNoteMaxSizeInBytes
{
    return cacheablePupilNoteMaxSizeInBytes;
}

- (NUPupilNote *)pupilNoteForOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade
{
    [lock lock];

    NUPupilNote *aPupilNote = nil;
    NUPupilNoteCacheKey *aKey = [NUPupilNoteCacheKey keyWithGrade:aGrade oop:anOOP];
    NUPupilNoteCacheLinkedListElement *aLinkedListElement = [gradeAndOOPToLinkedListElementLibrary objectForKey:aKey];
    
    if (aLinkedListElement)
        [self accessed:aLinkedListElement];
    
    aPupilNote = [aLinkedListElement pupilNote];

    [lock unlock];
    
    return aPupilNote;
}

- (NUPupilNote *)pupilNoteForOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade containsFellowPupils:(BOOL)aContainsFellowPupils
{
    if (!aContainsFellowPupils)
        return [self pupilNoteForOOP:anOOP grade:aGrade];
    
    return nil;
}

- (void)addPupilNote:(NUPupilNote *)aPupilNote grade:(NUUInt64)aGrade
{
    if ([aPupilNote size] > [self cacheablePupilNoteMaxSizeInBytes])
        return;
    
    [lock lock];

    if ([self addLinkedListElementForPupilNoteIfNeeded:aPupilNote])
        cachSizeInBytes += [aPupilNote size];
        
    NUBellBall aBellBallForPupilNote = NUMakeBellBall([aPupilNote OOP], [aPupilNote grade]);
    NUPupilNoteCacheKey *aKeyWithGradeAndOOP = [NUPupilNoteCacheKey keyWithGrade:aGrade oop:[aPupilNote OOP]];
    NUPupilNoteCacheLinkedListElement *aLinkedListElement = [gradeAndOOPToLinkedListElementLibrary objectForKey:aKeyWithGradeAndOOP];
    
    if (!aLinkedListElement)
    {
        aLinkedListElement = [bellBallToLinkedListElementDictionary objectForKey:aBellBallForPupilNote];
        
        [aLinkedListElement addReferencingGrade:aGrade];
        
        [gradeAndOOPToLinkedListElementLibrary setObject:aLinkedListElement forKey:aKeyWithGradeAndOOP];
    }
    
    if (aLinkedListElement)
        [self accessed:aLinkedListElement];
    
    [self trimIfOverLimit];
    
    [lock unlock];
}

- (void)addPupilNotes:(NSArray *)aPupilNotes grade:(NUUInt64)aGrade
{
    [aPupilNotes enumerateObjectsUsingBlock:^(NUPupilNote *aPupilNote, NSUInteger idx, BOOL *stop) {
        [self addPupilNote:aPupilNote grade:aGrade];
    }];
}

- (BOOL)addLinkedListElementForPupilNoteIfNeeded:(NUPupilNote *)aPupilNote
{
    NUBellBall aBellBallForPupilNote = NUMakeBellBall([aPupilNote OOP], [aPupilNote grade]);
    NUPupilNoteCacheLinkedListElement *anExistingLinkedListElement = [bellBallToLinkedListElementDictionary objectForKey:aBellBallForPupilNote];
    NUPupilNoteCacheLinkedListElement *anExistingOrNewLinkedListElement = anExistingLinkedListElement;
    
    if (!anExistingLinkedListElement)
    {
        anExistingOrNewLinkedListElement = [NUPupilNoteCacheLinkedListElement linkedListElementWithPupilNote:aPupilNote];
        
        [bellBallToLinkedListElementDictionary setObject:anExistingOrNewLinkedListElement forKey:aBellBallForPupilNote];
        
        return YES;
    }
    
    return NO;
}

- (void)accessed:(NUPupilNoteCacheLinkedListElement *)aLinkedListElement
{
    if (!aLinkedListElement) return;
    
    if (head)
    {
        [head setPrevious:aLinkedListElement];
        [aLinkedListElement setNext:head];
        head = aLinkedListElement;
    }
    else
    {
        head = aLinkedListElement;
        tail = aLinkedListElement;
    }
}

- (void)trimIfOverLimit
{
    while (cachSizeInBytes > maxCacheSizeInBytes)
    {
        NUPupilNoteCacheLinkedListElement *anOldTail = tail;
        
        [[tail previous] setNext:nil];
        tail = [tail previous];
        
        cachSizeInBytes -= [[anOldTail pupilNote] size];
        
        [[anOldTail referencingGrades] enumerateIndexesUsingBlock:^(NSUInteger aGrade, BOOL * _Nonnull stop) {
            [gradeAndOOPToLinkedListElementLibrary removeObjectForKey:[NUPupilNoteCacheKey keyWithGrade:aGrade oop:[[anOldTail pupilNote] OOP]]];
        }];
        
        [bellBallToLinkedListElementDictionary removeObjectForKey:NUMakeBellBall([[anOldTail pupilNote] OOP], [[anOldTail pupilNote] grade])];
    }
}

@end

@implementation NUPupilNoteCacheKey

+ (instancetype)keyWithGrade:(NUUInt64)aGrade oop:(NUUInt64)anOOP
{
    return [[[self alloc] initWithGrade:aGrade oop:anOOP] autorelease];
}

- (instancetype)initWithGrade:(NUUInt64)aGrade oop:(NUUInt64)anOOP
{
    if (self = [super init])
    {
        _bellBall = NUMakeBellBall(anOOP, aGrade);
    }
    
    return self;
}

- (NSComparisonResult)compare:(NUPupilNoteCacheKey *)anOtherKey
{
    NUBellBall anOtherBellBall = [anOtherKey bellBall];
    
    return (NSComparisonResult)NUBellBallCompare((NUUInt8 *)&_bellBall, (NUUInt8 *)&anOtherBellBall);
}

@end

@implementation NUPupilNoteCacheLinkedListElement

+ (instancetype)linkedListElementWithPupilNote:(NUPupilNote *)aPupilNote
{
    return [[[self alloc] initWithPupilNote:aPupilNote] autorelease];
}

- (void)dealloc
{
    [_pupilNote release];
    [_referencingGrades release];
    
    [super dealloc];
}

- (instancetype)initWithPupilNote:(NUPupilNote *)aPupilNote
{
    if (self = [super init])
    {
        _pupilNote = [aPupilNote retain];
        _referencingGrades = [NSMutableIndexSet new];
    }
    
    return self;
}

- (void)addReferencingGrade:(NUUInt64)aGrade
{
    [[self referencingGrades] addIndex:aGrade];
}

@end
