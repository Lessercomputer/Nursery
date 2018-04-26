//
//  NUPupilNote.h
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUTypes.h"
#import "NUCodingNote.h"

@class NSMutableData;

@interface NUPupilNote : NSObject <NUCodingNote>
{
    NUBellBall bellBall;
    NSMutableData *data;
}

+ (id)pupilNoteWithOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade size:(NUUInt64)aSize;
+ (id)pupilNoteWithOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade size:(NUUInt64)aSize bytes:(NUUInt8 *)aBytes;

- (id)initWithOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade size:(NUUInt64)aSize bytes:(NUUInt8 *)aBytes;

- (NUUInt64)OOP;
- (void)setOOP:(NUUInt64)anOOP;
- (NUUInt64)grade;
- (void)setGrade:(NUUInt64)aGrade;
- (NUBellBall)bellBall;
- (void)setBellBall:(NUBellBall)aBellBall;
- (NUUInt64)size;
- (void)setSize:(NUUInt64)aSize;
- (NUUInt64)isa;

- (NSData *)data;

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

@end
