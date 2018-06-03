//
//  NUPages.h
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import "NUTypes.h"
#import "NUCodingNote.h"

@class NSFileHandle, NSMutableData, NSRecursiveLock;
@class NUPage, NUChangedRegionArray, NUPageLocationODictionary, NULinkedList;

extern NSString *NUPageDataDoesNotExistException;
extern NSString *NUInvalidPageLocationException;
extern const NUUInt32 NUDefaultPageSize;
extern const NUUInt64 NUNextPageLocationOffset;

@interface NUPages : NSObject <NUCodingNote>
{
	NUUInt32 pageSize;
	NUUInt32 capacity;
	NUPageLocationODictionary *pageBuffer;
    NULinkedList *pageLinkedList;
    NUUInt64 unchangedPageBufferCount;
    NUUInt64 maximumUnchangedPageBufferCount;
	NUUInt64 nextPageLocation;
	NUUInt64 savedNextPageLocation;
	NUUInt64 fileSize;
	NSFileHandle *fileHandle;
	NUChangedRegionArray *changedRegions;
    NSRecursiveLock *lock;
}

+ (id)pages;

- (NUUInt32)pageSize;
- (NUUInt64)nextPageLocation;
- (void)setNextPageLocation:(NUUInt64)aPageLocation;
- (NUUInt64)savedNextPageLocation;
- (void)setSavedNextPageLocation:(NUUInt64)aPageLocation;

- (NSFileHandle *)fileHandle;
- (void)setFileHandle:(NSFileHandle *)aFileHandle;

- (NUUInt64)fileSize;
- (void)setFileSize:(NUUInt64)aFileSize;

- (NUUInt64)appendPagesBy:(NUUInt64)aPageCountToExtend;

- (NUUInt8)readUInt8At:(NUUInt64)anOffset;
- (BOOL)readBOOLAt:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (NUUInt8)readUInt8At:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (NUUInt16)readUInt16At:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (NUUInt32)readUInt32At:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (NUUInt64)readUInt64At:(NUUInt64)anOffset;
- (NUUInt64)readUInt64At:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)readUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)readUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset;
- (NUFloat)readFloatAt:(NUUInt64)anOffset;
- (NUDouble)readDoubleAt:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (NUDouble)readDoubleAt:(NUUInt64)anOffset;
- (NURegion)readRegionAt:(NUUInt64)anOffset;

- (void)writeUInt8:(NUUInt8)aValue at:(NUUInt64)anOffset;
- (void)writeBOOL:(BOOL)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)writeUInt16:(NUUInt16)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)writeUInt32:(NUUInt32)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)writeUInt64:(NUUInt64)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)writeUInt64:(NUUInt64)aValue at:(NUUInt64)anOffset;
- (void)writeUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)writeUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset;
- (void)writeFloat:(NUFloat)aValue at:(NUUInt64)anOffset;
- (void)writeDouble:(NUDouble)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)writeDouble:(NUDouble)aValue at:(NUUInt64)anOffset;
- (void)writeRegion:(NURegion)aValue at:(NUUInt64)anOffset;
- (void)writeData:(NSData *)aData at:(NUUInt64)anOffset;

- (void)moveBytesAt:(NUUInt64)aSourceLocation length:(NUUInt64)aLength to:(NUUInt64)aDestinationLocation buffer:(NUUInt8 *)aBuffer length:(NUUInt64)aBufferLength;

- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset;
- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset of:(NUUInt64)aSpace;
- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset;

- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aWritingLength toPageStartingAt:(NUUInt64)aPageStartingLocation offset:(NUUInt64)aWritingOffsetInPage;
- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aReadingLength fromPageStartingAt:(NUUInt64)aPageStartingLocation offset:(NUUInt64)aReadingOffsetInPage;

- (NUUInt64)pageStatingLocationFor:(NUUInt64)aLocation;
- (NUUInt64)nextPageLocationFor:(NUUInt64)aLocation;
- (BOOL)pageIsCreatedFor:(NUUInt64)aPageLocation;
- (NUPage *)pageAt:(NUUInt64)aPageStartingLocation;
- (NUPage *)loadPageAt:(NUUInt64)aPageStartingLocation;
- (NSData *)pageDataAt:(NUUInt64)aPageLocation;
- (NSData *)loadPageDataAt:(NUUInt64)aPageLocation;

- (void)save;
- (void)flush;
- (void)writeLogData;
- (NUUInt64)writeLogDataBody;
- (void)writeLogDataHeader:(NUUInt64)aLogDataLength;
- (BOOL)applyLogIfNeeded;
- (void)applyLogDataBody:(NSData *)aData;
- (void)applyLogDataHeader:(NSData *)aData;
- (NSData *)loadLogData;
- (void)getFirstChangedRegionWithoutFirstPageRegionInto:(NURegion *)aRegion indexInto:(NUUInt32 *)anIndex;
- (NUUInt64)computeLogDataLength;
- (void)writeLogDataWithRegion:(NURegion)aRegion at:(NUUInt64)aLocation;
- (void)writeDataWithRegion:(NURegion)aRegion;
- (NSData *)dataWithRegion:(NURegion)aRegion;
- (void)addDataWithRegion:(NURegion)aRegion toData:(NSMutableData *)aData;

- (NURegion)firstPageRegion;
- (NURegion)allRegionButFirstPage;

- (void)setChangeStatusOfAllPagesToUnchanged;
- (void)removeUnchangedPagesFromBufferIfNeeded;

@end
