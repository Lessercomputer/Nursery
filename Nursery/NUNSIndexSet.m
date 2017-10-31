//
//  NUNSIndexSet.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/17.
//
//

#import "NUNSIndexSet.h"
#import "NUCharacter.h"
#import "NUSandbox.h"
#import "NUIndexSetCoder.h"

@implementation NSIndexSet (NUCharacter)

+ (BOOL)automaticallyEstablishCharacter
{
    return [self isEqual:[NSIndexSet class]] || [self isEqual:[NSMutableIndexSet class]];
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
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
