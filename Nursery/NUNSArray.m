//
//  NUNSArray.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/16.
//
//

#import "NUNSArray.h"
#import "NUCharacter.h"
#import "NUGarden.h"
#import "NUArrayCoder.h"

@implementation NSArray (NUCharacter)

- (Class)classForNursery
{
    if ([[self classForCoder] isSubclassOfClass:[NSMutableArray class]])
        return [NUNSMutableArray class];
    return [NUNSArray class];
}

- (NUUInt64)indexedIvarsSize
{
	return sizeof(NUUInt64) * [self count];
}

@end

@implementation NUNSArray

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    [aCharacter setIsMutable:NO];
	[aCharacter setFormat:NUIndexedIvars];
	[aCharacter setCoderClass:[NUArrayCoder class]];
}

@end

@implementation NUNSMutableArray

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
	[aCharacter setFormat:NUIndexedIvars];
	[aCharacter setCoderClass:[NUArrayCoder class]];
}

@end
