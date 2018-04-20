//
//  NUNSString.m
//  Nursery
//
//  Created by Akifumi Takata on 2013/11/16.
//
//

#import "NUNSString.h"
#import "NUCharacter.h"
#import "NUGarden.h"
#import "NUStringCoder.h"

@implementation NSString (NUCharacter)

- (Class)classForNursery
{
    if ([[self classForCoder] isSubclassOfClass:[NSMutableString class]])
        return [NUNSMutableString class];
    return [NUNSString class];
}

- (NUUInt64)indexedIvarsSize
{
	return [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NUNSString

+ (BOOL)automaticallyEstablishCharacter
{
    return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    [aCharacter setIsMutable:NO];
	[aCharacter setFormat:NUIndexedBytes];
	[aCharacter setCoderClass:[NUStringCoder class]];
}

@end

@implementation NUNSMutableString

+ (BOOL)automaticallyEstablishCharacter
{
    return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
	[aCharacter setFormat:NUIndexedBytes];
	[aCharacter setCoderClass:[NUStringCoder class]];
}

@end
