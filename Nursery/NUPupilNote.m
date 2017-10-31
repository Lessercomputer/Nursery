//
//  NUPupilNote.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/06/29.
//
//

#import "NUPupilNote.h"
#import "NUBellBall.h"
#import "NURegion.h"

@implementation NUPupilNote

+ (id)pupilNoteWithOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade size:(NUUInt64)aSize
{
    return [[[self alloc] initWithOOP:anOOP grade:aGrade size:aSize bytes:NULL] autorelease];
}

+ (id)pupilNoteWithOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade size:(NUUInt64)aSize bytes:(NUUInt8 *)aBytes
{
    return [[[self alloc] initWithOOP:anOOP grade:aGrade size:aSize bytes:aBytes] autorelease];
}

- (id)initWithOOP:(NUUInt64)anOOP grade:(NUUInt64)aGrade size:(NUUInt64)aSize bytes:(NUUInt8 *)aBytes
{
    if (self = [super init])
    {
        bellBall = NUMakeBellBall(anOOP, aGrade);
        
        if (aBytes)
            data = [[NSMutableData alloc] initWithBytes:aBytes length:aSize];
        else
            data = [[NSMutableData alloc] initWithLength:aSize];
    }
    
    return self;
}

- (void)dealloc
{
    [data release];
    
    [super dealloc];
}

- (NSString *)description
{
    NSMutableString *aDescription = [[[super description] mutableCopy] autorelease];
    
    [aDescription appendString:@"{"];
    
    [aDescription appendFormat:@"oop: %llu, grade: %llu, isa: %llu, size: %llu", [self OOP], [self grade], [self isa], [self size]];
    
    [aDescription appendString:@"}"];
    
    return aDescription;
}

- (NUUInt64)OOP
{
    return bellBall.oop;
}

- (void)setOOP:(NUUInt64)anOOP
{
    bellBall.oop = anOOP;
}

- (NUUInt64)grade
{
    return bellBall.grade;
}

- (void)setGrade:(NUUInt64)aGrade
{
    bellBall.grade = aGrade;
}

- (NUBellBall)bellBall
{
    return bellBall;
}

- (void)setBellBall:(NUBellBall)aBellBall
{
    bellBall = aBellBall;
}

- (NUUInt64)size
{
    return [data length];
}

- (void)setSize:(NUUInt64)aSize
{
    [data setLength:aSize];
}

- (NUUInt64)isa
{
    return [self readUInt64At:0];
}

- (NSData *)data
{
    return data;
}

- (void)read:(NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset
{
    [data getBytes:aBytes range:NSMakeRange(anOffset, aLength)];
}

- (void)write:(const NUUInt8 *)aBytes length:(NUUInt64)aLength at:(NUUInt64)anOffset
{
    [data replaceBytesInRange:NSMakeRange(anOffset, aLength) withBytes:aBytes];
}

- (BOOL)readBOOLAt:(NUUInt64)anOffset
{
    BOOL aValue;
    [self read:(NUUInt8 *)&aValue length:sizeof(NUUInt8) at:anOffset];
    return aValue;
}

- (NUUInt8)readUInt8At:(NUUInt64)anOffset
{
    NUUInt8 aValue;
    [self read:(NUUInt8 *)&aValue length:sizeof(NUUInt8) at:anOffset];
    return aValue;
}

- (NUUInt16)readUInt16At:(NUUInt64)anOffset
{
    NUUInt16 aValue;
    [self read:(NUUInt8 *)&aValue length:sizeof(NUUInt16) at:anOffset];
    return aValue;
}

- (NUUInt32)readUInt32At:(NUUInt64)anOffset
{
    NUUInt32 aValue;
    [self read:(NUUInt8 *)&aValue length:sizeof(NUUInt32) at:anOffset];
    return aValue;
}

- (NUUInt64)readUInt64At:(NUUInt64)anOffset
{
    NUUInt64 aValue;
    [self read:(NUUInt8 *)&aValue length:sizeof(NUUInt64) at:anOffset];
    return NSSwapBigLongLongToHost(aValue);
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
    return NSMakeRange(aValue[0], aValue[1]);
}

- (NSPoint)readPointAt:(NUUInt64)anOffset
{
    NUDouble aValue[2];
    [self readDoubleArray:aValue ofCount:2 at:anOffset];
    return NSMakePoint(aValue[0], aValue[1]);
}

- (NSSize)readSizeAt:(NUUInt64)anOffset
{
    NUDouble aValue[2];
    [self readDoubleArray:aValue ofCount:2 at:anOffset];
    return NSMakeSize(aValue[0], aValue[1]);
}

- (NSRect)readRectAt:(NUUInt64)anOffset
{
    NUDouble aValue[4];
    [self readDoubleArray:aValue ofCount:4 at:anOffset];
    return NSMakeRect(aValue[0], aValue[1], aValue[2], aValue[3]);
}

- (void)writeBOOL:(BOOL)aValue at:(NUUInt64)anOffset
{
    [self write:(NUUInt8 *)&aValue length:sizeof(NUUInt8) at:anOffset];
}

- (void)writeUInt8:(NUUInt8)aValue at:(NUUInt64)anOffset
{
    [self write:&aValue length:sizeof(NUUInt8) at:anOffset];
}

- (void)writeUInt16:(NUUInt16)aValue at:(NUUInt64)anOffset
{
    aValue = NSSwapHostShortToBig(aValue);
    [self write:(NUUInt8 *)&aValue length:sizeof(NUUInt16) at:anOffset];
}

- (void)writeUInt32:(NUUInt32)aValue at:(NUUInt64)anOffset
{
    aValue = NSSwapHostIntToBig(aValue);
    [self write:(NUUInt8 *)&aValue length:sizeof(NUUInt32) at:anOffset];
}

- (void)writeUInt64:(NUUInt64)aValue at:(NUUInt64)anOffset
{
    aValue = NSSwapHostLongLongToBig(aValue);
    [self write:(NUUInt8 *)&aValue length:sizeof(NUUInt64) at:anOffset];
}

- (void)writeUInt64Array:(NUUInt64 *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset
{
    for (NUUInt64 i = 0; i < aCount; i++)
        [self writeUInt64:aValues[i] at:anOffset + (sizeof(NUUInt64) * i)];
}

- (void)writeFloat:(NUFloat)aValue at:(NUUInt64)anOffset
{
    NSSwappedFloat aSwappedValue = NSSwapHostFloatToBig(aValue);
    [self write:(NUUInt8 *)&aSwappedValue length:sizeof(NUFloat) at:anOffset];
}

- (void)writeDouble:(NUDouble)aValue at:(NUUInt64)anOffset
{
    NSSwappedDouble aSwappedValue = NSSwapHostDoubleToBig(aValue);
    [self write:(NUUInt8 *)&aSwappedValue length:sizeof(NUDouble) at:anOffset];
}

- (void)writeDoubleArray:(NUDouble *)aValues ofCount:(NUUInt64)aCount at:(NUUInt64)anOffset
{
    for (NUUInt64 i = 0; i < aCount; i++)
        [self writeDouble:aValues[i] at:anOffset + (sizeof(NUDouble) * i)];
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

- (void)writePoint:(NSPoint)aValue at:(NUUInt64)anOffset
{
    NUDouble anXAndY[2];
    anXAndY[0] = aValue.x;
    anXAndY[1] = aValue.y;
    [self writeDoubleArray:anXAndY ofCount:2 at:anOffset];
}

- (void)writeSize:(NSSize)aValue at:(NUUInt64)anOffset
{
    NUDouble anWidthandHeight[2];
    anWidthandHeight[0] = aValue.width;
    anWidthandHeight[1] = aValue.height;
    [self writeDoubleArray:anWidthandHeight ofCount:2 at:anOffset];
}

- (void)writeRect:(NSRect)aValue at:(NUUInt64)anOffset
{
    NUDouble anXandYAndWidthAndHeight[4];
    anXandYAndWidthAndHeight[0] = aValue.origin.x;
    anXandYAndWidthAndHeight[1] = aValue.origin.y;
    anXandYAndWidthAndHeight[2] = aValue.size.width;
    anXandYAndWidthAndHeight[3] = aValue.size.height;
    [self writeDoubleArray:anXandYAndWidthAndHeight ofCount:4 at:anOffset];
}

@end
