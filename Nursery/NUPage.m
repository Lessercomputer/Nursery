//
//  NUPage.m
//  Nursery
//
//  Created by Akifumi Takata on 10/09/29.
//

#import <Foundation/NSData.h>
#import <Foundation/NSFileHandle.h>
#import <Foundation/NSByteOrder.h>

#import "NUPage.h"


@implementation NUPage

+ (id)pageWithLocation:(NUUInt64)aStartingLocation data:(NSMutableData *)aData
{
	return [[[self alloc] initWithLocation:aStartingLocation data:aData] autorelease];
}

- (id)initWithLocation:(NUUInt64)aStartingLocation data:(NSMutableData *)aData
{
	if (self = [super init])
    {
        location = aStartingLocation;
        data = [aData retain];
	}
    
	return self;
}

- (void)dealloc
{
	[data release];
	
	[super dealloc];
}

- (NUUInt64)location
{
	return location;
}

- (NSMutableData *)data
{
	return data;
}

- (BOOL)isFirst
{
    return location == 0;
}

- (BOOL)isChanged
{
	return isChanged;
}

- (BOOL)isRead
{
	return isRead;
}

- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aWritingLength offset:(NUUInt64)aWritingOffsetInPage
{
	[data replaceBytesInRange:NSMakeRange((NSUInteger)aWritingOffsetInPage, (NSUInteger)aWritingLength) withBytes:aBytes];
	isChanged = YES;
	[self setIsRead:YES];
}

- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aReadingLength offset:(NUUInt64)aReadingOffsetInPage
{
	[data getBytes:aBytes range:NSMakeRange((NSUInteger)aReadingOffsetInPage, (NSUInteger)aReadingLength)];
	[self setIsRead:YES];
}

- (void)appendDataWithRegion:(NURegion)aRegion toData:(NSMutableData *)aData
{
    const void *bytes = [data bytes];
    [aData appendBytes:&bytes[aRegion.location] length:(NSUInteger)aRegion.length];
    [self setIsRead:YES];
}

- (void)writeDataWithRegion:(NURegion)aRegion toFielHandle:(NSFileHandle *)aFileHandle
{
    NSMutableData *aData = [NSMutableData dataWithCapacity:(NSUInteger)aRegion.length];
    [self appendDataWithRegion:aRegion toData:aData];
    [aFileHandle seekToFileOffset:location + aRegion.location];
    [aFileHandle writeData:aData];
}

- (void)writeToFielHandle:(NSFileHandle *)aFileHandle
{
    [self writeToFielHandle:aFileHandle at:location];
}

- (void)writeToFielHandle:(NSFileHandle *)aFileHandle at:(NUUInt64)aLocation
{
    [aFileHandle seekToFileOffset:aLocation];
    [aFileHandle writeData:data];
}

- (NUUInt64)readUInt64At:(NUUInt64)anOffset
{
	NUUInt64 aValue;
	[self read:(NUUInt8 *)&aValue length:sizeof(NUUInt64) offset:anOffset];
	return NSSwapBigLongLongToHost(aValue);
}

- (void)writeUInt64:(NUUInt64)aValue at:(NUUInt64)anOffset
{
	aValue = NSSwapHostLongLongToBig(aValue);
	[self write:(const NUUInt8 *)&aValue length:sizeof(NUUInt64) offset:anOffset];
}

- (void)setIsChanged:(BOOL)aChangedFlag
{
    isChanged = aChangedFlag;
}

- (void)setIsRead:(BOOL)aReadFlag
{
	isRead = aReadFlag;
}

- (void)flushTo:(NSFileHandle *)aFileHandle
{
	[aFileHandle seekToFileOffset:location];
	[aFileHandle writeData:data];
	isChanged = NO;
}

@end
