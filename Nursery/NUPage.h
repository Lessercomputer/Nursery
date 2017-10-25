//
//  NUPage.h
//  Nursery
//
//  Created by P,T,A on 10/09/29.
//  Copyright 2010 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>


@interface NUPage : NSObject
{
	NUUInt64 location;
	NSMutableData *data;
	BOOL isChanged;
	BOOL isRead;
}

+ (id)pageWithLocation:(NUUInt64)aStartingLocation data:(NSMutableData *)aData;

- (id)initWithLocation:(NUUInt64)aStartingLocation data:(NSMutableData *)aData;

- (NUUInt64)location;
- (NSMutableData *)data;

- (BOOL)isChanged;
- (BOOL)isRead;

- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aWritingLength offset:(NUUInt64)aWritingOffsetInPage;
- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aReadingLength offset:(NUUInt64)aReadingOffsetInPage;

- (void)appendDataWithRegion:(NURegion)aRegion toData:(NSMutableData *)aData;
- (void)writeDataWithRegion:(NURegion)aRegion toFielHandle:(NSFileHandle *)aFileHandle;

- (void)setIsChanged:(BOOL)aChangedFlag;
- (void)setIsRead:(BOOL)aReadFlag;

- (void)flushTo:(NSFileHandle *)aFileHandle;

@end
