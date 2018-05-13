//
//  NUPupilNoteCache.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Foundation/NSObject.h>

#import "NUTypes.h"

@class NSLock, NSMutableIndexSet;
@class NUBell, NUPupilNote, NUBellBallODictionary, NULibrary, NUPupilNoteCacheLinkedListElement;

@interface NUPupilNoteCache : NSObject
{
    NUBellBallODictionary *bellBallToLinkedListElementDictionary;
    NULibrary *gradeAndOOPToLinkedListElementLibrary;
    NUUInt64 cachSizeInBytes;
    NUUInt64 maxCacheSizeInBytes;
    NUUInt64 cacheablePupilNoteMaxSizeInBytes;
    NUPupilNoteCacheLinkedListElement *head;
    NUPupilNoteCacheLinkedListElement *tail;
    NSLock *lock;
}

+ (instancetype)pupilNoteCacheWithMaxCacheSizeInBytes:(NUUInt64)aMaxCacheSizeInBytes cacheablePupilNoteMaxSizeInBytes:(NUUInt64)aCacheablePupilNoteMaxSizeInBytes;

- (instancetype)initWithMaxCacheSizeInBytes:(NUUInt64)aMaxCacheSizeInBytes cacheablePupilNoteMaxSizeInBytes:(NUUInt64)aCacheablePupilNoteMaxSizeInBytes;

- (NUUInt64)maxCacheSizeInBytes;
- (NUUInt64)cacheablePupilNoteMaxSizeInBytes;

- (NUPupilNote *)pupilNoteForOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade;
- (NUPupilNote *)pupilNoteForOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade containsFellowPupils:(BOOL)aContainsFellowPupils maxPupilNotesSizeInBytes:(NUUInt64)aMaxPupilNotesSizeInBytes pupilNotesInto:(NSArray **)aPupilNotes;

- (void)addPupilNote:(NUPupilNote *)aPupilNote grade:(NUUInt64)aGrade;
- (void)addPupilNotes:(NSArray *)aPupilNotes grade:(NUUInt64)aGrade;

- (BOOL)addLinkedListElementForPupilNoteIfNeeded:(NUPupilNote *)aPupilNote;
- (void)accessed:(NUPupilNoteCacheLinkedListElement *)aLinkedListElement;
- (void)trimIfOverLimit;

@end

@interface NUPupilNoteCacheKey : NSObject

+ (instancetype)keyWithGrade:(NUUInt64)aGrade oop:(NUUInt64)anOOP;

- (instancetype)initWithGrade:(NUUInt64)aGrade oop:(NUUInt64)anOOP;

@property (nonatomic) NUBellBall bellBall;

- (NSComparisonResult)compare:(NUPupilNoteCacheKey *)anOtherKey;

@end

@interface NUPupilNoteCacheLinkedListElement : NSObject

+ (instancetype)linkedListElementWithPupilNote:(NUPupilNote *)aPupilNote;

- (instancetype)initWithPupilNote:(NUPupilNote *)aPupilNote;

@property (nonatomic, retain) NUPupilNote *pupilNote;

@property (nonatomic, retain) NSMutableIndexSet *referencingGrades;

@property (nonatomic, assign) NUPupilNoteCacheLinkedListElement *next;

@property (nonatomic, assign) NUPupilNoteCacheLinkedListElement *previous;

- (void)addReferencingGrade:(NUUInt64)aGrade;

@end
