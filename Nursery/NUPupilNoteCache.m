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
#import "NULinkedList.h"

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
        linkedList = [NULinkedList new];
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
    [linkedList release];
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

- (NUPupilNote *)pupilNoteForOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade containsFellowPupils:(BOOL)aContainsFellowPupils maxFellowPupilNotesSizeInBytes:(NUUInt64)aMaxFellowPupilNotesSizeInBytes pupilNotesInto:(NSArray **)aPupilNotes
{
    __block NUPupilNote *aPupilNote = nil;
    
    if (!aContainsFellowPupils)
    {
        aPupilNote = [self pupilNoteForOOP:anOOP grade:aGrade];
        return aPupilNote;
    }
    
    NSMutableArray *aPupilNotesArray = [NSMutableArray array];
    __block NUUInt64 aCurrentPupilNotesSizeInBytes = 0;
    NUPupilNoteCacheKey *aKey = [NUPupilNoteCacheKey keyWithGrade:aGrade oop:anOOP];
    [gradeAndOOPToLinkedListElementLibrary enumerateKeysAndObjectsWithKeyGreaterThan:aKey orEqual:YES options:0 usingBlock:^(NUPupilNoteCacheKey *aKey, NUPupilNoteCacheLinkedListElement *aLinkedListElement, BOOL *aStop) {
        
        if ([aKey bellBall].grade == aGrade)
        {
            if ([aKey bellBall].oop == anOOP)
                aPupilNote = [aLinkedListElement pupilNote];
            
            if (aCurrentPupilNotesSizeInBytes + [[aLinkedListElement pupilNote] sizeForSerialization] <= aMaxFellowPupilNotesSizeInBytes)
            {
                [aPupilNotesArray addObject:[aLinkedListElement pupilNote]];
                aCurrentPupilNotesSizeInBytes += [[aLinkedListElement pupilNote] sizeForSerialization];
            }
            else
                *aStop = YES;
        }
        else
            *aStop = YES;
    }];
    
    if (aPupilNotes)
        *aPupilNotes = aPupilNotesArray;
    
    return aPupilNote;
}

- (void)addPupilNote:(NUPupilNote *)aPupilNote grade:(NUUInt64)aGrade
{
    if ([aPupilNote sizeForSerialization] > [self cacheablePupilNoteMaxSizeInBytes])
        return;
    
    [lock lock];

    if ([self addLinkedListElementForPupilNoteIfNeeded:aPupilNote])
        cachSizeInBytes += [aPupilNote sizeForSerialization];
    
    NUPupilNoteCacheKey *aKeyWithGradeAndOOP = [NUPupilNoteCacheKey keyWithGrade:aGrade oop:[aPupilNote OOP]];
    NUPupilNoteCacheLinkedListElement *aLinkedListElement = [gradeAndOOPToLinkedListElementLibrary objectForKey:aKeyWithGradeAndOOP];
    
    if (!aLinkedListElement)
    {
        aLinkedListElement = [bellBallToLinkedListElementDictionary objectForKey:[aPupilNote bellBall]];
        
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
    NUBellBall aBellBallForPupilNote = [aPupilNote bellBall];
    NUPupilNoteCacheLinkedListElement *anExistingLinkedListElement = [bellBallToLinkedListElementDictionary objectForKey:aBellBallForPupilNote];
    NUPupilNoteCacheLinkedListElement *anExistingOrNewLinkedListElement = nil;
    
    if (!anExistingLinkedListElement)
    {
        anExistingOrNewLinkedListElement = [NUPupilNoteCacheLinkedListElement listElementWithObject:aPupilNote];
        
        [linkedList addElementAtFirst:anExistingOrNewLinkedListElement];
        [bellBallToLinkedListElementDictionary setObject:anExistingOrNewLinkedListElement forKey:aBellBallForPupilNote];
        
        return YES;
    }
    
    return NO;
}

- (void)accessed:(NUPupilNoteCacheLinkedListElement *)aLinkedListElement
{
    if (!aLinkedListElement) return;
    
    [linkedList moveToFirst:aLinkedListElement];
}

- (void)trimIfOverLimit
{
    while (cachSizeInBytes > maxCacheSizeInBytes)
    {
        NUPupilNoteCacheLinkedListElement *anOldTail = [(NUPupilNoteCacheLinkedListElement *)[linkedList last] retain];
        
        [linkedList removeLast];
        
        cachSizeInBytes -= [[anOldTail pupilNote] sizeForSerialization];
        
        [[anOldTail referencingGrades] enumerateIndexesUsingBlock:^(NSUInteger aGrade, BOOL * _Nonnull stop) {
            [gradeAndOOPToLinkedListElementLibrary removeObjectForKey:[NUPupilNoteCacheKey keyWithGrade:aGrade oop:[[anOldTail pupilNote] OOP]]];
        }];
        
        [bellBallToLinkedListElementDictionary removeObjectForKey:[[anOldTail pupilNote] bellBall]];
        
        [anOldTail release];
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
    
    return (NSComparisonResult)NUBellBallCompareWithGradeOOP((NUUInt8 *)&_bellBall, (NUUInt8 *)&anOtherBellBall);
}

@end

@implementation NUPupilNoteCacheLinkedListElement

- (instancetype)initWithObject:(id)anObject
{
    if (self = [super initWithObject:anObject])
    {
        _referencingGrades = [NSMutableIndexSet new];
    }
    
    return self;
}

- (void)dealloc
{
    [_referencingGrades release];
    
    [super dealloc];
}

- (NUPupilNote *)pupilNote
{
    return [self object];
}

- (void)addReferencingGrade:(NUUInt64)aGrade
{
    [[self referencingGrades] addIndex:(NSUInteger)aGrade];
}

@end
