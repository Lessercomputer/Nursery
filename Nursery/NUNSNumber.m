//
//  NUNSNumber.m
//  Nursery
//
//  Created by P,T,A on 2013/11/17.
//
//

#import "NUNSNumber.h"
#import "NUNSObject.h"
#import "NUCharacter.h"
#import "NUPlayLot.h"
#import "NUNumberCoder.h"

@implementation NSNumber (NUCharacter)

+ (BOOL)automaticallyEstablishCharacter
{
    return [self isEqual:[NSNumber class]] || [self isEqual:[NUNSNumber class]];
}

- (Class)classForNursery
{
    return [NUNSNumber class];
}

- (NUUInt64)indexedIvarsSize
{
    const char *aNumberObjCType = [self objCType];
    NUUInt64 aLengthOfObjCType = strlen(aNumberObjCType);
    NUUInt64 anIndexedIvarsSize = sizeof(NUUInt64) + aLengthOfObjCType;
    
    if (strcmp(aNumberObjCType, @encode(unsigned char)) == 0)
        anIndexedIvarsSize += sizeof(unsigned char);
    else if (strcmp(aNumberObjCType, @encode(char)) == 0)
        anIndexedIvarsSize += sizeof(char);
    else if (strcmp(aNumberObjCType, @encode(unsigned short)) == 0)
        anIndexedIvarsSize += sizeof(unsigned short);
    else if (strcmp(aNumberObjCType, @encode(short)) == 0)
        anIndexedIvarsSize += sizeof(short);
    else if (strcmp(aNumberObjCType, @encode(unsigned int)) == 0)
        anIndexedIvarsSize += sizeof(unsigned int);
    else if (strcmp(aNumberObjCType, @encode(int)) == 0)
        anIndexedIvarsSize += sizeof(int);
    else if (strcmp(aNumberObjCType, @encode(unsigned long)) == 0)
        anIndexedIvarsSize += sizeof(unsigned long);
    else if (strcmp(aNumberObjCType, @encode(long)) == 0)
        anIndexedIvarsSize += sizeof(long);
    else if (strcmp(aNumberObjCType, @encode(unsigned long long)) == 0)
        anIndexedIvarsSize += sizeof(unsigned long long);
    else if (strcmp(aNumberObjCType, @encode(long long)) == 0)
        anIndexedIvarsSize += sizeof(long long);
    else if (strcmp(aNumberObjCType, @encode(float)) == 0)
        anIndexedIvarsSize += sizeof(float);
    else if (strcmp(aNumberObjCType, @encode(double)) == 0)
        anIndexedIvarsSize += sizeof(double);
    else if (strcmp(aNumberObjCType, @encode(BOOL)) == 0)
        anIndexedIvarsSize += sizeof(NUUInt8);
    else
        @throw [NSException exceptionWithName:@"NUInvalidNSNumber" reason:nil userInfo:nil];
    
    return anIndexedIvarsSize;
}

@end

@implementation NUNSNumber

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    [aCharacter setIsMutable:NO];
    [aCharacter setFormat:NUIndexedBytes];
    [aCharacter setCoderClass:[NUNumberCoder class]];
}

@end
