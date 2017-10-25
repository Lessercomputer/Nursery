//
//  NUNSIndexSet.m
//  Nursery
//
//  Created by P,T,A on 2013/11/17.
//
//

#import "NUNSIndexSet.h"
#import "NUCharacter.h"
#import "NUPlayLot.h"
#import "NUIndexSetCoder.h"

@implementation NSIndexSet (NUCharacter)

+ (BOOL)automaticallyEstablishCharacter
{
    return [self isEqual:[NSIndexSet class]] || [self isEqual:[NSMutableIndexSet class]];
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    if ([self isEqual:[NSIndexSet class]])
        [aCharacter setIsMutable:NO];
    
    [aCharacter setFormat:NUIndexedBytes];
    [aCharacter setCoderClass:[NUIndexSetCoder class]];
}

- (NUUInt64)indexedIvarsSize
{
    return sizeof(NUUInt64) * 2 * [NUIndexSetCoder getRangeCountInIndexSet:self];
}

@end
