//
//  NUPupilNoteCache.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import <Foundation/NSObject.h>

#import "NUTypes.h"
#import "NULinkedListElement.h"

@class NSLock, NSMutableIndexSet;
@class NUBell, NUPupilNote, NUBellBallODictionary, NULibrary, NUPupilNoteCacheLinkedListElement, NULinkedList;

@interface NUPupilNoteCache : NSObject
{
    NUBellBallODictionary *bellBallToLinkedListElementDictionary;
    NULibrary *gradeAndOOPToLinkedListElementLibrary;
    NULinkedList *linkedList;
    NUUInt64 cachSizeInBytes;
    NUUInt64 maxCacheSizeInBytes;
    NUUInt64 cacheablePupilNoteMaxSizeInBytes;
    NSLock *lock;
}

+ (instancetype)pupilNoteCacheWithMaxCacheSizeInBytes:(NUUInt64)aMaxCacheSizeInBytes cacheablePupilNoteMaxSizeInBytes:(NUUInt64)aCacheablePupilNoteMaxSizeInBytes;

- (instancetype)initWithMaxCacheSizeInBytes:(NUUInt64)aMaxCacheSizeInBytes cacheablePupilNoteMaxSizeInBytes:(NUUInt64)aCacheablePupilNoteMaxSizeInBytes;

- (NUUInt64)maxCacheSizeInBytes;
- (NUUInt64)cacheablePupilNoteMaxSizeInBytes;

- (NUPupilNote *)pupilNoteForOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade;
- (NUPupilNote *)pupilNoteForOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade containsFellowPupils:(BOOL)aContainsFellowPupils maxFellowPupilNotesSizeInBytes:(NUUInt64)aMaxFellowPupilNotesSizeInBytes pupilNotesInto:(NSArray **)aPupilNotes;

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

@interface NUPupilNoteCacheLinkedListElement : NULinkedListElement

- (NUPupilNote *)pupilNote;

@property (nonatomic, retain) NSMutableIndexSet *referencingGrades;

- (void)addReferencingGrade:(NUUInt64)aGrade;

@end
