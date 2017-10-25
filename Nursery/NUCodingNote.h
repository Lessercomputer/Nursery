//
//  NUCodingNote.h
//  Nursery
//
//  Created by P,T,A on 2015/08/03.
//  Copyright (c) 2015年 Nursery-Framework. All rights reserved.
//

#import <Nursery/NUTypes.h>

@protocol NUCodingNote

- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset;
- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset;

- (BOOL)readBOOLAt:(NUUInt64)anOffset;
- (NUUInt8)readUInt8At:(NUUInt64)anOffset;
- (NUUInt16)readUInt16At:(NUUInt64)anOffset;
- (NUUInt32)readUInt32At:(NUUInt64)anOffset;
- (NUUInt64)readUInt64At:(NUUInt64)anOffset;
- (void)readUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset;
- (NUFloat)readFloatAt:(NUUInt64)anOffset;
- (NUDouble)readDoubleAt:(NUUInt64)anOffset;
- (void)readDoubleArray:(NUDouble *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset;
- (NURegion)readRegionAt:(NUUInt64)anOffset;
- (NSRange)readRangeAt:(NUUInt64)anOffset;
- (NSPoint)readPointAt:(NUUInt64)anOffset;
- (NSSize)readSizeAt:(NUUInt64)anOffset;
- (NSRect)readRectAt:(NUUInt64)anOffset;

- (void)writeBOOL:(BOOL)aValue at:(NUUInt64)anOffset;
- (void)writeUInt8:(NUUInt8)aValue at:(NUUInt64)anOffset;
- (void)writeUInt16:(NUUInt16)aValue at:(NUUInt64)anOffset;
- (void)writeUInt32:(NUUInt32)aValue at:(NUUInt64)anOffset;
- (void)writeUInt64:(NUUInt64)aValue at:(NUUInt64)anOffset;
- (void)writeUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset;
- (void)writeFloat:(NUFloat)aValue at:(NUUInt64)anOffset;
- (void)writeDouble:(NUDouble)aValue at:(NUUInt64)anOffset;
- (void)writeDoubleArray:(NUDouble *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset;
- (void)writeRegion:(NURegion)aValue at:(NUUInt64)anOffset;
- (void)writeRange:(NSRange)aValue at:(NUUInt64)anOffset;
- (void)writePoint:(NSPoint)aValue at:(NUUInt64)anOffset;
- (void)writeSize:(NSSize)aValue at:(NUUInt64)anOffset;
- (void)writeRect:(NSRect)aValue at:(NUUInt64)anOffset;

@end
