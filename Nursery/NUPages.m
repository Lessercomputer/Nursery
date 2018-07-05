//
//  NUPages.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/09.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#include <stdlib.h>
#import <Foundation/NSByteOrder.h>
#import <Foundation/NSLock.h>
#import <Foundation/NSFileHandle.h>
#import <Foundation/NSData.h>

#import "NUPages.h"
#import "NUPage.h"
#import "NURegion.h"
#import "NUChangedRegionArray.h"
#import "NUU64ODictionary.h"
#import "NUPageLocationODictionary.h"
#import "NULinkedList.h"
#import "NULinkedListElement.h"

NSString *NUPageDataDoesNotExistException = @"NUPageDataDoesNotExistException";
NSString *NUInvalidPageLocationException = @"NUInvalidPageLocationException";
const NUUInt32 NUDefaultPageSize = 4096;
const NUUInt64 NUDefaultMaximumUnchangedPageBufferCount = 20000;
const NUUInt64 NUNextPageLocationOffset = 5;
const NUUInt64 NULogDataLocationOffset = 77;
const NUUInt64 NULogDataLengthOffset = 85;

@implementation NUPages

+ (id)pages
{
	return [[[self alloc] init] autorelease];
}

- (id)init
{
	if (self = [super init])
    {
        lock = [NSRecursiveLock new];
        pageSize = NUDefaultPageSize;
        pageBuffer = [[NUPageLocationODictionary alloc] initWithPages:self];
        pageLinkedList = [NULinkedList new];
        maximumUnchangedPageBufferCount = NUDefaultMaximumUnchangedPageBufferCount;
        changedRegions = [[NUChangedRegionArray alloc] initWithCapacity:pageSize];
    }
    
	return self;
}

- (void)dealloc
{
	[self setFileHandle:nil];
	[pageBuffer release];
    [pageLinkedList release];
	[changedRegions release];
    [lock release];
	
	[super dealloc];
}

- (NUUInt32)pageSize
{
	return pageSize;
}

- (NUUInt64)nextPageLocation
{
	return nextPageLocation;
}

- (void)setNextPageLocation:(NUUInt64)aPageLocation
{
	nextPageLocation = aPageLocation;
    if (!savedNextPageLocation) [self setSavedNextPageLocation:nextPageLocation];
}

- (NUUInt64)savedNextPageLocation
{
	return savedNextPageLocation;
}

- (void)setSavedNextPageLocation:(NUUInt64)aPageLocation
{
	savedNextPageLocation = aPageLocation;
	nextPageLocation = aPageLocation;
}

- (NSFileHandle *)fileHandle
{
	return fileHandle;
}

- (void)setFileHandle:(NSFileHandle *)aFileHandle
{
	[fileHandle release];
	fileHandle = [aFileHandle retain];
}

- (NUUInt64)fileSize
{
	return fileSize;
}

- (void)setFileSize:(NUUInt64)aFileSize
{
	fileSize = aFileSize;
}

- (NUUInt64)appendPagesBy:(NUUInt64)aPageCountToExtend
{
	NUUInt64 aNewPageLocation = nextPageLocation;
	nextPageLocation += [self pageSize] * aPageCountToExtend;
	return aNewPageLocation;
}

- (NUUInt8)readUInt8At:(NUUInt64)anOffset
{
	NUUInt8 aValue;
	[self read:&aValue length:sizeof(NUUInt8) at:anOffset];
	return aValue;
}

- (BOOL)readBOOLAt:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
    return [self readBOOLAt:aSpace + anOffset];
}

- (BOOL)readBOOLAt:(NUUInt64)anOffset
{
    NUUInt8 aValue;
    [self read:&aValue length:sizeof(NUUInt8) at:anOffset];
    return aValue;
}

- (NUUInt8)readUInt8At:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
	NUUInt8 aValue;
	[self read:&aValue length:sizeof(NUUInt8) at:anOffset of:aSpace];
	return aValue;
}

- (NUUInt16)readUInt16At:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
    return [self readUInt16At:aSpace + anOffset];
}

- (NUUInt16)readUInt16At:(NUUInt64)anOffset
{
    NUUInt16 aValue;
    [self read:(NUUInt8 *)&aValue length:sizeof(NUUInt16) at:anOffset];
    return NSSwapBigShortToHost(aValue);
}

- (NUUInt32)readUInt32At:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
    return [self readUInt32At:aSpace + anOffset];
}

- (NUUInt32)readUInt32At:(NUUInt64)anOffset
{
    NUUInt32 aValue;
    [self read:(NUUInt8 *)&aValue length:sizeof(NUUInt32) at:anOffset];
    return NSSwapBigIntToHost(aValue);
}

- (NUUInt64)readUInt64At:(NUUInt64)anOffset
{
	return [self readUInt64At:anOffset of:0];
}

- (NUUInt64)readUInt64At:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
	NUUInt64 aValue;
	[self read:(NUUInt8 *)&aValue length:sizeof(NUUInt64) at:anOffset of:aSpace];
	return NSSwapBigLongLongToHost(aValue);
}

- (void)readUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
	[self readUInt64Array:aValues ofCount:aCount at:aSpace + anOffset];
}

- (void)readUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset
{
	[self read:(NUUInt8 *)aValues length:sizeof(NUUInt64) * aCount at:anOffset];
	for (NUUInt64 i = 0; i < aCount; i++) aValues[i] = NSSwapBigLongLongToHost(aValues[i]);
}

- (NUFloat)readFloatAt:(NUUInt64)anOffset
{
    NSSwappedFloat aValue;
    [self read:(NUUInt8 *)&aValue length:sizeof(NUFloat) at:anOffset];
    return NSSwapBigFloatToHost(aValue);
}

- (NUDouble)readDoubleAt:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
	return [self readDoubleAt:aSpace + anOffset];
}

- (NUDouble)readDoubleAt:(NUUInt64)anOffset
{
	NSSwappedDouble aValue;
	[self read:(NUUInt8 *)&aValue length:sizeof(NUDouble) at:anOffset];
	return NSSwapBigDoubleToHost(aValue);
}

- (void)readDoubleArray:(NUDouble *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset
{
    [self read:(NUUInt8 *)aValues length:sizeof(NUDouble) * aCount at:anOffset];
    
    for (NUUInt64 i = 0; i < aCount; i++)
    {
        NSSwappedDouble aValue = ((NSSwappedDouble *)aValues)[i];
        aValues[i] = NSSwapBigDoubleToHost(aValue);
    }
}

- (NURegion)readRegionAt:(NUUInt64)anOffset
{
    NUUInt64 aValue[2];
    [self readUInt64Array:aValue ofCount:2 at:anOffset];
    return NUMakeRegion(aValue[0], aValue[1]);
}

- (NSRange)readRangeAt:(NUUInt64)anOffset
{
    NUUInt64 aValue[2];
    [self readUInt64Array:aValue ofCount:2 at:anOffset];
    return NSMakeRange((NSUInteger)aValue[0], (NSUInteger)aValue[1]);
}

- (NUPoint)readPointAt:(NUUInt64)anOffset
{
    NUDouble aValue[2];
    [self readDoubleArray:aValue ofCount:2 at:anOffset];
    NUPoint aPoint;
    aPoint.x = aValue[0];
    aPoint.y = aValue[1];
    return aPoint;
}

- (NUSize)readSizeAt:(NUUInt64)anOffset
{
    NUDouble aValue[2];
    [self readDoubleArray:aValue ofCount:2 at:anOffset];
    NUSize aSize;
    aSize.width = aValue[0];
    aSize.height = aValue[1];
    return aSize;
}

- (NURect)readRectAt:(NUUInt64)anOffset
{
    NUDouble aValue[4];
    [self readDoubleArray:aValue ofCount:4 at:anOffset];
    NURect aRect;
    aRect.origin.x = aValue[0];
    aRect.origin.y = aValue[1];
    aRect.size.width = aValue[2];
    aRect.size.height = aValue[3];
    
    return aRect;
}

- (void)writeUInt8:(NUUInt8)aValue at:(NUUInt64)anOffset
{
	[self write:&aValue length:sizeof(NUUInt8) at:anOffset];
}

- (void)writeBOOL:(BOOL)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
    [self writeBOOL:aValue at:aSpace + anOffset];
}

- (void)writeBOOL:(BOOL)aValue at:(NUUInt64)anOffset
{
    NUUInt8 aBOOLValue = aValue;
    [self write:&aBOOLValue length:sizeof(NUUInt8) at:anOffset];
}

- (void)writeUInt16:(NUUInt16)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
    [self writeUInt16:aValue at:aSpace + anOffset];
}

- (void)writeUInt16:(NUUInt16)aValue at:(NUUInt64)anOffset
{
    aValue = NSSwapHostShortToBig(aValue);
    [self write:(const NUUInt8 *)&aValue length:sizeof(NUUInt16) at:anOffset];
}

- (void)writeUInt32:(NUUInt32)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
    [self writeUInt32:aValue at:aSpace + anOffset];
}

- (void)writeUInt32:(NUUInt32)aValue at:(NUUInt64)anOffset
{
    aValue = NSSwapHostIntToBig(aValue);
    [self write:(const NUUInt8 *)&aValue length:sizeof(NUUInt32) at:anOffset];
}

- (void)writeUInt64:(NUUInt64)aValue at:(NUUInt64)anOffset
{
	[self writeUInt64:aValue at:anOffset of:0];
}

- (void)writeUInt64:(NUUInt64)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
	aValue = NSSwapHostLongLongToBig(aValue);
	[self write:(const NUUInt8 *)&aValue length:sizeof(NUUInt64) at:anOffset of:aSpace];
}

- (void)writeUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
	[self writeUInt64Array:aValues ofCount:aCount at:aSpace + anOffset];
}

- (void)writeUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset
{
	NUUInt64 *aValuesToWrite = malloc((size_t)(sizeof(NUUInt64) * aCount));
	NUUInt64 i = 0;
	
	for (; i < aCount ; i++)
		aValuesToWrite[i] = NSSwapHostLongLongToBig(aValues[i]);
	
	[self write:(const NUUInt8 *)aValuesToWrite length:sizeof(NUUInt64) * aCount at:anOffset];
	free(aValuesToWrite);
}

- (void)writeFloat:(NUFloat)aValue at:(NUUInt64)anOffset
{
    NSSwappedFloat aSwappedValue = NSSwapHostFloatToBig(aValue);
    [self write:(const NUUInt8 *)&aSwappedValue length:sizeof(NUFloat) at:anOffset];
}

- (void)writeDouble:(NUDouble)aValue at:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
	[self writeDouble:aValue at:aSpace + anOffset];
}

- (void)writeDouble:(NUDouble)aValue at:(NUUInt64)anOffset
{
	NSSwappedDouble aSwappedValue = NSSwapHostDoubleToBig(aValue);
	[self write:(const NUUInt8 *)&aSwappedValue length:sizeof(NUDouble) at:anOffset];
}

- (void)writeDoubleArray:(NUDouble *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset
{
    NSSwappedDouble *aValuesToWrite = malloc((size_t)(sizeof(NSSwappedDouble) * aCount));
    
    for (NUUInt64 i = 0; i < aCount; i++)
        aValuesToWrite[i] = NSSwapHostDoubleToBig(aValues[i]);
    
    [self write:(const NUUInt8 *)aValuesToWrite length:sizeof(NUDouble) * aCount at:anOffset];
    free(aValuesToWrite);
}

- (void)writeRegion:(NURegion)aValue at:(NUUInt64)anOffset
{
    NUUInt64 aLocationAndLength[2];
    aLocationAndLength[0] = aValue.location;
    aLocationAndLength[1] = aValue.length;
    [self writeUInt64Array:aLocationAndLength ofCount:2 at:anOffset];
}

- (void)writeRange:(NSRange)aValue at:(NUUInt64)anOffset
{
    NUUInt64 aLocationAndLength[2];
    aLocationAndLength[0] = aValue.location;
    aLocationAndLength[1] = aValue.length;
    [self writeUInt64Array:aLocationAndLength ofCount:2 at:anOffset];
}

- (void)writePoint:(NUPoint)aValue at:(NUUInt64)anOffset
{
    NUDouble anXandY[2];
    anXandY[0] = aValue.x;
    anXandY[1] = aValue.y;
    [self writeDoubleArray:anXandY ofCount:2 at:anOffset];
}

- (void)writeSize:(NUSize)aValue at:(NUUInt64)anOffset
{
    NUDouble anWidthAndHeight[2];
    anWidthAndHeight[0] = aValue.width;
    anWidthAndHeight[1] = aValue.height;
    [self writeDoubleArray:anWidthAndHeight ofCount:2 at:anOffset];
}

- (void)writeRect:(NURect)aValue at:(NUUInt64)anOffset
{
    NUDouble anXAndYAndWidthAndHeight[4];
    anXAndYAndWidthAndHeight[0] = aValue.origin.x;
    anXAndYAndWidthAndHeight[1] = aValue.origin.y;
    anXAndYAndWidthAndHeight[2] = aValue.size.width;
    anXAndYAndWidthAndHeight[3] = aValue.size.height;
    [self writeDoubleArray:anXAndYAndWidthAndHeight ofCount:4 at:anOffset];
}

- (void)writeData:(NSData *)aData at:(NUUInt64)anOffset
{
    [self write:(const NUUInt8 *)[aData bytes] length:[aData length] at:anOffset];
}

- (void)moveBytesAt:(NUUInt64)aSourceLocation length:(NUUInt64)aLength to:(NUUInt64)aDestinationLocation buffer:(NUUInt8 *)aBuffer length:(NUUInt64)aBufferLength
{
    if (aSourceLocation < aDestinationLocation)
        [[NSException exceptionWithName:NUInvalidPageLocationException reason:NUInvalidPageLocationException userInfo:nil] raise];
    
    [lock lock];
    
    NUUInt64 aLocationToRead = aSourceLocation;
    NUUInt64 aLocationToWrite = aDestinationLocation;
    NUUInt64 aRemainingLength = aLength;
    NUUInt64 aLengthToReadOrWrite;
        
    while (aRemainingLength)
    {
        if (aRemainingLength > aBufferLength)
            aLengthToReadOrWrite = aBufferLength;
        else
            aLengthToReadOrWrite = aRemainingLength;
        
        [self read:aBuffer length:aLengthToReadOrWrite at:aLocationToRead];
        [self write:aBuffer length:aLengthToReadOrWrite at:aLocationToWrite];
        
        aLocationToRead += aLengthToReadOrWrite;
        aLocationToWrite += aLengthToReadOrWrite;
        aRemainingLength -= aLengthToReadOrWrite;
    }
    
    [lock unlock];
}

- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
	[self write:aBytes length:aLength at:aSpace + anOffset];
}

- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset
{
	NUUInt64 aWritingOffset = anOffset;
	NUUInt64 aRemainingLength = aLength;
	NUUInt64 aLocationToRead = 0;
	   
    [lock lock];
    
	[changedRegions addRegion:NUMakeRegion(aWritingOffset, aLength)];
	
	while (aRemainingLength)
	{
		NUUInt64 aWritingOffsetInPage = aWritingOffset % [self pageSize];
		NUUInt64 aPageStartingLocation = aWritingOffset - aWritingOffsetInPage;
		NUUInt64 aWritingLength = [self pageSize] - aWritingOffsetInPage;
		if (aRemainingLength < aWritingLength) aWritingLength = aRemainingLength;
		
		[self write:&aBytes[aLocationToRead] length:aWritingLength toPageStartingAt:aPageStartingLocation offset:aWritingOffsetInPage];
		
		aWritingOffset += aWritingLength;
		aLocationToRead += aWritingLength;
		aRemainingLength -= aWritingLength;
	}
    
    [lock unlock];
}

- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset of:(NUUInt64)aSpace
{
	[self read:aBytes length:aLength at:aSpace + anOffset];
}

- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset
{
	NUUInt64 aReadingOffset = anOffset;
	NUUInt64 aRemainingLength = aLength;
	NUUInt64 aLocationToWrite = 0;
	
    [lock lock];
    
	while (aRemainingLength)
	{
		NUUInt64 aReadingOffsetInPage = aReadingOffset % [self pageSize];
		NUUInt64 aPageStartingLocation = aReadingOffset - aReadingOffsetInPage;
		NUUInt64 aReadingLength = [self pageSize] - aReadingOffsetInPage;
		if (aRemainingLength < aReadingLength) aReadingLength = aRemainingLength;
		
//		[self read:&aBytes[aLocationToWrite] length:aLength fromPageStartingAt:aPageStartingLocation offset:aReadingOffsetInPage];
        [self read:&aBytes[aLocationToWrite] length:aReadingLength fromPageStartingAt:aPageStartingLocation offset:aReadingOffsetInPage];
		
		aReadingOffset += aReadingLength;
		aLocationToWrite += aReadingLength;
		aRemainingLength -= aReadingLength;
	}
    
    [lock unlock];
}

- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aWritingLength toPageStartingAt:(NUUInt64)aPageStartingLocation offset:(NUUInt64)aWritingOffsetInPage
{
    BOOL aPageIsChangedBeforeWrite = NO;
    NUPage *aPage = nil;
    
    [lock lock];
    aPage = [self pageAt:aPageStartingLocation];
    aPageIsChangedBeforeWrite = [aPage isChanged];
	[aPage write:aBytes length:aWritingLength offset:aWritingOffsetInPage];
    if (!aPageIsChangedBeforeWrite) unchangedPageBufferCount--;
    [lock unlock];
}

- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aReadingLength fromPageStartingAt:(NUUInt64)aPageStartingLocation offset:(NUUInt64)aReadingOffsetInPage
{
    [lock lock];
	[[self pageAt:aPageStartingLocation] read:aBytes length:aReadingLength offset:aReadingOffsetInPage];
    [lock unlock];
}

- (NUUInt64)pageStatingLocationFor:(NUUInt64)aLocation
{
    @try {
        [lock lock];
        return [self pageSize] * (aLocation / [self pageSize]);
    }
    @finally {
        [lock unlock];
    }
}

- (NUUInt64)nextPageLocationFor:(NUUInt64)aLocation
{
    @try {
        [lock lock];
        return [self pageStatingLocationFor:aLocation] + [self pageSize];
    }
    @finally {
        [lock unlock];
    }
}

- (BOOL)pageIsCreatedFor:(NUUInt64)aPageLocation
{
	return aPageLocation < [self savedNextPageLocation];
}

- (NUPage *)pageAt:(NUUInt64)aPageStartingLocation
{
    if (aPageStartingLocation % [self pageSize] != 0)
        [[NSException exceptionWithName:NUInvalidPageLocationException reason:NUInvalidPageLocationException userInfo:nil] raise];
    
    [lock lock];
    
    NULinkedListElement *aListElementWithPage = [pageBuffer objectForKey:aPageStartingLocation];
    NUPage *aPage = nil;
	
    if (aListElementWithPage)
    {
        aPage = [aListElementWithPage object];
        
        [pageLinkedList moveToFirst:aListElementWithPage];
    }
    else
        aPage = [self loadPageAt:aPageStartingLocation];
    
    [lock unlock];
    
	return aPage;
}

- (NUPage *)loadPageAt:(NUUInt64)aPageStartingLocation
{
	NSMutableData *aPageData = [[[self loadPageDataAt:aPageStartingLocation] mutableCopy] autorelease];
	NUPage *aPage = [NUPage pageWithLocation:aPageStartingLocation data:aPageData];
    NULinkedListElement *aListElementWithPage = [NULinkedListElement listElementWithObject:aPage];
	
    [pageBuffer setObject:aListElementWithPage forKey:aPageStartingLocation];
    [pageLinkedList addElementToFirst:aListElementWithPage];
    unchangedPageBufferCount++;
    [self removeUnchangedPagesFromBufferIfNeeded];
    
	return aPage;
}

- (NSData *)pageDataAt:(NUUInt64)aPageLocation
{
	return [[self pageAt:aPageLocation] data];
}

- (NSData *)loadPageDataAt:(NUUInt64)aPageLocation
{
	if (aPageLocation >= nextPageLocation)
        [[NSException exceptionWithName:NUPageDataDoesNotExistException reason:NUPageDataDoesNotExistException userInfo:nil] raise];
	
	NSData *aPageData;
	
	if (aPageLocation >= savedNextPageLocation)
	{
		aPageData = [NSMutableData dataWithLength:[self pageSize]];
	}
	else
	{
		[[self fileHandle] seekToFileOffset:aPageLocation];
		aPageData = [[self fileHandle] readDataOfLength:[self pageSize]];
		if ([aPageData length] != [self pageSize])
            [[NSException exceptionWithName:NUPageDataDoesNotExistException reason:nil userInfo:nil] raise];
	}
	
	return aPageData;
}

- (void)save
{
    if (![changedRegions count]) return;
    
    [self writeLogData];
    [self flush];
}

- (void)flush
{
    NURegion aRegion;
    NUUInt32 aRegionIndex;
    [self getFirstChangedRegionWithoutFirstPageRegionInto:&aRegion indexInto:&aRegionIndex];
    
    if (aRegionIndex == NUNotFound32) return;
    
    [self writeDataWithRegion:aRegion];

    for (NUUInt32 i = aRegionIndex + 1; i < [changedRegions count]; i++)
    {
        aRegion = [changedRegions regionAt:i];
        [self writeDataWithRegion:aRegion];
    }
    
    [[self fileHandle] synchronizeFile];
    
    [self writeUInt64:0 at:NULogDataLengthOffset];
    [self writeDataWithRegion:[self firstPageRegion]];
    [[self fileHandle] synchronizeFile];
    
    [[self fileHandle] truncateFileAtOffset:nextPageLocation];
    
    fileSize = nextPageLocation;
    savedNextPageLocation = nextPageLocation;
    
    [self setChangeStatusOfAllPagesToUnchanged];
    
    [changedRegions removeAll];
}

//- (void)flushFileHeader
//{
//    
//}

- (void)writeLogData
{    
    NUUInt64 aLogDataLength = [self writeLogDataBody];
    [self writeLogDataHeader:aLogDataLength];
}

- (NUUInt64)writeLogDataBody
{
    NUUInt64 aLocation = [self nextPageLocation];
    NUUInt64 aLogDataLength = [self computeLogDataLength];
    
    [[self fileHandle] truncateFileAtOffset:aLocation + aLogDataLength];
    
    for (NUUInt32 i = 0; i < [changedRegions count]; i++)
    {
        NURegion aRegion = [changedRegions regionAt:i];
        [self writeLogDataWithRegion:aRegion at:aLocation];
        aLocation += sizeof(NURegion);
        aLocation += aRegion.length;
    }
    
    [[self fileHandle] synchronizeFile];
    
    return aLogDataLength;
}

- (void)writeLogDataHeader:(NUUInt64)aLogDataLength
{
    [self writeUInt64:[self nextPageLocation] at:NULogDataLocationOffset];
    [self writeUInt64:aLogDataLength at:NULogDataLengthOffset];
    [self writeDataWithRegion:NUMakeRegion(NULogDataLocationOffset, sizeof(NUUInt64) * 2)];
    [[self fileHandle] synchronizeFile];
}

- (BOOL)applyLogIfNeeded
{
    NUUInt64 aLogDataLength = [self readUInt64At:NULogDataLengthOffset];
    if (aLogDataLength == 0) return YES;
    
    NSData *aLogData = [self loadLogData];
    [self applyLogDataBody:aLogData];
    [self applyLogDataHeader:aLogData];
    
    return YES;
}

- (void)applyLogDataBody:(NSData *)aData 
{
    NUUInt64 i = 0;
    NURegion aFirstPageRegion = [self firstPageRegion];
    NURegion anAllRegionButFirstPage = [self allRegionButFirstPage];
    
    while (i < [aData length])
    {
        NURegion aRegion = [self getRegionFrom:aData at:i];
                
        if (NUIntersectsRegion(aRegion, anAllRegionButFirstPage))
        {
            if (NULocationInRegion(aRegion.location, aFirstPageRegion))
            {
                NUUInt64 adjustedValue = [self pageSize] - aRegion.location;
                aRegion.location += adjustedValue;
                aRegion.length -= adjustedValue;
                i += adjustedValue;
            }
            
            i += sizeof(NURegion);
            [[self fileHandle] seekToFileOffset:aRegion.location];
            [[self fileHandle] writeData:[aData subdataWithRange:NSMakeRange((NSUInteger)i, (NSUInteger)aRegion.length)]];
            i += aRegion.length;
        }
        else
        {
            i += sizeof(NURegion);
            i += aRegion.length;
        }
    }
    
    [[self fileHandle] synchronizeFile];
}

- (void)applyLogDataHeader:(NSData *)aData
{
    NUUInt64 i = 0;
    NURegion aFirstPageRegion = [self firstPageRegion];

    while (i < [aData length])
    {
        NURegion aRegion = [self getRegionFrom:aData at:i];
        
        if (NULocationInRegion(aRegion.location, aFirstPageRegion))
        {
            NUUInt64 aWriteLength = aRegion.length;
            NUUInt64 availableLength = [self pageSize] - aRegion.location;

            if (aRegion.length > availableLength)
                aWriteLength = availableLength;
            
            i += sizeof(NURegion);
            [self writeData:[aData subdataWithRange:NSMakeRange((NSUInteger)i, (NSUInteger)aWriteLength)] at:aRegion.location];
            i += aRegion.length;
        }
        else
            break;
    }
    
    [self writeUInt64:0 at:NULogDataLocationOffset];
    [self writeUInt64:0 at:NULogDataLengthOffset];
    [self writeDataWithRegion:[self firstPageRegion]];
    [[self fileHandle] synchronizeFile];

    [self setChangeStatusOfAllPagesToUnchanged];
    
    [changedRegions removeAll];
}

- (NURegion)getRegionFrom:(NSData *)aData at:(NUUInt64)anIndex
{
    NURegion aRegion;
    [aData getBytes:&aRegion.location range:NSMakeRange((NSUInteger)anIndex, sizeof(NUUInt64))];
    [aData getBytes:&aRegion.length range:NSMakeRange((NSUInteger)(anIndex + sizeof(NUUInt64)), sizeof(NUUInt64))];
    aRegion = NUSwapBigRegionToHost(aRegion);
    return aRegion;
}

- (NSData *)loadLogData
{
    NUUInt64 aLogDataLocation = [self readUInt64At:NULogDataLocationOffset];
    NUUInt64 aLogDataLength = [self readUInt64At:NULogDataLengthOffset];
    [[self fileHandle] seekToFileOffset:aLogDataLocation];
    return [[self fileHandle] readDataOfLength:(NSUInteger)aLogDataLength];
}

- (void)getFirstChangedRegionWithoutFirstPageRegionInto:(NURegion *)aRegion indexInto:(NUUInt32 *)anIndex
{
    NURegion aRegionWithoutFirstPageRegion = NUMakeRegion(NUNotFound64, 0);
    NUUInt32 aRegionIndexWithoutFirstPageRegion = NUNotFound32;
    NURegion aFirstPageRegion = [self firstPageRegion];
//    NURegion anAllRegionButFirstPageRegion;
//    NURegionSplitWithLength(NUMakeRegion(0, NUUInt64Max), [self pageSize], &anAllRegionButFirstPageRegion);
    NURegion anAllRegionButFirstPageRegion = [self allRegionButFirstPage];
    
    for (NUUInt32 i = 0; i < [changedRegions count]; i++)
    {
        NURegion aChangedRegion = [changedRegions regionAt:i];
        
        if (!NUIntersectsRegion(aChangedRegion, anAllRegionButFirstPageRegion)) continue;
        
        if (NUIntersectsRegion(aFirstPageRegion, aChangedRegion))
            NURegionSplitWithLength(aChangedRegion, [self pageSize] - aChangedRegion.location, &aRegionWithoutFirstPageRegion);
        else
            aRegionWithoutFirstPageRegion = aChangedRegion;
        
        aRegionIndexWithoutFirstPageRegion = i;
        
        break;
    }
    
    if (aRegion)
        *aRegion = aRegionWithoutFirstPageRegion;
    if (anIndex)
        *anIndex = aRegionIndexWithoutFirstPageRegion;
}

- (NUUInt64)computeLogDataLength
{
    NUUInt64 aLogDataLength = 0;    
    
    for (NUUInt32 i = 0; i < [changedRegions count]; i++)
    {
        NURegion aRegion = [changedRegions regionAt:i];
        aLogDataLength += sizeof(NURegion);
        aLogDataLength += aRegion.length;
    }
    
    return aLogDataLength;
}

- (void)writeLogDataWithRegion:(NURegion)aRegion at:(NUUInt64)aLocation
{
    [[self fileHandle] seekToFileOffset:aLocation];
    
    NSMutableData *aRegionData = [NSMutableData dataWithCapacity:sizeof(NURegion)];
    NURegion aBigRegion = NUSwapHostRegionToBig(aRegion);
    [aRegionData appendBytes:(const void *)&aBigRegion.location length:sizeof(NUUInt64)];
    [aRegionData appendBytes:(const void *)&aBigRegion.length length:sizeof(NUUInt64)];
    [[self fileHandle] writeData:aRegionData];
    
    [[self fileHandle] writeData:[self dataWithRegion:aRegion]];
}

- (void)writeDataWithRegion:(NURegion)aRegion
{
    NURegion aRemainingRegion = aRegion;
    
    while (aRemainingRegion.length > 0)
    {
        NUUInt64 aPageLocation = aRemainingRegion.location / [self pageSize] * [self pageSize];
        NURegion aWriteRegionInPage = NUMakeRegion(aRemainingRegion.location % [self pageSize], aRemainingRegion.length);
        
        if (aWriteRegionInPage.length > [self pageSize] - aWriteRegionInPage.location)
            aWriteRegionInPage.length = [self pageSize] - aWriteRegionInPage.location;
        
        [[self pageAt:aPageLocation] writeDataWithRegion:aWriteRegionInPage toFielHandle:[self fileHandle]];
        
        aRemainingRegion.location += aWriteRegionInPage.length;
        aRemainingRegion.length -= aWriteRegionInPage.length;
    }
}

- (NSData *)dataWithRegion:(NURegion)aRegion
{
    NSMutableData *aData = [NSMutableData dataWithCapacity:(NSUInteger)aRegion.length];
    
    [self addDataWithRegion:aRegion toData:aData];
    
    return aData;
}

- (void)addDataWithRegion:(NURegion)aRegion toData:(NSMutableData *)aData
{
    NURegion aRemainingRegion = aRegion;
    
    while (aRemainingRegion.length > 0)
    {
        NUUInt64 aPageLocation = aRemainingRegion.location / [self pageSize] * [self pageSize];
        NURegion aReadRegionInPage = NUMakeRegion(aRemainingRegion.location % [self pageSize], aRemainingRegion.length);
        
        if (aReadRegionInPage.length > [self pageSize] - aReadRegionInPage.location)
            aReadRegionInPage.length = [self pageSize] - aReadRegionInPage.location;
        
        [[self pageAt:aPageLocation] appendDataWithRegion:aReadRegionInPage toData:aData];
        
        aRemainingRegion.location += aReadRegionInPage.length;
        aRemainingRegion.length -= aReadRegionInPage.length;
    }
}

- (NURegion)firstPageRegion
{
    return NUMakeRegion(0, [self pageSize]);
}

- (NURegion)allRegionButFirstPage
{
    return NUMakeRegion([self pageSize], NUUInt64Max - [self pageSize]);
}

- (void)setChangeStatusOfAllPagesToUnchanged
{
    [pageBuffer enumerateKeysAndObjectsUsingBlock:^(NUUInt64 aKey, NULinkedListElement *aListElementWithPage, BOOL *stop) {
        NUPage *aPage = [aListElementWithPage object];
        
        if ([aPage isChanged])
        {
            [aPage setIsChanged:NO];
            unchangedPageBufferCount++;
        }
        
        [self removeUnchangedPagesFromBufferIfNeeded];
    }];
}

- (void)removeUnchangedPagesFromBufferIfNeeded
{
    NULinkedListElement *aListElementWithPage = [pageLinkedList last];
    
    while (unchangedPageBufferCount > maximumUnchangedPageBufferCount)
    {
        NUPage *aPage = [aListElementWithPage object];
        
        if (![aPage isChanged])
        {
            [aListElementWithPage retain];
            [pageLinkedList remove:aListElementWithPage];
            [pageBuffer removeObjectForKey:[aPage location]];
            unchangedPageBufferCount--;
        }
        
        aListElementWithPage = [aListElementWithPage previous];
        
        if (![aPage isChanged]) [aListElementWithPage release];
    }
}

@end
