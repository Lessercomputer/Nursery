//
//  NSData.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import "NUNSData.h"
#import "NUCharacter.h"
#import "NUGarden.h"
#import "NUDataCoder.h"

@implementation NSData (NUCharacter)

+ (BOOL)automaticallyEstablishCharacter
{
    return [self isEqual:[NSData class]] || [self isEqual:[NSMutableData class]];
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    if ([self isEqual:[NSData class]])
    {
        [aCharacter setIsMutable:NO];
    }
    
    [aCharacter setFormat:NUIndexedBytes];
    [aCharacter setCoderClass:[NUDataCoder class]];
}

- (NUUInt64)indexedIvarsSize
{
    return [self length];
}

@end
