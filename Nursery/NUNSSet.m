//
//  NUNSSet.m
//  Nursery
//
//  Created by P,T,A on 2013/11/17.
//
//

#import "NUNSSet.h"
#import "NUCharacter.h"
#import "NUSandbox.h"
#import "NUSetCoder.h"

@implementation NSSet (NUCharacter)

+ (BOOL)automaticallyEstablishCharacter
{
	return [self isEqual:[NSSet class]] || [self isEqual:[NSMutableSet class]] || [self isEqual:[NUNSSet class]] || [self isEqual:[NUNSMutableSet class]];
}

- (Class)classForNursery
{
    if ([[self classForCoder] isSubclassOfClass:[NSMutableSet class]])
        return [NUNSMutableSet class];
    return [NUNSSet class];
}

- (NUUInt64)indexedIvarsSize
{
	return sizeof(NUUInt64) * [self count];
}

@end

@implementation NUNSSet

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
{
    [aCharacter setIsMutable:NO];
	[aCharacter setFormat:NUIndexedIvars];
	[aCharacter setCoderClass:[NUSetCoder class]];
}


@end

@implementation NUNSMutableSet

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
{
	[aCharacter setFormat:NUIndexedIvars];
	[aCharacter setCoderClass:[NUSetCoder class]];
}

@end
